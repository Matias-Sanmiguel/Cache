package com.cache.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Optional;
import java.util.UUID;

// redis como store de sesiones: refresh tokens opacos → userId, con TTL.
// permite invalidar sesiones (logout) sin tocar el access token, que es stateless.
@Service
public class SessionService {

    private static final String PREFIX = "session:refresh:";

    private final RedisTemplate<String, Object> redis;
    private final Duration refreshTtl;

    public SessionService(
            RedisTemplate<String, Object> redis,
            @Value("${app.jwt.refresh-ttl-days}") long refreshTtlDays) {
        this.redis = redis;
        this.refreshTtl = Duration.ofDays(refreshTtlDays);
    }

    // crea un refresh token nuevo y lo asocia al userId en redis
    public String createRefreshToken(String userId) {
        String token = UUID.randomUUID().toString().replace("-", "")
                + UUID.randomUUID().toString().replace("-", "");
        redis.opsForValue().set(PREFIX + token, userId, refreshTtl);
        return token;
    }

    // devuelve el userId si el refresh token existe y no expiró
    public Optional<String> userIdForRefreshToken(String token) {
        Object value = redis.opsForValue().get(PREFIX + token);
        return Optional.ofNullable(value).map(Object::toString);
    }

    // invalida un refresh token (logout o rotación)
    public void revoke(String token) {
        redis.delete(PREFIX + token);
    }
}
