package com.cache.api.dto;

import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.document.LineupSlot;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

// versión completa para la pantalla de detalle: todo lo del summary + lineup,
// descripción, precio, capacidad y los amigos que asisten (neo4j).
public record EventDetailDTO(
        String id,
        String name,
        String venueId,
        String venueName,
        String venueAddress,
        Instant startsAt,
        Instant endsAt,
        List<String> genres,
        int attendeeCount,
        String status,
        GeoPointDTO location,
        long friendCount,
        List<LineupSlot> lineup,
        String description,
        BigDecimal price,
        int capacity,
        List<UserProfileDTO> friendsAttending
) {
    public static EventDetailDTO from(EventDocument e, int attendeeCount, List<UserProfileDTO> friendsAttending) {
        return new EventDetailDTO(
                e.getId(),
                e.getName(),
                e.getVenueId(),
                e.getVenueName(),
                e.getVenueAddress(),
                e.getStartsAt(),
                e.getEndsAt(),
                e.getGenres(),
                attendeeCount,
                e.getStatus(),
                GeoPointDTO.from(e),
                friendsAttending.size(),
                e.getLineup(),
                e.getDescription(),
                e.getPrice(),
                e.getCapacity(),
                friendsAttending
        );
    }
}
