package com.cache.api;

import com.cache.api.dto.PresenceResponse;
import com.cache.service.PresenceService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

// redis: presencia en tiempo real de un venue
@RestController
@RequestMapping("/api/venues")
@RequiredArgsConstructor
public class PresenceController {

    private final PresenceService presenceService;

    @GetMapping("/{venueId}/presence")
    public PresenceResponse presence(@PathVariable String venueId) {
        long count = presenceService.countPresent(venueId);
        List<String> userIds = presenceService.getPresentUsers(venueId).stream()
                .map(Object::toString)
                .toList();
        return new PresenceResponse(venueId, count, userIds);
    }
}
