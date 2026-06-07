package com.cache.service;

import com.cache.api.dto.WeatherEvent;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

// lee el último snapshot de clima cacheado por WeatherConsumer en redis.
// devuelve null si todavía no llegó ningún tick del job (primer arranque).
@Service
@RequiredArgsConstructor
public class WeatherService {

    private final RedisTemplate<String, Object> redis;

    public WeatherEvent current(String city) {
        Object val = redis.opsForValue().get("weather:current:" + city);
        return val instanceof WeatherEvent w ? w : null;
    }
}
