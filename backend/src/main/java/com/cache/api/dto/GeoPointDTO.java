package com.cache.api.dto;

import com.cache.domain.mongo.document.EventDocument;

// ubicación aplanada para el frontend (mapa). null si el evento no tiene geo.
public record GeoPointDTO(double lat, double lon) {

    public static GeoPointDTO from(EventDocument e) {
        if (e.getLocation() == null) return null;
        return new GeoPointDTO(e.getLocation().getY(), e.getLocation().getX());
    }
}
