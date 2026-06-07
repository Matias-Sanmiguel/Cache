package com.cache.service;

import com.cache.api.dto.CheckinEvent;
import com.cache.api.dto.NotificationResponse;
import com.cache.domain.cassandra.entity.Notification;
import com.cache.domain.cassandra.repository.NotificationRepository;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.repository.EventRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

// notificaciones ("pings"). dos fuentes que se combinan en el feed:
//   1. PERSISTIDAS (cassandra): pings sociales dirigidos a un user — solicitudes de
//      amistad, aceptaciones, check-ins de amigos. tienen estado leído/no-leído y se
//      empujan en vivo por redis pub/sub (ver NotificationStreamService).
//   2. EFÍMERAS (computadas): eventos en vivo + recomendaciones de la red. se recalculan
//      en cada lectura, no se persisten ni tienen estado.
@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationService {

    private static final int MAX_LIVE = 4;
    private static final int MAX_RECOMMEND = 4;
    private static final int MAX_PERSISTED = 50;
    private static final String CHANNEL_PREFIX = "notifications:";
    private static final ZoneId BA_ZONE = ZoneId.of("America/Argentina/Buenos_Aires");

    private final EventRepository eventRepository;
    private final RecommendationService recommendationService;
    private final NotificationRepository notificationRepository;
    private final StringRedisTemplate stringRedis;
    private final ObjectMapper objectMapper;

    // ── lectura del feed ────────────────────────────────────────────────────────

    public List<NotificationResponse> forUser(String userId) {
        List<NotificationResponse> notifications = new ArrayList<>();

        // 1. pings sociales persistidos (los más nuevos primero)
        notificationRepository.findRecentByUserId(userId, MAX_PERSISTED)
                .forEach(n -> notifications.add(toResponse(n)));

        // 2. eventos en vivo ahora — ping urgente "EN VIVO" (efímero)
        eventRepository.findByStatusOrderByStartsAtAsc("live").stream()
                .limit(MAX_LIVE)
                .forEach(e -> notifications.add(liveNotification(e)));

        // 3. eventos donde va gente de tu red — recomendación social (efímero)
        recommendationService.getEventsFromFriendsNetwork(userId, MAX_RECOMMEND)
                .forEach(e -> notifications.add(recommendNotification(e)));

        return notifications;
    }

    // ── marcar leído ────────────────────────────────────────────────────────────

    // marca todas las notifs persistidas del user como leídas
    public void markAllRead(String userId) {
        notificationRepository.findRecentByUserId(userId, MAX_PERSISTED).forEach(n -> {
            if (!n.isRead()) {
                notificationRepository.markRead(userId, n.getCreatedAt(), n.getNotifId());
            }
        });
    }

    // marca una notif puntual — el id viene como "{epochMillis}:{uuid}" (ver toResponse)
    public void markRead(String userId, String encodedId) {
        int sep = encodedId.indexOf(':');
        if (sep < 0) return; // id efímero (live-/rec-): no es persistido, nada que marcar
        try {
            Instant createdAt = Instant.ofEpochMilli(Long.parseLong(encodedId.substring(0, sep)));
            UUID notifId = UUID.fromString(encodedId.substring(sep + 1));
            notificationRepository.markRead(userId, createdAt, notifId);
        } catch (IllegalArgumentException e) {
            log.warn("markRead: id inválido '{}'", encodedId);
        }
    }

    // ── creación de pings sociales (persistir + empujar en vivo) ─────────────────

    // un user recibió una solicitud de amistad — ping accionable (aceptar/rechazar)
    public void notifyFriendRequest(String toUserId, String fromUserId, String fromName, String fromColor) {
        create(Notification.builder()
                .userId(toUserId)
                .kind("friend-joined")
                .tag("SOLICITUD")
                .body(fromName + " quiere ser tu amigo.")
                .cta("ACEPTAR")
                .cta2("RECHAZAR")
                .refId(fromUserId) // el front lo usa para aceptar/rechazar la solicitud
                .avatarName(fromName)
                .avatarColor(fromColor)
                .build());
    }

    // a un user le aceptaron la solicitud que había enviado
    public void notifyFriendAccepted(String toUserId, String byName, String byColor) {
        create(Notification.builder()
                .userId(toUserId)
                .kind("friend-joined")
                .tag("AMIGO NUEVO")
                .body(byName + " aceptó tu solicitud.")
                .sub("ya son amigos")
                .avatarName(byName)
                .avatarColor(byColor)
                .build());
    }

    // un amigo hizo check-in en un evento → avisar a sus amigos
    public void notifyFriendCheckin(String toUserId, String friendName, String friendColor, EventDocument event) {
        create(Notification.builder()
                .userId(toUserId)
                .kind("live")
                .tag("AMIGO EN VIVO")
                .body(friendName + " está en " + event.getVenueName() + ".")
                .sub(zoneOf(event) + " · " + event.getName())
                .icon("fire")
                .cta("VER")
                .refId(event.getId())
                .avatarName(friendName)
                .avatarColor(friendColor)
                .build());
    }

    // variante para el flujo de check-in async (CheckinConsumer): el evento llega
    // desnormalizado en el CheckinEvent de kafka, sin releer mongo. zona = city
    // (el CheckinEvent no carga venueAddress, así que no hay barrio que extraer).
    public void notifyFriendCheckin(String toUserId, String friendName, String friendColor, CheckinEvent event) {
        String zona = event.city() != null && !event.city().isBlank() ? event.city() : "Buenos Aires";
        create(Notification.builder()
                .userId(toUserId)
                .kind("live")
                .tag("AMIGO EN VIVO")
                .body(friendName + " está en " + event.venueName() + ".")
                .sub(zona + " · " + event.eventName())
                .icon("fire")
                .cta("VER")
                .refId(event.eventId())
                .avatarName(friendName)
                .avatarColor(friendColor)
                .build());
    }

    // persiste la notif en cassandra y la publica en el canal redis del user.
    // best-effort: si cassandra/redis fallan, no rompe la operación que la disparó.
    public void create(Notification notif) {
        try {
            if (notif.getNotifId() == null) notif.setNotifId(UUID.randomUUID());
            if (notif.getCreatedAt() == null) notif.setCreatedAt(Instant.now());
            notificationRepository.save(notif);

            NotificationResponse payload = toResponse(notif);
            stringRedis.convertAndSend(CHANNEL_PREFIX + notif.getUserId(),
                    objectMapper.writeValueAsString(payload));
        } catch (Exception e) {
            log.warn("notif: no se pudo crear/publicar para userId={} — {}", notif.getUserId(), e.getMessage());
        }
    }

    // ── mappers / helpers ────────────────────────────────────────────────────────

    private NotificationResponse toResponse(Notification n) {
        // id compuesto: el front lo trata como opaco y lo devuelve al marcar leído
        String id = n.getCreatedAt().toEpochMilli() + ":" + n.getNotifId();
        NotificationResponse.Avatar avatar = n.getAvatarName() != null
                ? new NotificationResponse.Avatar(n.getAvatarName(), n.getAvatarColor())
                : null;
        return new NotificationResponse(
                id, n.getKind(), n.getTag(), relativeTime(n.getCreatedAt()),
                n.getBody(), n.getSub(), !n.isRead(), avatar, n.getIcon(),
                n.getCta(), n.getCta2(), n.getGrp() != null ? n.getGrp() : groupOf(n.getCreatedAt()),
                n.getRefId());
    }

    private NotificationResponse liveNotification(EventDocument e) {
        return new NotificationResponse(
                "live-" + e.getId(), "live", "EN VIVO", "AHORA",
                e.getName() + " está en vivo en " + e.getVenueName() + ".",
                zoneOf(e) + " · " + e.getAttendeeCount() + " adentro",
                true, null, "fire", "VER", null, "AHORA", e.getId());
    }

    private NotificationResponse recommendNotification(EventDocument e) {
        return new NotificationResponse(
                "rec-" + e.getId(), "recommend", "RECOMENDADO", "HOY",
                "va gente de tu red a " + e.getName() + ".",
                zoneOf(e) + " · " + e.getVenueName(),
                false, null, "spark", "ANOTARME", "VER", "HOY", e.getId());
    }

    // etiqueta de tiempo relativa para mostrar en el ping
    private String relativeTime(Instant when) {
        Duration d = Duration.between(when, Instant.now());
        long mins = d.toMinutes();
        if (mins < 1) return "AHORA";
        if (mins < 60) return mins + "m";
        long hours = d.toHours();
        if (hours < 24) return hours + "h";
        return when.atZone(BA_ZONE).toLocalDate().toString();
    }

    // agrupador del feed: HOY / ESTA SEMANA / ANTES
    private String groupOf(Instant when) {
        LocalDate day = when.atZone(BA_ZONE).toLocalDate();
        LocalDate today = LocalDate.now(BA_ZONE);
        if (day.isEqual(today)) return "HOY";
        if (day.isAfter(today.minusDays(7))) return "ESTA SEMANA";
        return "ANTES";
    }

    // "Palermo · Niceto Vega 5510" → "Palermo"; cae a city si no hay barrio
    private String zoneOf(EventDocument e) {
        String addr = e.getVenueAddress();
        if (addr != null && addr.contains("·")) {
            String zone = addr.split("·")[0].trim();
            if (!zone.isBlank()) return zone;
        }
        return e.getCity() != null && !e.getCity().isBlank() ? e.getCity() : "Buenos Aires";
    }
}
