package com.cache.config;

import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.document.UserDocument;
import com.cache.domain.mongo.document.VenueDocument;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.bson.Document;
import org.springframework.boot.CommandLineRunner;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.index.CompoundIndexDefinition;
import org.springframework.data.mongodb.core.index.GeospatialIndex;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexType;
import org.springframework.data.mongodb.core.index.Index;
import org.springframework.stereotype.Component;

// crea explícitamente los índices del esquema (auto-index-creation no siempre alcanza
// y los reimports con --drop los borran). idempotente: ensureIndex no duplica.
@Component
@Slf4j
@RequiredArgsConstructor
public class IndexInitializer implements CommandLineRunner {

    private final MongoTemplate mongo;

    @Override
    public void run(String... args) {
        // events
        mongo.indexOps(EventDocument.class).ensureIndex(new Index().on("name", Sort.Direction.ASC));
        mongo.indexOps(EventDocument.class).ensureIndex(new Index().on("status", Sort.Direction.ASC));
        mongo.indexOps(EventDocument.class).ensureIndex(new Index().on("startsAt", Sort.Direction.ASC));
        mongo.indexOps(EventDocument.class).ensureIndex(new Index().on("genres", Sort.Direction.ASC));
        mongo.indexOps(EventDocument.class).ensureIndex(
                new GeospatialIndex("location").typed(GeoSpatialIndexType.GEO_2DSPHERE));
        mongo.indexOps(EventDocument.class).ensureIndex(new CompoundIndexDefinition(
                new Document("city", 1).append("status", 1).append("startsAt", 1))
                .named("city_status_startsAt"));

        // users — únicos
        mongo.indexOps(UserDocument.class).ensureIndex(new Index().on("userId", Sort.Direction.ASC).unique());
        mongo.indexOps(UserDocument.class).ensureIndex(new Index().on("email", Sort.Direction.ASC).unique());
        mongo.indexOps(UserDocument.class).ensureIndex(new Index().on("handle", Sort.Direction.ASC).unique());

        // venues
        mongo.indexOps(VenueDocument.class).ensureIndex(new Index().on("venueId", Sort.Direction.ASC).unique());
        mongo.indexOps(VenueDocument.class).ensureIndex(new Index().on("city", Sort.Direction.ASC));
        mongo.indexOps(VenueDocument.class).ensureIndex(
                new GeospatialIndex("location").typed(GeoSpatialIndexType.GEO_2DSPHERE));

        log.info("índices mongo asegurados (events/users/venues)");
    }
}
