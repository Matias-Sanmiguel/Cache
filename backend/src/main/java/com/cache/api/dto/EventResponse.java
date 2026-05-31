package com.cache.api.dto;

import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.document.LineupSlot;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

// shape estable para el frontend: aplana location (GeoJsonPoint) a lat/lon
public record EventResponse(
        String id,
        String name,
        String venueId,
        String venueName,
        String venueAddress,
        Double lat,
        Double lon,
        Instant startsAt,
        Instant endsAt,
        List<String> genres,
        List<LineupSlot> lineup,
        BigDecimal price,
        int capacity,
        int attendeeCount,
        String description,
        String imageUrl,
        String flyerVariant,
        String accessType,
        String hostUserId,
        String status,
        String city
) {
    public static EventResponse from(EventDocument e) {
        Double lat = e.getLocation() != null ? e.getLocation().getY() : null;
        Double lon = e.getLocation() != null ? e.getLocation().getX() : null;
        return new EventResponse(
                e.getId(),
                e.getName(),
                e.getVenueId(),
                e.getVenueName(),
                e.getVenueAddress(),
                lat,
                lon,
                e.getStartsAt(),
                e.getEndsAt(),
                e.getGenres(),
                e.getLineup(),
                e.getPrice(),
                e.getCapacity(),
                e.getAttendeeCount(),
                e.getDescription(),
                e.getImageUrl(),
                e.getFlyerVariant(),
                e.getAccessType(),
                e.getHostUserId(),
                e.getStatus(),
                e.getCity()
        );
    }
}
