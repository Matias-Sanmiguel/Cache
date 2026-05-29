package com.cache.domain.mongo.repository;

import com.cache.domain.mongo.document.EventDocument;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;

@Repository
public interface EventRepository extends MongoRepository<EventDocument, String> {

    List<EventDocument> findByStatusOrderByStartsAtAsc(String status);

    List<EventDocument> findByGenresContainingAndStartsAtAfterOrderByStartsAtAsc(
            String genre, Instant after);

    // eventos cerca de una coordenada — usa el índice 2dsphere
    List<EventDocument> findByLocationNear(Point point, Distance maxDistance);

    // eventos que empiezan en una ventana de tiempo y están en ciertos venues
    List<EventDocument> findByVenueIdInAndStartsAtBetween(
            List<String> venueIds, Instant from, Instant to);

    // catálogo filtrable por ciudad y estado — base del feed
    @Query("{ 'city': ?0, 'status': { $in: ?1 }, 'startsAt': { $gte: ?2 } }")
    List<EventDocument> findCityFeed(String city, List<String> statuses, Instant from);

    // busca por nombre (texto parcial)
    @Query("{ 'name': { $regex: ?0, $options: 'i' } }")
    List<EventDocument> searchByName(String query);
}
