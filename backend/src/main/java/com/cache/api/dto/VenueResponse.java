package com.cache.api.dto;

import com.cache.domain.mongo.document.VenueDocument;

import java.util.List;

public record VenueResponse(
        String venueId,
        String name,
        String address,
        String city,
        Double lat,
        Double lon,
        int capacity,
        List<String> tags
) {
    public static VenueResponse from(VenueDocument v) {
        Double lat = v.getLocation() != null ? v.getLocation().getY() : null;
        Double lon = v.getLocation() != null ? v.getLocation().getX() : null;
        return new VenueResponse(
                v.getVenueId(),
                v.getName(),
                v.getAddress(),
                v.getCity(),
                lat,
                lon,
                v.getCapacity(),
                v.getTags()
        );
    }
}
