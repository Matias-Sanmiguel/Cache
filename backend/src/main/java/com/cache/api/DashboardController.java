package com.cache.api;

import com.cache.api.dto.DashboardResponses.AttendeesByEvent;
import com.cache.api.dto.DashboardResponses.CheckinPeak;
import com.cache.api.dto.DashboardResponses.EventsByZone;
import com.cache.api.dto.DashboardResponses.GenresByDate;
import com.cache.api.dto.DashboardResponses.LivePresence;
import com.cache.api.dto.DashboardResponses.Summary;
import com.cache.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

// analytics de la noche — el merchant ve SOLO sus eventos; el ADMIN ve todo
@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/summary")
    public Summary summary(@AuthenticationPrincipal String userId, Authentication auth) {
        return dashboardService.getSummary(userId, isAdmin(auth));
    }

    @GetMapping("/attendees-by-event")
    public List<AttendeesByEvent> attendeesByEvent(@AuthenticationPrincipal String userId, Authentication auth) {
        return dashboardService.getAttendeesByEvent(userId, isAdmin(auth));
    }

    @GetMapping("/events-by-zone")
    public List<EventsByZone> eventsByZone(@AuthenticationPrincipal String userId, Authentication auth) {
        return dashboardService.getEventsByZone(userId, isAdmin(auth));
    }

    @GetMapping("/genres-by-date")
    public List<GenresByDate> genresByDate(@AuthenticationPrincipal String userId, Authentication auth) {
        return dashboardService.getGenresByDate(userId, isAdmin(auth));
    }

    @GetMapping("/checkin-peaks")
    public List<CheckinPeak> checkinPeaks(@AuthenticationPrincipal String userId, Authentication auth) {
        return dashboardService.getCheckinPeaks(userId, isAdmin(auth));
    }

    // headcount en vivo por venue — redis (presencia en tiempo real)
    @GetMapping("/live-presence")
    public List<LivePresence> livePresence(@AuthenticationPrincipal String userId, Authentication auth) {
        return dashboardService.getLivePresenceByVenue(userId, isAdmin(auth));
    }

    private boolean isAdmin(Authentication auth) {
        return auth != null && auth.getAuthorities().stream()
                .anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
    }
}
