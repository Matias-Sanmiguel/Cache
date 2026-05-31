package com.cache.domain.mongo.repository;

import com.cache.domain.mongo.document.EventDocument;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
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

    // feed paginado — usa el índice compuesto city_status_startsAt
    @Query("{ 'city': ?0, 'status': { $in: ?1 }, 'startsAt': { $gte: ?2 } }")
    Page<EventDocument> findCityFeed(String city, List<String> statuses, Instant from, Pageable pageable);

    // feed paginado filtrado por género
    @Query("{ 'city': ?0, 'status': { $in: ?1 }, 'startsAt': { $gte: ?2 }, 'genres': ?3 }")
    Page<EventDocument> findCityFeedByGenre(String city, List<String> statuses, Instant from, String genre, Pageable pageable);

    // busca por nombre (texto parcial)
    @Query("{ 'name': { $regex: ?0, $options: 'i' } }")
    List<EventDocument> searchByName(String query);

    // usados por el job de transición de estado
    List<EventDocument> findByStatusAndStartsAtLessThanEqual(String status, Instant moment);

    List<EventDocument> findByStatusAndEndsAtLessThanEqual(String status, Instant moment);
}
