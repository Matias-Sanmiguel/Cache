package com.cache.job;

import com.cache.api.dto.WeatherEvent;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

// patrón A — ingesta: poll a API externa (Open-Meteo) y publicación a kafka.
// el job no toca redis ni mongo; solo trae el dato y lo empuja al topic.
// quien persiste es WeatherConsumer (desacople productor/consumidor).
@Component
@Slf4j
public class WeatherJobs {

    static final String TOPIC = "external.weather";
    private static final String API = "https://api.open-meteo.com/v1/forecast";

    private final KafkaTemplate<String, Object> kafka;
    private final RestClient rest = RestClient.create();

    @Value("${cache.weather.city}")
    private String city;
    @Value("${cache.weather.latitude}")
    private double latitude;
    @Value("${cache.weather.longitude}")
    private double longitude;

    public WeatherJobs(KafkaTemplate<String, Object> kafka) {
        this.kafka = kafka;
    }

    // trae el clima actual y lo publica. key = ciudad → mismo partición/orden por ciudad
    @Scheduled(fixedDelayString = "${cache.weather.poll-interval-ms}", initialDelay = 5000)
    public void pollAndPublish() {
        try {
            OpenMeteoResponse res = rest.get()
                    .uri(API + "?latitude={lat}&longitude={lon}&current="
                            + "temperature_2m,relative_humidity_2m,precipitation,weather_code,wind_speed_10m",
                            latitude, longitude)
                    .retrieve()
                    .body(OpenMeteoResponse.class);

            if (res == null || res.current() == null) {
                log.warn("clima: Open-Meteo devolvió respuesta vacía para {}", city);
                return;
            }

            WeatherEvent event = toEvent(res.current());
            kafka.send(TOPIC, city, event);
            log.debug("clima publicado: {} {}°C (code {})", city, event.temperature(), event.weatherCode());

        } catch (RestClientException ex) {
            // API externa caída/timeout → logueamos y reintentamos en el próximo tick
            log.warn("clima: fallo al consultar Open-Meteo: {}", ex.getMessage());
        }
    }

    private WeatherEvent toEvent(OpenMeteoResponse.Current c) {
        return new WeatherEvent(
                city,
                c.time(),
                c.temperature(),
                c.humidity(),
                c.precipitation(),
                c.weatherCode(),
                c.windSpeed()
        );
    }

    // mapeo del JSON de Open-Meteo (nombres con guión bajo) al modelo interno
    @JsonIgnoreProperties(ignoreUnknown = true)
    private record OpenMeteoResponse(Current current) {
        @JsonIgnoreProperties(ignoreUnknown = true)
        private record Current(
                String time,
                @JsonProperty("temperature_2m") double temperature,
                @JsonProperty("relative_humidity_2m") int humidity,
                double precipitation,
                @JsonProperty("weather_code") int weatherCode,
                @JsonProperty("wind_speed_10m") double windSpeed
        ) {}
    }
}
