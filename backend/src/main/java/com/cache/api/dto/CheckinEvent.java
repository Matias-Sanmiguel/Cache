package com.cache.api.dto;

// evento de dominio publicado a kafka cuando un user se anota.
// lleva todo desnormalizado para que el consumer no tenga que releer mongo.
// los tiempos van como epoch millis para no depender del JavaTimeModule del serializer.
public record CheckinEvent(
        String userId,
        String eventId,
        String eventName,
        String venueId,
        String venueName,
        String genre,
        String city,
        long startsAtEpochMs,
        long occurredAtEpochMs
) {}
