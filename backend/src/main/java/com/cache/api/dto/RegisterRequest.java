package com.cache.api.dto;

import com.cache.domain.mongo.document.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
        @Email @NotBlank String email,
        @NotBlank @Size(min = 6, message = "password mínimo 6 caracteres") String password,
        @NotBlank String displayName,
        @NotBlank String handle,
        String avatarColor,
        String city,
        Role role,        // opcional — default VISITOR
        String venueId    // solo para VENUE_OWNER
) {}
