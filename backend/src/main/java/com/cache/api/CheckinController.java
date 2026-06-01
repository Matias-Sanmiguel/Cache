package com.cache.api;

import com.cache.api.dto.CheckInRequest;
import com.cache.service.CheckinService;
import com.cache.service.EventCatalogService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

// check-in: orquesta redis + neo4j + cassandra vía CheckinService
@RestController
@RequestMapping("/api/checkins")
@RequiredArgsConstructor
public class CheckinController {

    private final CheckinService checkinService;
    private final EventCatalogService eventCatalogService;

    @PostMapping
    public ResponseEntity<Void> checkin(@Valid @RequestBody CheckInRequest req) {
        return eventCatalogService.findById(req.eventId())
                .map(event -> {
                    checkinService.checkin(req.userId(), event);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
