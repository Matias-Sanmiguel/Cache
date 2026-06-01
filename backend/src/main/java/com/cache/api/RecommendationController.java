package com.cache.api;

import com.cache.api.dto.EventResponse;
import com.cache.api.dto.FriendSuggestionResponse;
import com.cache.api.dto.FrequentVenueResponse;
import com.cache.api.dto.UserResponse;
import com.cache.service.RecommendationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// neo4j como motor de recomendación social — superficie http de RecommendationService
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class RecommendationController {

    private final RecommendationService recommendationService;

    // eventos a los que van amigos del user
    @GetMapping("/users/{userId}/recommendations/events")
    public List<EventResponse> eventsFromFriends(
            @PathVariable String userId,
            @RequestParam(defaultValue = "10") int limit) {
        return recommendationService.getEventsFromFriendsNetwork(userId, limit).stream()
                .map(EventResponse::from).toList();
    }

    // personas que quizás conozca (amigos de amigos)
    @GetMapping("/users/{userId}/recommendations/people")
    public List<FriendSuggestionResponse> peopleYouMayKnow(
            @PathVariable String userId,
            @RequestParam(defaultValue = "10") int limit) {
        return recommendationService.getPeopleYouMayKnow(userId, limit);
    }

    // venues frecuentes de los amigos (cruce con historial de cassandra)
    @GetMapping("/users/{userId}/recommendations/venues")
    public List<FrequentVenueResponse> frequentVenues(
            @PathVariable String userId,
            @RequestParam(defaultValue = "10") int limit) {
        return recommendationService.getFrequentVenuesOfFriends(userId, limit);
    }

    // eventos populares en una ciudad — fallback para users sin amigos
    @GetMapping("/users/{userId}/recommendations/popular")
    public List<EventResponse> popularInCity(
            @PathVariable String userId,
            @RequestParam(defaultValue = "buenos aires") String city,
            @RequestParam(defaultValue = "10") int limit) {
        return recommendationService.getPopularEventsInCity(city, limit).stream()
                .map(EventResponse::from).toList();
    }

    // amigos del user que van a un evento — para el detalle del evento
    @GetMapping("/events/{eventId}/friends")
    public List<UserResponse> friendsAttendingEvent(
            @PathVariable String eventId,
            @RequestParam String userId) {
        return recommendationService.getFriendsAttendingEvent(userId, eventId).stream()
                .map(UserResponse::from).toList();
    }
}
