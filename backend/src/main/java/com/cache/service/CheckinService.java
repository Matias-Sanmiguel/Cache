package com.cache.service;

import com.cache.api.dto.CheckinEvent;
import com.cache.domain.cassandra.entity.CheckinHistory;
import com.cache.domain.cassandra.repository.CheckinHistoryRepository;
import com.cache.domain.mongo.document.EventDocument;
import java.time.Instant;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

// orquesta el check-in. redis se actualiza en el acto (tiempo real, crítico);
// el resto (neo4j + cassandra: grafo, historial y métricas) se delega a kafka y lo
// procesa CheckinConsumer fuera del hilo del request → check-in rápido y resiliente.
@Service
@RequiredArgsConstructor
@Slf4j
public class CheckinService {

    public static final String TOPIC = "domain.checkin";

    private final PresenceService presenceService;
    private final CheckinHistoryRepository checkinRepo;
    private final KafkaTemplate<String, Object> kafka;

    public void checkin(String userId, EventDocument event) {
        Instant now = Instant.now();

        // redis: presencia en tiempo real (sincrónico, más crítico)
        presenceService.markPresent(userId, event.getVenueId());
        presenceService.incrementAttendeeCount(event.getId());

        // resto del fan-out (neo4j + cassandra) async vía kafka
        kafka.send(TOPIC, userId, toEvent(userId, event, now));

        log.debug("checkin publicado: user={} event={} venue={}", userId, event.getId(), event.getVenueId());
    }

    public void checkout(String userId, String venueId) {
        presenceService.markDeparted(userId, venueId);
    }

    public List<CheckinHistory> getHistory(String userId, int limit) {
        return checkinRepo.findRecentByUserId(userId, limit);
    }

    private CheckinEvent toEvent(String userId, EventDocument event, Instant now) {
        String genre = event.getGenres() != null && !event.getGenres().isEmpty()
                ? event.getGenres().get(0)
                : null;
        long startsAt = event.getStartsAt() != null ? event.getStartsAt().toEpochMilli() : 0L;
        return new CheckinEvent(
                userId,
                event.getId(),
                event.getName(),
                event.getVenueId(),
                event.getVenueName(),
                genre,
                event.getCity(),
                startsAt,
                now.toEpochMilli());
    }
}
