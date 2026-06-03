package com.cache.api.dto;

import com.cache.domain.mongo.document.EventDocument;

import java.time.Instant;
import java.util.List;

// versión liviana para feed y mapa. friendCount/attendeeCount se inyectan desde
// neo4j y redis (el assembler los resuelve), no salen del documento de mongo.
public record EventSummaryDTO(
        String id,
        String name,
        String venueName,
        Instant startsAt,
        List<String> genres,
        int attendeeCount,
        String status,
        GeoPointDTO location,
        long friendCount
) {
    public static EventSummaryDTO from(EventDocument e, int attendeeCount, long friendCount) {
        return new EventSummaryDTO(
                e.getId(),
                e.getName(),
                e.getVenueName(),
                e.getStartsAt(),
                e.getGenres(),
                attendeeCount,
                e.getStatus(),
                GeoPointDTO.from(e),
                friendCount
        );
    }
}
