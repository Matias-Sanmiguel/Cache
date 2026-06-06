package com.cache.api.dto;

import com.cache.domain.mongo.document.LineupSlot;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

// lo que el VENUE_OWNER manda al crear un evento.
// venueId, hostUserId y status NO vienen del cliente — se asignan server-side
// a partir del UserDocument del merchant autenticado.
public record CreateEventRequest(
        String       name,
        String       venueName,
        String       venueAddress,
        GeoJsonPoint location,
        Instant      startsAt,
        Instant      endsAt,
        List<String> genres,
        List<LineupSlot> lineup,
        BigDecimal   price,
        int          capacity,
        String       description,
        String       imageUrl,
        String       flyerVariant,
        // public | private | invite-only
        String       accessType,
        String       city
) {}
