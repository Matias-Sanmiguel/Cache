package com.cache.service;

import com.cache.domain.cassandra.entity.AsistenciaPorEvento;
import com.cache.domain.cassandra.entity.CheckinHistory;
import com.cache.domain.cassandra.entity.VenueTrend;
import com.cache.domain.cassandra.repository.AsistenciaPorEventoRepository;
import com.cache.domain.cassandra.repository.CheckinHistoryRepository;
import com.cache.domain.cassandra.repository.DashboardCounterRepository;
import com.cache.domain.cassandra.repository.VenueTrendRepository;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.mongo.repository.UserRepository;
import com.cache.domain.neo4j.node.EventNode;
import com.cache.domain.neo4j.node.UserNode;
import com.cache.domain.neo4j.relationship.AttendingRel;
import com.cache.domain.neo4j.repository.EventNodeRepository;
import com.cache.domain.neo4j.repository.UserNodeRepository;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

// orquesta el flujo de check-in entre los cuatro motores
// redis  → presencia inmediata
// neo4j  → relación ATTENDING para recomendaciones
// cassandra → historial append-only
@Service
@RequiredArgsConstructor
@Slf4j
public class CheckinService {

    private static final ZoneId BA_ZONE = ZoneId.of("America/Argentina/Buenos_Aires");

    private final PresenceService presenceService;
    private final UserNodeRepository userNodeRepo;
    private final EventNodeRepository eventNodeRepo;
    private final CheckinHistoryRepository checkinRepo;
    private final VenueTrendRepository trendRepo;
    private final AsistenciaPorEventoRepository asistenciaRepo;
    private final DashboardCounterRepository counterRepo;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public void checkin(String userId, EventDocument event) {
        Instant now = Instant.now();
        UserDocument user = userRepository.findByUserId(userId).orElse(null);

        // 1. redis: presencia en tiempo real (más rápido, más crítico)
        presenceService.markPresent(userId, event.getVenueId());
        presenceService.incrementAttendeeCount(event.getId());

        // 2. neo4j: relación para el motor de recomendación
        registerAttendingRelationship(userId, event, now);

        // 3. cassandra: historial inmutable
        appendCheckinHistory(userId, event, now);

        // 4. cassandra: agrega a tendencias del venue
        updateVenueTrend(event, now);

        // 5. cassandra: tablas de analítica del dashboard
        appendDashboardTables(userId, user, event, now);

        // 6. notificar a los amigos (persistido en cassandra + push redis/SSE)
        notifyFriends(userId, user, event);

        log.debug(
            "checkin: user={} event={} venue={}",
            userId,
            event.getId(),
            event.getVenueId()
        );
    }

    public void checkout(String userId, String venueId) {
        presenceService.markDeparted(userId, venueId);
    }

    public List<CheckinHistory> getHistory(String userId, int limit) {
        return checkinRepo.findRecentByUserId(userId, limit);
    }

    // — helpers privados —

    // avisa a los amigos (neo4j) que el user hizo check-in. best-effort: cualquier
    // fallo acá no debe tumbar el check-in (ya persistido en los pasos anteriores).
    private void notifyFriends(String userId, UserDocument actor, EventDocument event) {
        try {
            if (actor == null) return;
            for (String friendId : userNodeRepo.findFriendIds(userId)) {
                notificationService.notifyFriendCheckin(
                        friendId, actor.getDisplayName(), actor.getAvatarColor(), event);
            }
        } catch (Exception e) {
            log.warn("checkin: no se pudo notificar a amigos de user={} — {}", userId, e.getMessage());
        }
    }

    // escribe en las 4 tablas analíticas del dashboard. best-effort.
    private void appendDashboardTables(String userId, UserDocument user, EventDocument event, Instant now) {
        try {
            LocalDateTime ldt = now.atZone(BA_ZONE).toLocalDateTime();
            String fecha = ldt.format(DateTimeFormatter.ISO_LOCAL_DATE);
            int hora = ldt.getHour();
            int weekNum = ldt.get(WeekFields.ISO.weekOfWeekBasedYear());
            int weekYear = ldt.get(WeekFields.ISO.weekBasedYear());
            String semana = String.format("%d-W%02d", weekYear, weekNum);
            String zona = zoneOf(event);
            String genre = event.getGenres() != null && !event.getGenres().isEmpty()
                    ? event.getGenres().get(0) : "otros";
            String handle = user != null ? user.getHandle() : userId;

            // 1. asistencias_por_evento — append inmutable (tabla regular)
            asistenciaRepo.save(AsistenciaPorEvento.builder()
                    .eventId(event.getId())
                    .anotadoAt(now)
                    .userId(userId)
                    .userHandle(handle)
                    .zona(zona)
                    .genre(genre)
                    .build());

            // 2-4. counters — UPDATE atómico vía CQL raw
            counterRepo.incrementZona(semana, zona);
            counterRepo.incrementGenero(fecha, genre);
            counterRepo.incrementPico(fecha, hora);

        } catch (Exception e) {
            log.warn("checkin: fallo escritura dashboard tables para user={} — {}", userId, e.getMessage());
        }
    }

    // "Palermo · Niceto Vega 5510" → "Palermo"; fallback a city
    private String zoneOf(EventDocument event) {
        String addr = event.getVenueAddress();
        if (addr != null && addr.contains("·")) {
            String zone = addr.split("·")[0].trim();
            if (!zone.isBlank()) return zone;
        }
        return event.getCity() != null && !event.getCity().isBlank() ? event.getCity() : "Sin zona";
    }

    private void registerAttendingRelationship(
        String userId,
        EventDocument event,
        Instant now
    ) {
        String graphEventId = event.getEventId() != null
            ? event.getEventId()
            : event.getId();

        UserNode user = userNodeRepo.findByUserId(userId).orElseGet(() -> {
            UserNode n = new UserNode();
            n.setUserId(userId);
            return userNodeRepo.save(n);
        });

        EventNode eventNode = eventNodeRepo
            .findByEventId(graphEventId)
            .orElseGet(() -> {
                EventNode n = new EventNode();
                n.setEventId(graphEventId);
                n.setName(event.getName());
                n.setVenueId(event.getVenueId());
                n.setVenueName(event.getVenueName());
                n.setGenre(
                    event.getGenres() != null && !event.getGenres().isEmpty()
                        ? event.getGenres().get(0)
                        : null
                );
                n.setCity(event.getCity());
                n.setStartsAtEpoch(
                    event.getStartsAt() != null
                        ? event.getStartsAt().toEpochMilli()
                        : 0L
                );
                return eventNodeRepo.save(n);
            });

        boolean alreadyAttending = user
            .getAttending()
            .stream()
            .anyMatch(r -> r.getEvent().getEventId().equals(graphEventId));

        if (!alreadyAttending) {
            AttendingRel rel = new AttendingRel();
            rel.setEvent(eventNode);
            rel.setRegisteredAt(now);
            rel.setStatus("confirmed");
            user.getAttending().add(rel);
            userNodeRepo.save(user);
        }
    }

    private void appendCheckinHistory(
        String userId,
        EventDocument event,
        Instant now
    ) {
        CheckinHistory entry = CheckinHistory.builder()
            .userId(userId)
            .checkedAt(now)
            .eventId(event.getId())
            .venueId(event.getVenueId())
            .venueName(event.getVenueName())
            .genre(
                event.getGenres() != null && !event.getGenres().isEmpty()
                    ? event.getGenres().get(0)
                    : null
            )
            .city(event.getCity())
            .build();
        checkinRepo.save(entry);
    }

    private void updateVenueTrend(EventDocument event, Instant now) {
        LocalDateTime ldt = now.atZone(BA_ZONE).toLocalDateTime();
        String date = ldt.format(DateTimeFormatter.ISO_LOCAL_DATE);
        int hour = ldt.getHour();

        List<VenueTrend> existing = trendRepo.findHourlyTrend(
            event.getVenueId(),
            date
        );
        VenueTrend trend = existing
            .stream()
            .filter(t -> t.getHour() == hour)
            .findFirst()
            .orElse(
                VenueTrend.builder()
                    .venueId(event.getVenueId())
                    .date(date)
                    .hour(hour)
                    .checkinCount(0)
                    .uniqueUsers(0)
                    .build()
            );

        trend.setCheckinCount(trend.getCheckinCount() + 1);
        trend.setUniqueUsers(trend.getUniqueUsers() + 1);
        trendRepo.save(trend);
    }
}
