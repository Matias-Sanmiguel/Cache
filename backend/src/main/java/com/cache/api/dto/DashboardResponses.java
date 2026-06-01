package com.cache.api.dto;

import java.util.List;

// shapes del dashboard — uno por endpoint, alineados con el frontend (lib/api.ts)
public final class DashboardResponses {

    private DashboardResponses() {}

    // GET /api/dashboard/summary
    public record Summary(
            int activeEvents,
            int totalCheckins,
            int activeVenues,
            String topZone
    ) {}

    // GET /api/dashboard/attendees-by-event
    public record AttendeesByEvent(
            String eventId,
            String eventName,
            int count,
            int capacity
    ) {}

    // GET /api/dashboard/events-by-zone
    public record EventsByZone(
            String zone,
            int count
    ) {}

    // GET /api/dashboard/genres-by-date
    public record GenreCount(
            String name,
            int count
    ) {}

    public record GenresByDate(
            String date,
            List<GenreCount> genres
    ) {}

    // GET /api/dashboard/checkin-peaks
    public record CheckinPeak(
            String time,
            int count
    ) {}
}
