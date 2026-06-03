package com.cache.api.dto;

import jakarta.validation.constraints.NotBlank;

public record CheckinRequestDTO(
        @NotBlank String eventId
) {}
