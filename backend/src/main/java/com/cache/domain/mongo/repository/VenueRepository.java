package com.cache.domain.mongo.repository;

import com.cache.domain.mongo.document.VenueDocument;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VenueRepository extends MongoRepository<VenueDocument, String> {

    Optional<VenueDocument> findByVenueId(String venueId);

    List<VenueDocument> findByCity(String city);

    // venues cerca de una coordenada — índice 2dsphere
    List<VenueDocument> findByLocationNear(Point point, Distance maxDistance);
}
