package com.cache.service;

import com.cache.api.dto.FrequentVenueResponse;
import com.cache.api.dto.FriendSuggestionResponse;
import com.cache.api.dto.UserResponse;
import com.cache.domain.cassandra.entity.CheckinHistory;
import com.cache.domain.cassandra.repository.CheckinHistoryRepository;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.mongo.repository.EventRepository;
import com.cache.domain.mongo.repository.UserRepository;
import com.cache.domain.neo4j.repository.EventNodeRepository;
import com.cache.domain.neo4j.repository.EventNodeRepository.PopularEvent;
import com.cache.domain.neo4j.repository.UserNodeRepository;
import com.cache.domain.neo4j.repository.UserNodeRepository.PersonSuggestion;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

// neo4j como motor de recomendación social.
// recorre el grafo de amistades y, cuando hace falta, cruza con mongo (catálogo)
// y cassandra (historial) para producir recomendaciones.
@Service
@RequiredArgsConstructor
public class RecommendationService {

    private static final int HISTORY_LOOKBACK = 50; // check-ins recientes por amigo a inspeccionar

    private final UserNodeRepository userNodeRepo;
    private final EventNodeRepository eventNodeRepo;
    private final EventRepository eventRepo;
    private final UserRepository userRepo;
    private final CheckinHistoryRepository checkinRepo;
    private final AuditService auditService;

    // eventos donde van amigos — principal algoritmo de descubrimiento
    public List<EventDocument> getEventsFromFriendsNetwork(
        String userId,
        int limit
    ) {
        auditService.logActivity(
            userId,
            "RECOMMENDATION_REQUESTED",
            "EVENT",
            null,
            "friends-network limit=" + limit
        );

        // el grafo tiene muchos más eventos que el catálogo de mongo, así que pedimos
        // un pool grande de candidatos (ordenados por #amigos) y nos quedamos con los
        // primeros `limit` que existen en mongo.
        List<String> eventIds = userNodeRepo.findEventsAttendedByFriends(
            userId,
            System.currentTimeMillis(),
            Math.max(limit * 25, 100)
        );

        List<EventDocument> recommendations = resolveEventsInOrder(eventIds)
            .stream()
            .limit(limit)
            .toList();
        auditEventRecommendations(userId, recommendations, "FRIEND_ATTENDING");
        return recommendations;
    }

    // amigos que van a un evento específico — para mostrar en el detalle del evento
    public List<UserDocument> getFriendsAttendingEvent(
        String userId,
        String eventId
    ) {
        List<String> ids = userNodeRepo
            .findFriendsAttendingEvent(userId, eventId)
            .stream()
            .map(u -> u.getUserId())
            .toList();
        return resolveUsersInOrder(ids);
    }

    // "personas que quizás conozcas": amigos de amigos sin relación directa
    public List<FriendSuggestionResponse> getPeopleYouMayKnow(
        String userId,
        int limit
    ) {
        List<PersonSuggestion> suggestions = userNodeRepo.findPeopleYouMayKnow(
            userId,
            limit
        );

        Map<String, UserDocument> profiles = userRepo
            .findByUserIdIn(
                suggestions.stream().map(PersonSuggestion::getUserId).toList()
            )
            .stream()
            .collect(
                Collectors.toMap(UserDocument::getUserId, Function.identity())
            );

        return suggestions
            .stream()
            .filter(s -> profiles.containsKey(s.getUserId()))
            .map(s ->
                new FriendSuggestionResponse(
                    UserResponse.from(profiles.get(s.getUserId())),
                    s.getMutualFriends()
                )
            )
            .toList();
    }

    // "eventos populares en tu ciudad" — fallback para usuarios sin amigos aún
    public List<EventDocument> getPopularEventsInCity(String city, int limit) {
        return getPopularEventsInCity(null, city, limit);
    }

    // variante auditada: usada por el endpoint, que sí conoce el usuario autenticado
    public List<EventDocument> getPopularEventsInCity(
        String userId,
        String city,
        int limit
    ) {
        if (userId != null && !userId.isBlank()) {
            auditService.logActivity(
                userId,
                "RECOMMENDATION_REQUESTED",
                "EVENT",
                null,
                "popular-in-city city=" + city + " limit=" + limit
            );
        }

        List<PopularEvent> popular = eventNodeRepo.findPopularEventsInCity(
            city,
            System.currentTimeMillis(),
            limit
        );

        List<EventDocument> recommendations = resolveEventsInOrder(
            popular.stream().map(PopularEvent::getEventId).toList()
        );
        if (userId != null && !userId.isBlank()) {
            auditEventRecommendations(userId, recommendations, "POPULAR_IN_CITY");
        }
        return recommendations;
    }

    // "venues frecuentes de tus amigos": neo4j da los amigos, cassandra su historial de check-ins.
    // agrega por venue y ordena por cantidad de visitas
    public List<FrequentVenueResponse> getFrequentVenuesOfFriends(
        String userId,
        int limit
    ) {
        auditService.logActivity(
            userId,
            "RECOMMENDATION_REQUESTED",
            "VENUE",
            null,
            "friends-frequent-venues limit=" + limit
        );

        List<String> friendIds = userNodeRepo.findFriendIds(userId);
        if (friendIds.isEmpty()) {
            auditService.logActivity(
                userId,
                "RECOMMENDATION_EMPTY",
                "VENUE",
                null,
                "friends-frequent-venues: user has no friends"
            );
            return List.of();
        }

        // acumula visitas por venue conservando el nombre más reciente visto
        Map<String, long[]> counts = new LinkedHashMap<>();
        Map<String, String> names = new LinkedHashMap<>();

        for (String friendId : friendIds) {
            for (CheckinHistory h : checkinRepo.findRecentByUserId(
                friendId,
                HISTORY_LOOKBACK
            )) {
                if (h.getVenueId() == null) continue;
                counts.computeIfAbsent(h.getVenueId(), k -> new long[1])[0]++;
                names.putIfAbsent(h.getVenueId(), h.getVenueName());
            }
        }

        List<FrequentVenueResponse> recommendations = counts
            .entrySet()
            .stream()
            .sorted(
                Comparator.comparingLong(
                    (Map.Entry<String, long[]> e) -> e.getValue()[0]
                ).reversed()
            )
            .limit(limit)
            .map(e ->
                new FrequentVenueResponse(
                    e.getKey(),
                    names.get(e.getKey()),
                    e.getValue()[0]
                )
            )
            .toList();
        auditVenueRecommendations(userId, recommendations);
        return recommendations;
    }

    // — helpers —

    // resuelve eventIds del grafo a documentos de mongo, preservando el orden del ranking
    private List<EventDocument> resolveEventsInOrder(List<String> eventIds) {
        if (eventIds.isEmpty()) return List.of();
        // neo4j devuelve el id de negocio (EVT001…), no el _id de mongo → resolver por eventId
        Map<String, EventDocument> byId = eventRepo
            .findByEventIdIn(eventIds)
            .stream()
            .collect(
                Collectors.toMap(
                    EventDocument::getEventId,
                    Function.identity(),
                    (a, b) -> a
                )
            );
        return eventIds
            .stream()
            .map(byId::get)
            .filter(java.util.Objects::nonNull)
            .toList();
    }

    private List<UserDocument> resolveUsersInOrder(List<String> userIds) {
        if (userIds.isEmpty()) return List.of();
        Map<String, UserDocument> byId = userRepo
            .findByUserIdIn(userIds)
            .stream()
            .collect(
                Collectors.toMap(UserDocument::getUserId, Function.identity())
            );
        return userIds
            .stream()
            .map(byId::get)
            .filter(java.util.Objects::nonNull)
            .toList();
    }

    private void auditEventRecommendations(
        String userId,
        List<EventDocument> recommendations,
        String reason
    ) {
        if (recommendations.isEmpty()) {
            auditService.logActivity(
                userId,
                "RECOMMENDATION_EMPTY",
                "EVENT",
                null,
                reason + ": no recommendations found"
            );
            return;
        }

        auditService.logActivity(
            userId,
            "RECOMMENDATION_RETURNED",
            "EVENT",
            null,
            reason + ": count=" + recommendations.size()
        );

        for (int i = 0; i < recommendations.size(); i++) {
            EventDocument event = recommendations.get(i);
            String eventId = event.getEventId() != null
                ? event.getEventId()
                : event.getId();
            double rankScore = recommendations.size() - i;
            auditService.logRecommendation(userId, eventId, rankScore, reason);
        }
    }

    private void auditVenueRecommendations(
        String userId,
        List<FrequentVenueResponse> recommendations
    ) {
        if (recommendations.isEmpty()) {
            auditService.logActivity(
                userId,
                "RECOMMENDATION_EMPTY",
                "VENUE",
                null,
                "FRIENDS_FREQUENT_VENUE: no recommendations found"
            );
            return;
        }

        auditService.logActivity(
            userId,
            "RECOMMENDATION_RETURNED",
            "VENUE",
            null,
            "FRIENDS_FREQUENT_VENUE: count=" + recommendations.size()
        );

        for (FrequentVenueResponse venue : recommendations) {
            auditService.logActivity(
                userId,
                "RECOMMENDATION_RETURNED",
                "VENUE",
                venue.venueId(),
                "FRIENDS_FREQUENT_VENUE visits=" + venue.visits()
            );
        }
    }
}
