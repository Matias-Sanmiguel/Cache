package com.cache.service;

import com.cache.api.dto.EventDetailDTO;
import com.cache.api.dto.EventSummaryDTO;
import com.cache.api.dto.UserProfileDTO;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.neo4j.repository.UserNodeRepository;
import com.cache.domain.neo4j.repository.UserNodeRepository.EventFriendCount;
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

        List<String> eventIds = events.stream().map(EventDocument::getId).toList();
        Map<String, Long> friendCounts = userNodeRepo
                .countFriendsAttendingEvents(userId, eventIds).stream()
                .collect(Collectors.toMap(EventFriendCount::getEventId, EventFriendCount::getFriendCount));

        return events.stream()
                .map(e -> EventSummaryDTO.from(
                        e,
                        attendeeCount(e),
                        friendCounts.getOrDefault(e.getId(), 0L)))
                .toList();
    }

    // detalle: incluye la lista de amigos que asisten
    public EventDetailDTO toDetail(EventDocument event, String userId) {
        List<UserProfileDTO> friends = recommendationService
                .getFriendsAttendingEvent(userId, event.getId()).stream()
                .map(UserProfileDTO::from)
                .toList();

        return EventDetailDTO.from(event, attendeeCount(event), friends);
    }

    // contador en vivo de redis; si no hay, cae al valor persistido en mongo
    private int attendeeCount(EventDocument event) {
        long live = presenceService.getAttendeeCount(event.getId());
        return live > 0 ? (int) live : event.getAttendeeCount();
    }
}
