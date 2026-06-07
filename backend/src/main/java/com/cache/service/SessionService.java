package com.cache.service;

import java.time.Duration;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class SessionService {

    private final RedisTemplate<String, Object> redisTemplate;

    public SessionService(
            RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    private String key(String userId) {
        return "session:" + userId;
    }

    public void saveRefreshToken(
            String userId,
            String token) {

        redisTemplate.opsForValue().set(
                key(userId),
                token,
                Duration.ofDays(30)
        );
    }

    public String getRefreshToken(
            String userId) {

        Object token =
                redisTemplate.opsForValue()
                        .get(key(userId));

        return token != null
                ? token.toString()
                : null;
    }

    public void revokeSession(
            String userId) {

        redisTemplate.delete(
                key(userId)
        );
    }
}

