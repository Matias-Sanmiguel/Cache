package com.cache.api.dto;

import jakarta.validation.constraints.NotBlank;

// usado por /auth/refresh y /auth/logout
public record TokenRequest(
        @NotBlank String refreshToken
) {}
