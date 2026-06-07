package com.cache.api.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.PositiveOrZero;

import java.util.List;

// lo que el VENUE_OWNER manda al crear/asignar su venue.
// venueId se genera server-side y se vincula a la cuenta del merchant.
public record CreateVenueRequest(
        @NotBlank String name,
        String address,
        @NotBlank String city,
        @PositiveOrZero int capacity,
        List<String> tags
) {}
