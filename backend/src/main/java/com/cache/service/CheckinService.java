package com.cache.service;

import com.cache.domain.cassandra.entity.CheckinHistory;
import com.cache.domain.cassandra.entity.VenueTrend;
import com.cache.domain.cassandra.repository.CheckinHistoryRepository;
import com.cache.domain.cassandra.repository.VenueTrendRepository;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.neo4j.node.EventNode;
import com.cache.domain.neo4j.node.UserNode;
import com.cache.domain.neo4j.relationship.AttendingRel;
import com.cache.domain.neo4j.repository.EventNodeRepository;
import com.cache.domain.neo4j.repository.UserNodeRepository;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
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

    private final PresenceService presenceService;
    private final UserNodeRepository userNodeRepo;
    private final EventNodeRepository eventNodeRepo;
    private final CheckinHistoryRepository checkinRepo;
    private final VenueTrendRepository trendRepo;

    public void checkin(String userId, EventDocument event) {
        Instant now = Instant.now();

        // 1. redis: presencia en tiempo real (más rápido, más crítico)
        presenceService.markPresent(userId, event.getVenueId());
        presenceService.incrementAttendeeCount(event.getId());

        // 2. neo4j: relación para el motor de recomendación
        registerAttendingRelationship(userId, event, now);

        // 3. cassandra: historial inmutable
        appendCheckinHistory(userId, event, now);

        // 4. cassandra: agrega a tendencias del venue
        updateVenueTrend(event, now);

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
        LocalDateTime ldt = now
            .atZone(ZoneId.of("America/Argentina/Buenos_Aires"))
            .toLocalDateTime();
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
