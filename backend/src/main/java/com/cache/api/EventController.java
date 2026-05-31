package com.cache.api;

import com.cache.api.dto.EventResponse;
import com.cache.api.dto.PageResponse;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.service.EventCatalogService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// mongodb como catálogo de eventos — endpoints de lectura/escritura del feed
@RestController
@RequestMapping("/api/events")
@RequiredArgsConstructor
public class EventController {

    private final EventCatalogService eventCatalogService;

    // feed principal por ciudad — paginado y con filtro opcional por género
    @GetMapping
    public PageResponse<EventResponse> feed(
            @RequestParam(defaultValue = "buenos aires") String city,
            @RequestParam(required = false) String genre,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return PageResponse.of(
                eventCatalogService.getFeed(city, genre, page, size),
                EventResponse::from);
    }

    // eventos live ahora mismo
    @GetMapping("/live")
    public List<EventResponse> live() {
        return eventCatalogService.getLiveNow().stream()
                .map(EventResponse::from)
                .toList();
    }

    // eventos cerca de una coordenada
    @GetMapping("/nearby")
    public List<EventResponse> nearby(
            @RequestParam double lat,
            @RequestParam double lon,
            @RequestParam(defaultValue = "5") double radiusKm) {
        return eventCatalogService.getNearby(lat, lon, radiusKm).stream()
                .map(EventResponse::from)
                .toList();
    }

    @GetMapping("/search")
    public List<EventResponse> search(@RequestParam String q) {
        return eventCatalogService.searchByName(q).stream()
                .map(EventResponse::from)
                .toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<EventResponse> byId(@PathVariable String id) {
        return eventCatalogService.findById(id)
                .map(EventResponse::from)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public EventResponse create(@RequestBody EventDocument event) {
        return EventResponse.from(eventCatalogService.save(event));
    }
}
