package com.cache.api.dto;

// contrato HTTP de una tendencia horaria de venue — desacopla el schema cassandra de la API
public record VenueTrendDTO(String date, int hour, long checkinCount, long uniqueUsers) {}
