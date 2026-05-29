package com.cache.service;

import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.repository.EventRepository;
import com.cache.domain.neo4j.repository.UserNodeRepository;
import com.cache.domain.neo4j.repository.UserNodeRepository.EventRecommendation;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

// neo4j como motor de recomendación social
// recorre el grafo de amistades para encontrar eventos relevantes
@Service
@RequiredArgsConstructor
public class RecommendationService {

    private final UserNodeRepository userNodeRepo;
    private final EventRepository    eventRepo;

    // eventos donde van amigos — principal algoritmo de descubrimiento
    public List<EventDocument> getEventsFromFriendsNetwork(String userId, int limit) {
        List<EventRecommendation> recommendations = userNodeRepo
                .findEventsAttendedByFriends(userId, System.currentTimeMillis(), limit);

        List<String> eventIds = recommendations.stream()
                .map(EventRecommendation::getEventId)
                .toList();

        return eventRepo.findAllById(eventIds);
    }

    // amigos que van a un evento específico — para mostrar en detalle de evento
    public List<String> getFriendsAttendingEvent(String userId, String eventId) {
        return userNodeRepo.findFriendsAttendingEvent(userId, eventId)
                .stream()
                .map(u -> u.getUserId())
                .toList();
    }
}
