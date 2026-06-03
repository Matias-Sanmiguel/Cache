package com.cache.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.UUID;

// redis como store de sesiones: token opaco → userId, con TTL.
// cumple "sesiones de usuario (auth tokens)" del MVP.
@Service
@RequiredArgsConstructor
public class SessionService {

    private final RedisTemplate<String, Object> redis;

    private static final Duration SESSION_TTL = Duration.ofDays(7);
    private static final String   PREFIX      = "session:";

    // crea un token nuevo y lo mapea al userId
    public String createSession(String userId) {
        String token = UUID.randomUUID().toString().replace("-", "")
                + UUID.randomUUID().toString().replace("-", "");
        redis.opsForValue().set(PREFIX + token, userId, SESSION_TTL);
        return token;
    }

    // resuelve un token → userId (o null si expiró/inválido)
    public String resolve(String token) {
        if (token == null || token.isBlank()) return null;
        Object val = redis.opsForValue().get(PREFIX + token);
        return val != null ? val.toString() : null;
    }

    // logout: invalida el token
    public void destroy(String token) {
        if (token != null && !token.isBlank()) {
            redis.delete(PREFIX + token);
        }
    }
}
