package com.cache.service;

import com.cache.api.dto.CreateEventRequest;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.document.Role;
import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.mongo.repository.EventRepository;
import com.cache.domain.mongo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Metrics;
import org.springframework.data.geo.Point;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

// mongodb como catálogo: toda la info de un evento
@Service
@Slf4j
@RequiredArgsConstructor
public class EventCatalogService {

    private static final List<String> FEED_STATUSES = List.of("upcoming", "live");

    private final EventRepository eventRepository;
    private final PresenceService presenceService;
    private final UserRepository  userRepository;

    // --- alta de evento (solo VENUE_OWNER) ---

    // valida que el userId corresponda a un VENUE_OWNER, luego construye el EventDocument
    // asignando server-side: venueId (del UserDocument), hostUserId y status inicial.
    // el cliente no puede controlar ninguno de esos tres campos.
    public EventDocument createEvent(String userId, CreateEventRequest req) {
        UserDocument merchant = userRepository.findByUserId(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "usuario no encontrado"));

        if (merchant.getRole() != Role.VENUE_OWNER && merchant.getRole() != Role.ADMIN) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "solo los dueños de boliche pueden crear eventos");
        }

        EventDocument event = EventDocument.builder()
                .eventId(UUID.randomUUID().toString())   // id de negocio (EVT-…)
                .name(req.name())
                // venueId viene del perfil del merchant — el cliente no lo manda
                .venueId(merchant.getVenueId())
                .venueName(req.venueName())
                .venueAddress(req.venueAddress())
                .location(req.location())
                .startsAt(req.startsAt())
                .endsAt(req.endsAt())
                .genres(req.genres())
                .lineup(req.lineup())
                .price(req.price())
                .capacity(req.capacity())
                .description(req.description())
                .imageUrl(req.imageUrl())
                .flyerVariant(req.flyerVariant())
                .accessType(req.accessType())
                .city(req.city())
                // campos server-side: el cliente no puede pisarlos
                .hostUserId(userId)
                .status("upcoming")
                .attendeeCount(0)
                .build();

        EventDocument saved = eventRepository.save(event);
        log.info("evento creado: id={} venue={} merchant={}", saved.getId(), merchant.getVenueId(), userId);
        return saved;
    }

    // --- métodos existentes sin cambios ---

    public EventDocument save(EventDocument event) {
        return eventRepository.save(event);
    }

    public Optional<EventDocument> findById(String id) {
        return eventRepository.findById(id);
    }

    // eventos de un merchant — para la pantalla "mis eventos"
    public List<EventDocument> getByHost(String hostUserId) {
        return eventRepository.findByHostUserIdOrderByStartsAtDesc(hostUserId);
    }

    // todos los eventos — visión global del ADMIN
    public List<EventDocument> getAll() {
        return eventRepository.findAll();
    }

    public List<EventDocument> getByBusinessIdsInOrder(List<String> eventIds) {
        if (eventIds == null || eventIds.isEmpty()) return List.of();

        Map<String, EventDocument> byGraphId = new HashMap<>();
        eventRepository.findByEventIdIn(eventIds)
                .forEach(event -> byGraphId.put(event.getEventId(), event));
        eventRepository.findAllById(eventIds)
                .forEach(event -> byGraphId.putIfAbsent(event.getId(), event));

        return eventIds.stream()
                .map(byGraphId::get)
                .filter(Objects::nonNull)
                .toList();
    }

    // feed principal: eventos activos o próximos en la ciudad
    public List<EventDocument> getFeed(String city) {
        return eventRepository.findCityFeed(city, FEED_STATUSES, Instant.now());
    }

    // feed paginado, con filtro opcional por género
    public Page<EventDocument> getFeed(String city, String genre, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.ASC, "startsAt"));
        Instant now = Instant.now();
        if (genre != null && !genre.isBlank()) {
            return eventRepository.findCityFeedByGenre(city, FEED_STATUSES, now, genre, pageable);
        }
        return eventRepository.findCityFeed(city, FEED_STATUSES, now, pageable);
    }

    // eventos live ahora mismo
    public List<EventDocument> getLiveNow() {
        return eventRepository.findByStatusOrderByStartsAtAsc("live");
    }

    // eventos cerca de una coordenada (radio en km)
    public List<EventDocument> getNearby(double lat, double lon, double radiusKm) {
        return eventRepository.findByLocationNear(
                new Point(lon, lat),
                new Distance(radiusKm, Metrics.KILOMETERS)
        );
    }

    public List<EventDocument> searchByName(String query) {
        return eventRepository.searchByName(query);
    }

    // actualiza el conteo de anotados en mongo (eventual consistency con redis)
    public void syncAttendeeCount(String eventId, int count) {
        eventRepository.findById(eventId).ifPresent(e -> {
            e.setAttendeeCount(count);
            eventRepository.save(e);
        });
    }

    public void updateStatus(String eventId, String status) {
        eventRepository.findById(eventId).ifPresent(e -> {
            e.setStatus(status);
            eventRepository.save(e);
        });
    }

    // ---- jobs ----

    // upcoming → live (ya empezó)  y  live → finished (ya terminó)
    public int transitionStatuses() {
        Instant now = Instant.now();
        int changed = 0;

        for (EventDocument e : eventRepository.findByStatusAndStartsAtLessThanEqual("upcoming", now)) {
            e.setStatus("live");
            eventRepository.save(e);
            changed++;
            log.debug("evento {} upcoming → live", e.getId());
        }
        for (EventDocument e : eventRepository.findByStatusAndEndsAtLessThanEqual("live", now)) {
            e.setStatus("finished");
            eventRepository.save(e);
            changed++;
            log.debug("evento {} live → finished", e.getId());
        }
        return changed;
    }

    // sincroniza attendeeCount desde redis (contador volátil) hacia mongo (durable)
    public int syncAttendeeCountsFromRedis() {
        int synced = 0;
        List<EventDocument> active = eventRepository.findCityFeed(
                // todas las ciudades no se cubren acá; iteramos sobre live+upcoming vía status
                "buenos aires", FEED_STATUSES, Instant.now());
        for (EventDocument e : active) {
            long redisCount = presenceService.getAttendeeCount(e.getId());
            if (redisCount > 0 && redisCount != e.getAttendeeCount()) {
                e.setAttendeeCount((int) redisCount);
                eventRepository.save(e);
                synced++;
            }
        }
        return synced;
    }
}
