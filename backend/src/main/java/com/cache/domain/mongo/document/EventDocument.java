package com.cache.domain.mongo.document;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexType;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexed;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

@Document("events")
@CompoundIndex(name = "city_status_startsAt", def = "{'city': 1, 'status': 1, 'startsAt': 1}")
@Data
@Builder
public class EventDocument {

    @Id
    private String id;

    @Indexed
    private String name;

    private String venueId;
    private String venueName;
    private String venueAddress;

    // índice geo para "cerca de mí"
    @GeoSpatialIndexed(type = GeoSpatialIndexType.GEO_2DSPHERE)
    private GeoJsonPoint location;

    @Indexed
    private Instant startsAt;

    private Instant endsAt;

    @Indexed
    private List<String> genres;

    private List<LineupSlot> lineup;

    private BigDecimal price;
    private int capacity;
    private int attendeeCount;

    private String description;

    // imagen del flyer/foto del evento; el frontend cae a PhotoBG si es null
    private String imageUrl;

    // variante visual para tarjetas tipo flyer ("red-noise", etc)
    private String flyerVariant;

    // public | private | invite-only
    private String accessType;

    // dueño del evento privado (ej "casa pelícano"); null si es público
    private String hostUserId;

    // upcoming | live | finished
    @Indexed
    private String status;

    @Indexed
    private String city;
}
