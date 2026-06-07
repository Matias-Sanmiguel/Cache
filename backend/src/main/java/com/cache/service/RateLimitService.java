package com.cache.service;

import java.time.Duration;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class RateLimitService {

    private final RedisTemplate<String, Object> redisTemplate;

    public RateLimitService(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    public boolean allowRequest(
            String userId,
            String window,
            int maxRequests,
            Duration ttl) {

        String key = "ratelimit:" + userId + ":" + window;

        Long count = redisTemplate.opsForValue().increment(key);

        if (count != null && count == 1) {
            redisTemplate.expire(key, ttl);
        }

        return count != null && count <= maxRequests;
    }
}
