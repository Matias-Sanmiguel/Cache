package com.cache.api.dto;

import com.cache.service.AuthService.AuthResult;

// respuesta de register/login/refresh: tokens + perfil del user
public record AuthResponse(
        String accessToken,
        String refreshToken,
        UserProfileDTO user
) {
    public static AuthResponse from(AuthResult result) {
        return new AuthResponse(
                result.accessToken(),
                result.refreshToken(),
                UserProfileDTO.from(result.user())
        );
    }
}
