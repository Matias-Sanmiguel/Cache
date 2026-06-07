package com.cache.api.dto;

// payload que viaja por el topic external.weather y se cachea en redis.
// snapshot del clima actual de una ciudad, normalizado desde Open-Meteo.
public record WeatherEvent(
        String city,
        String time,          // ISO local del observatorio, ej "2026-06-03T12:00"
        double temperature,   // °C
        int humidity,         // % humedad relativa
        double precipitation, // mm
        int weatherCode,      // código WMO (0 despejado, 61 lluvia, etc)
        double windSpeed      // km/h
) {}
