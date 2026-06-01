package com.cache.api;

import com.cache.api.dto.CheckinRequestDTO;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.service.CheckinService;
import com.cache.service.EventCatalogService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

// check-in/out — orquesta los 4 motores vía CheckinService (redis/neo4j/cassandra)
@RestController
@RequestMapping("/api/checkin")
@RequiredArgsConstructor
public class CheckinController {

    private final CheckinService       checkinService;
    private final EventCatalogService  eventCatalogService;

    // el user se anota a un evento
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public void checkin(@AuthenticationPrincipal String userId, @Valid @RequestBody CheckinRequestDTO req) {
        EventDocument event = eventCatalogService.findById(req.eventId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "evento no encontrado"));
        checkinService.checkin(userId, event);
    }

    // el user sale de un venue
    @DeleteMapping("/{venueId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void checkout(@AuthenticationPrincipal String userId, @PathVariable String venueId) {
        checkinService.checkout(userId, venueId);
    }
}
