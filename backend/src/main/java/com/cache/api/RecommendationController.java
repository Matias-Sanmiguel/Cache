package com.cache.api;

import com.cache.api.dto.EventSummaryDTO;
import com.cache.api.dto.FrequentVenueResponse;
import com.cache.api.dto.FriendSuggestionResponse;
import com.cache.api.dto.UserProfileDTO;
import com.cache.service.EventAssembler;
import com.cache.service.RecommendationService;
import com.cache.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// neo4j como motor de recomendación social — todo relativo al user autenticado (me)
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class RecommendationController {

    private final RecommendationService recommendationService;
    private final EventAssembler        eventAssembler;
    private final UserService           userService;

    // eventos a los que van amigos del user
    @GetMapping("/recommendations/events")
    public List<EventSummaryDTO> eventsFromFriends(
            @AuthenticationPrincipal String me,
            @RequestParam(defaultValue = "10") int limit) {
        return eventAssembler.toSummaries(
                recommendationService.getEventsFromFriendsNetwork(me, limit), me);
    }

    // personas que quizás conozca (amigos de amigos)
    @GetMapping("/recommendations/people")
    public List<FriendSuggestionResponse> peopleYouMayKnow(
            @AuthenticationPrincipal String me,
            @RequestParam(defaultValue = "10") int limit) {
        return recommendationService.getPeopleYouMayKnow(me, limit);
    }

    // venues frecuentes de los amigos (cruce con historial de cassandra)
    @GetMapping("/recommendations/venues")
    public List<FrequentVenueResponse> frequentVenues(
            @AuthenticationPrincipal String me,
            @RequestParam(defaultValue = "10") int limit) {
        return recommendationService.getFrequentVenuesOfFriends(me, limit);
    }

    // eventos populares en una ciudad — fallback para users sin amigos.
    // si no se pasa city, usa la del perfil del user
    @GetMapping("/recommendations/popular")
    public List<EventSummaryDTO> popularInCity(
            @AuthenticationPrincipal String me,
            @RequestParam(required = false) String city,
            @RequestParam(defaultValue = "10") int limit) {
        String resolvedCity = (city != null && !city.isBlank())
                ? city
                : userService.findById(me).map(u -> u.getCity()).orElse("buenos aires");
        return eventAssembler.toSummaries(
                recommendationService.getPopularEventsInCity(resolvedCity, limit), me);
    }

    // amigos del user que asisten a un evento — para el detalle del evento
    @GetMapping("/events/{id}/friends-attending")
    public List<UserProfileDTO> friendsAttending(
            @AuthenticationPrincipal String me,
            @PathVariable String id) {
        return recommendationService.getFriendsAttendingEvent(me, id).stream()
                .map(UserProfileDTO::from)
                .toList();
    }
}
