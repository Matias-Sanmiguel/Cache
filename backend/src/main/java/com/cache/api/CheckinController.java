package com.cache.api;

import com.cache.api.dto.CheckinHistoryDTO;
import com.cache.api.dto.CheckinRequestDTO;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.service.CheckinService;
import com.cache.service.EventCatalogService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

// check-in/out — orquesta los 4 motores vía CheckinService (redis/neo4j/cassandra)
@RestController
@RequestMapping("/api/checkin")
@RequiredArgsConstructor
@Validated
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

    // el user sale del evento (resolvemos el venue desde el evento para descontar bien el contador)
    @DeleteMapping("/{eventId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void checkout(@AuthenticationPrincipal String userId, @PathVariable String eventId) {
        EventDocument event = eventCatalogService.findById(eventId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "evento no encontrado"));
        checkinService.checkout(userId, event);
    }

    @GetMapping("/{eventId}/status")
    public CheckinStatusDTO status(@AuthenticationPrincipal String userId, @PathVariable String eventId) {
        EventDocument event = eventCatalogService.findById(eventId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "evento no encontrado"));
        return new CheckinStatusDTO(checkinService.isAttending(userId, event));
    }

    @DeleteMapping("/{eventId}/attendance")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void cancelAttendance(@AuthenticationPrincipal String userId, @PathVariable String eventId) {
        EventDocument event = eventCatalogService.findById(eventId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "evento no encontrado"));
        checkinService.cancelAttendance(userId, event);
    }

    // historial de check-ins del user autenticado (Cassandra, más recientes primero)
    @GetMapping("/history")
    public List<CheckinHistoryDTO> history(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int limit) {
        return checkinService.getHistory(userId, limit).stream()
                .map(CheckinHistoryDTO::from)
                .toList();
    }

    public record CheckinStatusDTO(boolean isAttending) {}
}
