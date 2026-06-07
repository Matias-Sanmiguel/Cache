package com.cache.service;

import com.cache.api.dto.CreateVenueRequest;
import com.cache.domain.mongo.document.VenueDocument;
import com.cache.domain.mongo.repository.VenueRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Metrics;
import org.springframework.data.geo.Point;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VenueService {

    private final VenueRepository venueRepository;

    public VenueDocument save(VenueDocument venue) {
        return venueRepository.save(venue);
    }

    // crea un venue nuevo con venueId generado — lo usa el merchant al asignar su local
    public VenueDocument createVenue(CreateVenueRequest req) {
        VenueDocument venue = VenueDocument.builder()
                .venueId(UUID.randomUUID().toString())
                .name(req.name())
                .address(req.address())
                .city(req.city())
                .capacity(req.capacity())
                .tags(req.tags() != null ? req.tags() : List.of())
                .build();
        return venueRepository.save(venue);
    }

    public Optional<VenueDocument> findById(String venueId) {
        return venueRepository.findByVenueId(venueId);
    }

    public List<VenueDocument> getByCity(String city) {
        return venueRepository.findByCity(city);
    }

    public List<VenueDocument> findNearby(double lat, double lon, double radiusKm) {
        return venueRepository.findByLocationNear(
                new Point(lon, lat),
                new Distance(radiusKm, Metrics.KILOMETERS)
        );
    }
}
