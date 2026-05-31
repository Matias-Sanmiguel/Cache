package com.cache.service;

import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Metrics;
import org.springframework.data.geo.Point;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

// mongodb como catálogo: toda la info de un evento
@Service
@Slf4j
@RequiredArgsConstructor
public class EventCatalogService {

    private static final List<String> FEED_STATUSES = List.of("upcoming", "live");

    private final EventRepository eventRepository;
    private final PresenceService presenceService;

    public EventDocument save(EventDocument event) {
        return eventRepository.save(event);
    }

    public Optional<EventDocument> findById(String id) {
        return eventRepository.findById(id);
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
