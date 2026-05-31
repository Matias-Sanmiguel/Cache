package com.cache.api;

import com.cache.api.dto.VenueResponse;
import com.cache.service.VenueService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/venues")
@RequiredArgsConstructor
public class VenueController {

    private final VenueService venueService;

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
}
