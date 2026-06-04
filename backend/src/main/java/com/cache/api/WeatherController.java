package com.cache.api;

import com.cache.api.dto.WeatherEvent;
import com.cache.service.WeatherService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

// clima actual — alimentado por el pipeline Open-Meteo → kafka → redis
@RestController
@RequestMapping("/api/weather")
@RequiredArgsConstructor
public class WeatherController {

    private final WeatherService weatherService;

    @Value("${cache.weather.city}")
    private String defaultCity;

    // 200 con el snapshot, o 204 si el job todavía no publicó nada
    @GetMapping
    public ResponseEntity<WeatherEvent> current(@RequestParam(required = false) String city) {
        WeatherEvent weather = weatherService.current(city != null ? city : defaultCity);
        return weather != null ? ResponseEntity.ok(weather) : ResponseEntity.noContent().build();
    }
}
