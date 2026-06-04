package com.cache.service;

import com.cache.api.dto.WeatherEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import java.time.Duration;

// patrón A — consumidor: lee external.weather y cachea el último snapshot en redis.
// clima "ahora" es estado efímero → redis con TTL (mismo criterio que presencia).
// otros services pueden leer weather:current:<ciudad> para ajustar el feed.
@Service
@Slf4j
@RequiredArgsConstructor
public class WeatherConsumer {

    private static final Duration TTL = Duration.ofHours(2);

    private final RedisTemplate<String, Object> redis;

    @KafkaListener(topics = "external.weather", groupId = "cache-backend")
    public void onWeather(WeatherEvent event) {
        String key = "weather:current:" + event.city();
        redis.opsForValue().set(key, event, TTL);
        log.info("clima {} actualizado: {}°C, {}% humedad, {}mm lluvia",
                event.city(), event.temperature(), event.humidity(), event.precipitation());
    }
}
