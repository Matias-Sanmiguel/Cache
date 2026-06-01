package com.cache.api.dto;

// respuesta de register/login: token de sesión + perfil del usuario
public record AuthResponse(
        String token,
        UserResponse user
) {}
