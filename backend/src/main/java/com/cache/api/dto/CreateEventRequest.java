package com.cache.api.dto;

import com.cache.domain.mongo.document.LineupSlot;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

// lo que el VENUE_OWNER manda al crear un evento.
// venueId, hostUserId y status NO vienen del cliente — se asignan server-side
// a partir del UserDocument del merchant autenticado.
public record CreateEventRequest(
        @NotBlank
        String       name,

        @NotBlank
        String       venueName,

        @NotBlank
        String       venueAddress,

        GeoJsonPoint location,

        @NotNull @Future
        Instant      startsAt,

        @NotNull
        Instant      endsAt,

        @NotNull @Size(min = 1, max = 10)
        List<String> genres,

        List<LineupSlot> lineup,

        @NotNull @DecimalMin("0.00")
        BigDecimal   price,

        @Positive
        int          capacity,

        @Size(max = 2000)
        String       description,

        String       imageUrl,
        String       flyerVariant,

        // public | private | invite-only
        String       accessType,

        @NotBlank
        String       city
) {}
