package com.cache.service;

import com.cache.api.dto.CheckinEvent;
import com.cache.domain.cassandra.entity.CheckinHistory;
import com.cache.domain.cassandra.repository.CassandraDashboardRepository;
import com.cache.domain.cassandra.repository.CheckinHistoryRepository;
import com.cache.domain.neo4j.node.EventNode;
import com.cache.domain.neo4j.node.UserNode;
import com.cache.domain.neo4j.relationship.AttendingRel;
import com.cache.domain.neo4j.repository.EventNodeRepository;
import com.cache.domain.neo4j.repository.UserNodeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;

// consumidor del flujo de check-in. fuera del hilo del request hace las escrituras
// durables y de analytics: neo4j (grafo de recomendación) + cassandra (historial y métricas).
// redis ya se actualizó en CheckinService (tiempo real, sincrónico).
@Service
@Slf4j
@RequiredArgsConstructor
public class CheckinConsumer {

    private static final ZoneId BA_ZONE = ZoneId.of("America/Argentina/Buenos_Aires");

    private final UserNodeRepository userNodeRepo;
    private final EventNodeRepository eventNodeRepo;
    private final CheckinHistoryRepository checkinRepo;
    private final CassandraDashboardRepository dashboardRepo;

    @KafkaListener(topics = CheckinService.TOPIC, groupId = "cache-backend")
    public void onCheckin(CheckinEvent ev) {
        Instant occurredAt = Instant.ofEpochMilli(ev.occurredAtEpochMs());

        // neo4j primero: si ya estaba anotado, la anotación es idempotente y no
        // re-contamos en cassandra (evita inflar counters por doble check-in)
        boolean newlyAttending = registerAttending(ev, occurredAt);
        if (!newlyAttending) {
            log.debug("checkin ignorado (ya anotado): user={} event={}", ev.userId(), ev.eventId());
            return;
        }

        appendHistory(ev, occurredAt);

        LocalDateTime baTime = occurredAt.atZone(BA_ZONE).toLocalDateTime();
        dashboardRepo.recordCheckin(ev.venueId(), ev.userId(), baTime);

        log.debug("checkin procesado: user={} event={} venue={}", ev.userId(), ev.eventId(), ev.venueId());
    }

    // crea (o reutiliza) los nodos y la relación ATTENDING. devuelve true si la anotación es nueva.
    private boolean registerAttending(CheckinEvent ev, Instant now) {
        UserNode user = userNodeRepo.findByUserId(ev.userId()).orElseGet(() -> {
            UserNode n = new UserNode();
            n.setUserId(ev.userId());
            return userNodeRepo.save(n);
        });

        EventNode eventNode = eventNodeRepo.findByEventId(ev.eventId()).orElseGet(() -> {
            EventNode n = new EventNode();
            n.setEventId(ev.eventId());
            n.setName(ev.eventName());
            n.setVenueId(ev.venueId());
            n.setVenueName(ev.venueName());
            n.setGenre(ev.genre());
            n.setCity(ev.city());
            n.setStartsAtEpoch(ev.startsAtEpochMs());
            return eventNodeRepo.save(n);
        });

        boolean alreadyAttending = user.getAttending().stream()
                .anyMatch(r -> r.getEvent().getEventId().equals(ev.eventId()));
        if (alreadyAttending) return false;

        AttendingRel rel = new AttendingRel();
        rel.setEvent(eventNode);
        rel.setRegisteredAt(now);
        rel.setStatus("confirmed");
        user.getAttending().add(rel);
        userNodeRepo.save(user);
        return true;
    }

    private void appendHistory(CheckinEvent ev, Instant now) {
        checkinRepo.save(CheckinHistory.builder()
                .userId(ev.userId())
                .checkedAt(now)
                .eventId(ev.eventId())
                .venueId(ev.venueId())
                .venueName(ev.venueName())
                .genre(ev.genre())
                .city(ev.city())
                .build());
    }
}
