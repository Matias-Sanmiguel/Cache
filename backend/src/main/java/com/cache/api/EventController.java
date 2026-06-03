package com.cache.api;

import com.cache.api.dto.EventDetailDTO;
import com.cache.api.dto.EventSummaryDTO;
import com.cache.api.dto.PageResponse;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.service.EventAssembler;
import com.cache.service.EventCatalogService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// mongodb como catálogo de eventos. los DTOs se enriquecen con friendCount (neo4j)
// y attendeeCount (redis) según el user autenticado.
@RestController
@RequestMapping("/api/events")
@RequiredArgsConstructor
public class EventController {

    private final EventCatalogService eventCatalogService;
    private final EventAssembler       eventAssembler;

    // feed principal por ciudad — paginado, filtro opcional por género
    @GetMapping("/feed")
    public PageResponse<EventSummaryDTO> feed(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "buenos aires") String city,
            @RequestParam(required = false) String genre,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Page<EventDocument> result = eventCatalogService.getFeed(city, genre, page, size);
        List<EventSummaryDTO> items = eventAssembler.toSummaries(result.getContent(), userId);
        return new PageResponse<>(
                items,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements(),
                result.getTotalPages(),
                result.hasNext());
    }

    // eventos live ahora mismo
    @GetMapping("/live")
    public List<EventSummaryDTO> live(@AuthenticationPrincipal String userId) {
        return eventAssembler.toSummaries(eventCatalogService.getLiveNow(), userId);
    }

    // eventos cerca de una coordenada
    @GetMapping("/nearby")
    public List<EventSummaryDTO> nearby(
            @AuthenticationPrincipal String userId,
            @RequestParam double lat,
            @RequestParam double lon,
            @RequestParam(defaultValue = "5") double radiusKm) {
        return eventAssembler.toSummaries(eventCatalogService.getNearby(lat, lon, radiusKm), userId);
    }

    @GetMapping("/search")
    public List<EventSummaryDTO> search(@AuthenticationPrincipal String userId, @RequestParam String q) {
        return eventAssembler.toSummaries(eventCatalogService.searchByName(q), userId);
    }

    // detalle completo — incluye lineup, descripción y amigos que asisten
    @GetMapping("/{id}")
    public ResponseEntity<EventDetailDTO> byId(@AuthenticationPrincipal String userId, @PathVariable String id) {
        return eventCatalogService.findById(id)
                .map(event -> eventAssembler.toDetail(event, userId))
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // alta de evento (host/admin) — se conserva del catálogo original
    @PostMapping
    public EventDetailDTO create(@AuthenticationPrincipal String userId, @RequestBody EventDocument event) {
        return eventAssembler.toDetail(eventCatalogService.save(event), userId);
    }
}
