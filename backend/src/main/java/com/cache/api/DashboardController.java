package com.cache.api;

import com.cache.api.dto.DashboardResponses.AttendeesByEvent;
import com.cache.api.dto.DashboardResponses.CheckinPeak;
import com.cache.api.dto.DashboardResponses.EventsByZone;
import com.cache.api.dto.DashboardResponses.GenresByDate;
import com.cache.api.dto.DashboardResponses.Summary;
import com.cache.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

// analytics de la noche — mongo (catálogo) + cassandra (tendencias)
@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/summary")
    public Summary summary() {
        return dashboardService.getSummary();
    }

    @GetMapping("/attendees-by-event")
    public List<AttendeesByEvent> attendeesByEvent() {
        return dashboardService.getAttendeesByEvent();
    }

    @GetMapping("/events-by-zone")
    public List<EventsByZone> eventsByZone() {
        return dashboardService.getEventsByZone();
    }

    @GetMapping("/genres-by-date")
    public List<GenresByDate> genresByDate() {
        return dashboardService.getGenresByDate();
    }

    @GetMapping("/checkin-peaks")
    public List<CheckinPeak> checkinPeaks() {
        return dashboardService.getCheckinPeaks();
    }
}
