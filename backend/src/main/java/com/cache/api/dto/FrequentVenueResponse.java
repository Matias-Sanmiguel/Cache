package com.cache.api.dto;

// "venues frecuentes de tus amigos": cruce de neo4j (amigos) con cassandra (historial)
public record FrequentVenueResponse(
        String venueId,
        String venueName,
        long visits
) {}
