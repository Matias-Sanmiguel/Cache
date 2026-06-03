package com.cache.service;

import com.cache.api.dto.NotificationResponse;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

// genera el feed de "pings" a partir de datos reales:
// eventos en vivo (mongo) + recomendaciones de la red social (neo4j vía RecommendationService)
@Service
@RequiredArgsConstructor
public class NotificationService {

    private static final int MAX_LIVE = 4;
    private static final int MAX_RECOMMEND = 4;

    private final EventRepository eventRepository;
    private final RecommendationService recommendationService;

    public List<NotificationResponse> forUser(String userId) {
        List<NotificationResponse> notifications = new ArrayList<>();

        // eventos en vivo ahora — ping urgente "EN VIVO"
        eventRepository.findByStatusOrderByStartsAtAsc("live").stream()
                .limit(MAX_LIVE)
                .forEach(e -> notifications.add(liveNotification(e)));

        // eventos donde va gente de tu red — recomendación social
        recommendationService.getEventsFromFriendsNetwork(userId, MAX_RECOMMEND)
                .forEach(e -> notifications.add(recommendNotification(e)));

        return notifications;
    }

    private NotificationResponse liveNotification(EventDocument e) {
        return new NotificationResponse(
                "live-" + e.getId(),
                "live",
                "EN VIVO",
                "AHORA",
                e.getName() + " está en vivo en " + e.getVenueName() + ".",
                zoneOf(e) + " · " + e.getAttendeeCount() + " adentro",
                true,
                null,
                "fire",
                "VER",
                null,
                "AHORA"
        );
    }

    private NotificationResponse recommendNotification(EventDocument e) {
        return new NotificationResponse(
                "rec-" + e.getId(),
                "recommend",
                "RECOMENDADO",
                "HOY",
                "va gente de tu red a " + e.getName() + ".",
                zoneOf(e) + " · " + e.getVenueName(),
                false,
                null,
                "spark",
                "ANOTARME",
                "VER",
                "HOY"
        );
    }

    // "Palermo · Niceto Vega 5510" → "Palermo"; cae a city si no hay barrio
    private String zoneOf(EventDocument e) {
        String addr = e.getVenueAddress();
        if (addr != null && addr.contains("·")) {
            String zone = addr.split("·")[0].trim();
            if (!zone.isBlank()) return zone;
        }
        return e.getCity() != null && !e.getCity().isBlank() ? e.getCity() : "Buenos Aires";
    }
}
