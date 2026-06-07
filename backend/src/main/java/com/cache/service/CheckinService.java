package com.cache.service;

import com.cache.api.dto.CheckinEvent;
import com.cache.domain.cassandra.entity.CheckinHistory;
import com.cache.domain.cassandra.repository.CheckinHistoryRepository;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.neo4j.repository.UserNodeRepository;
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
    private final UserNodeRepository userNodeRepo;
    private final KafkaTemplate<String, Object> kafka;

    public void checkin(String userId, EventDocument event) {
        Instant now = Instant.now();
        String graphEventId = graphEventId(event);
        boolean alreadyAttending = userNodeRepo.isAttendingEvent(userId, graphEventId);

        // redis: presencia en tiempo real (sincrónico, más crítico).
        // el contador de anotados solo sube si el user no estaba anotado en neo4j.
        boolean newlyPresent = presenceService.markPresent(userId, event.getVenueId());
        if (newlyPresent && !alreadyAttending) {
            presenceService.incrementAttendeeCount(event.getId());
        }

        // resto del fan-out (neo4j + cassandra) async vía kafka
        if (!alreadyAttending) {
            kafka.send(TOPIC, userId, toEvent(userId, event, graphEventId, now));
        }

        log.debug("checkin publicado: user={} event={} venue={}", userId, event.getId(), event.getVenueId());
    }

    // salir del venue: borra presencia en vivo, pero conserva la anotación al evento.
    public void checkout(String userId, EventDocument event) {
        presenceService.markDeparted(userId, event.getVenueId());
    }

    public boolean isAttending(String userId, EventDocument event) {
        return userNodeRepo.isAttendingEvent(userId, graphEventId(event));
    }

    public boolean cancelAttendance(String userId, EventDocument event) {
        String eventId = graphEventId(event);
        boolean removed = userNodeRepo.isAttendingEvent(userId, eventId);
        if (removed) {
            userNodeRepo.deleteAttendance(userId, eventId);
            presenceService.markDeparted(userId, event.getVenueId());
            presenceService.decrementAttendeeCount(event.getId());
        }
        return removed;
    }

    public List<CheckinHistory> getHistory(String userId, int limit) {
        return checkinRepo.findRecentByUserId(userId, limit);
    }

    private CheckinEvent toEvent(String userId, EventDocument event, String graphEventId, Instant now) {
        String genre = event.getGenres() != null && !event.getGenres().isEmpty()
                ? event.getGenres().get(0)
                : null;
        long startsAt = event.getStartsAt() != null ? event.getStartsAt().toEpochMilli() : 0L;
        return new CheckinEvent(
                userId,
                graphEventId,
                event.getName(),
                event.getVenueId(),
                event.getVenueName(),
                genre,
                event.getCity(),
                startsAt,
                now.toEpochMilli());
    }

    private String graphEventId(EventDocument event) {
        if (event.getEventId() != null && !event.getEventId().isBlank()) {
            return event.getEventId();
        }
        return event.getId();
    }
}
