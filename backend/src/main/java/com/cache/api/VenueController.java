package com.cache.api;

import com.cache.api.dto.VenueResponse;
import com.cache.domain.cassandra.entity.VenueTrend;
import com.cache.service.VenueService;
import com.cache.service.VenueTrendService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/venues")
@RequiredArgsConstructor
public class VenueController {

    private final VenueService      venueService;
    private final VenueTrendService venueTrendService;

    @GetMapping
    public List<VenueResponse> byCity(@RequestParam(defaultValue = "buenos aires") String city) {
        return venueService.getByCity(city).stream().map(VenueResponse::from).toList();
    }

    @GetMapping("/nearby")
    public List<VenueResponse> nearby(
            @RequestParam double lat,
            @RequestParam double lon,
            @RequestParam(defaultValue = "5") double radiusKm) {
        return venueService.findNearby(lat, lon, radiusKm).stream().map(VenueResponse::from).toList();
    }

    @GetMapping("/{venueId}")
    public ResponseEntity<VenueResponse> byId(@PathVariable String venueId) {
        return venueService.findById(venueId)
                .map(VenueResponse::from)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // cassandra: tendencias horarias de asistencia (default: últimos 7 días)
    @GetMapping("/{venueId}/trends")
    public List<VenueTrend> trends(
            @PathVariable String venueId,
            @RequestParam(required = false) String from,
            @RequestParam(defaultValue = "168") int limit) {
        return venueTrendService.getTrends(venueId, from, limit);
    }
}

