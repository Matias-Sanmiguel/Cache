package com.cache.api.dto;

import com.cache.service.AuthService.AuthResult;

// respuesta de register/login/refresh: tokens + perfil completo del propio user
public record AuthResponse(
        String accessToken,
        String refreshToken,
        AccountDTO user
) {
    public static AuthResponse from(AuthResult result) {
        return new AuthResponse(
                result.accessToken(),
                result.refreshToken(),
                AccountDTO.from(result.user())
        );
    }
}
