package com.cache.domain.mongo.document;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexType;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexed;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

// catálogo de venues. events referencia venueId/venueName desnormalizados a esta colección
@Document("venues")
@Data
@Builder
public class VenueDocument {

    @Id
    private String id;

    @Indexed(unique = true)
    private String venueId;

    private String name;
    private String address;

    @Indexed
    private String city;

    @GeoSpatialIndexed(type = GeoSpatialIndexType.GEO_2DSPHERE)
    private GeoJsonPoint location;

    private int capacity;
    private List<String> tags; // ["techno", "18+", "cash-only"]
}
