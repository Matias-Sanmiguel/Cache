package com.cache.service;

import com.cache.api.dto.EventDetailDTO;
import com.cache.api.dto.EventSummaryDTO;
import com.cache.api.dto.UserProfileDTO;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.neo4j.repository.UserNodeRepository;
import com.cache.domain.neo4j.repository.UserNodeRepository.EventFriendCountRow;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

// arma los DTOs de evento cruzando los motores:
//   mongo  → datos del catálogo
//   redis  → attendeeCount en vivo
//   neo4j  → friendCount / friendsAttending (relativo al user que consulta)
@Component
@RequiredArgsConstructor
public class EventAssembler {

    private final PresenceService        presenceService;
    private final UserNodeRepository     userNodeRepo;
    private final RecommendationService  recommendationService;

    // feed/mapa: resuelve friendCount en una sola consulta batch
    public List<EventSummaryDTO> toSummaries(List<EventDocument> events, String userId) {
        if (events.isEmpty()) return List.of();

        // endpoints públicos (SSR sin token): no hay userId → friendCount = 0
        Map<String, Long> friendCounts = (userId != null && !userId.isBlank())
                ? userFriendCounts(events, userId)
                : Map.of();

        return events.stream()
                .map(e -> EventSummaryDTO.from(
                        e,
                        attendeeCount(e),
                        friendCounts.getOrDefault(neo4jEventId(e), 0L)))
                .toList();
    }

    // detalle: incluye la lista de amigos que asisten
    public EventDetailDTO toDetail(EventDocument event, String userId) {
        List<UserProfileDTO> friends = List.of();
        boolean isAttending = false;
        if (userId != null && !userId.isBlank()) {
            String eventId = neo4jEventId(event);
            friends = recommendationService
                    .getFriendsAttendingEvent(userId, eventId).stream()
                    .map(UserProfileDTO::from)
                    .toList();
            isAttending = userNodeRepo.isAttendingEvent(userId, eventId);
        }

        return EventDetailDTO.from(event, attendeeCount(event), friends, isAttending);
    }

    // neo4j referencia eventos por `eventId` (id de negocio). para data legacy sin eventId,
    // caemos al _id de mongo (ej: seeds inline con ids tipo "e1").
    private String neo4jEventId(EventDocument e) {
        if (e.getEventId() != null && !e.getEventId().isBlank()) return e.getEventId();
        return e.getId();
    }

    private Map<String, Long> userFriendCounts(List<EventDocument> events, String userId) {
        List<String> eventIds = events.stream().map(this::neo4jEventId).toList();
        return userNodeRepo
                .countFriendsAttendingEvents(userId, eventIds).stream()
                .collect(Collectors.toMap(EventFriendCountRow::eventId, EventFriendCountRow::friendCount));
    }

    // contador en vivo de redis; si no hay, cae al valor persistido en mongo
    private int attendeeCount(EventDocument event) {
        long live = presenceService.getAttendeeCount(event.getId());
        return live > 0 ? (int) live : event.getAttendeeCount();
    }
}
