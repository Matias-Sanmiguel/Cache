package com.cache.api.dto;

import jakarta.validation.constraints.NotBlank;

// login por email o handle (uno de los dos) + password
public record LoginRequest(
        String identifier, // email o @handle
        @NotBlank String password
) {}
