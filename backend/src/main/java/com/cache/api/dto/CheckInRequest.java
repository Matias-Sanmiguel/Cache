package com.cache.api.dto;

import jakarta.validation.constraints.NotBlank;

// payload de check-in del frontend: { userId, eventId, venueId }
public record CheckInRequest(
        @NotBlank String userId,
        @NotBlank String eventId,
        String venueId
) {}
