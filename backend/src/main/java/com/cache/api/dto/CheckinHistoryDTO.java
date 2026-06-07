package com.cache.api.dto;

import com.cache.domain.cassandra.entity.CheckinHistory;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.time.Instant;

@JsonInclude(JsonInclude.Include.NON_NULL)
public record CheckinHistoryDTO(
        Instant checkedAt,
        String  eventId,
        String  venueId,
        String  venueName,
        String  genre,
        String  city
) {
    public static CheckinHistoryDTO from(CheckinHistory h) {
        return new CheckinHistoryDTO(
                h.getCheckedAt(),
                h.getEventId(),
                h.getVenueId(),
                h.getVenueName(),
                h.getGenre(),
                h.getCity()
        );
    }
}
