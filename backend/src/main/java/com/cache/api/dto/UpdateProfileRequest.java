package com.cache.api.dto;

// todos opcionales: solo se actualiza lo que viene no-null
public record UpdateProfileRequest(
        String displayName,
        String avatarColor,
        String city
) {}
