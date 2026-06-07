package com.cache.api.dto;

import com.cache.domain.mongo.document.EventDocument;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

// versión para feed y mapa. friendCount/attendeeCount se inyectan desde
// neo4j y redis (el assembler los resuelve), no salen del documento de mongo.
// incluye los campos que las cards del front renderizan (dirección, precio,
// capacidad, descripción, etc.) para no degradar a defaults genéricos.
public record EventSummaryDTO(
        String id,
        String name,
        String venueId,
        String venueName,
        String venueAddress,
        Instant startsAt,
        Instant endsAt,
        List<String> genres,
        int attendeeCount,
        BigDecimal price,
        int capacity,
        String description,
        String imageUrl,
        String flyerVariant,
        String accessType,
        String hostUserId,
        String status,
        String city,
        GeoPointDTO location,
        long friendCount
) {
    public static EventSummaryDTO from(EventDocument e, int attendeeCount, long friendCount) {
        return new EventSummaryDTO(
                e.getId(),
                e.getName(),
                e.getVenueId(),
                e.getVenueName(),
                e.getVenueAddress(),
                e.getStartsAt(),
                e.getEndsAt(),
                e.getGenres(),
                attendeeCount,
                e.getPrice(),
                e.getCapacity(),
                e.getDescription(),
                e.getImageUrl(),
                e.getFlyerVariant(),
                e.getAccessType(),
                e.getHostUserId(),
                e.getStatus(),
                e.getCity(),
                GeoPointDTO.from(e),
                friendCount
        );
    }
}
