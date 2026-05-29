package com.cache.service;

import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Metrics;
import org.springframework.data.geo.Point;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

// mongodb como catálogo: toda la info de un evento
@Service
@RequiredArgsConstructor
public class EventCatalogService {

    private final EventRepository eventRepository;

    public EventDocument save(EventDocument event) {
        return eventRepository.save(event);
    }

    public Optional<EventDocument> findById(String id) {
        return eventRepository.findById(id);
    }

    // feed principal: eventos activos o próximos en la ciudad
    public List<EventDocument> getFeed(String city) {
        return eventRepository.findCityFeed(
                city,
                List.of("upcoming", "live"),
                Instant.now()
        );
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
}
