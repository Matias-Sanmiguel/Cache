package com.cache.service;

import com.cache.api.dto.DashboardResponses.AttendeesByEvent;
import com.cache.api.dto.DashboardResponses.CheckinPeak;
import com.cache.api.dto.DashboardResponses.EventsByZone;
import com.cache.api.dto.DashboardResponses.GenreCount;
import com.cache.api.dto.DashboardResponses.GenresByDate;
import com.cache.api.dto.DashboardResponses.LivePresence;
import com.cache.api.dto.DashboardResponses.Summary;
import com.cache.domain.cassandra.entity.VenueTrend;
import com.cache.domain.cassandra.repository.VenueTrendRepository;
import com.cache.domain.mongo.document.EventDocument;
import com.cache.domain.mongo.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

// analytics de la noche para el dashboard — lee mongo (catálogo) + cassandra (tendencias)
@Service
@RequiredArgsConstructor
public class DashboardService {

    private static final ZoneId BA_ZONE = ZoneId.of("America/Argentina/Buenos_Aires");
    private static final List<String> ACTIVE_STATUSES = List.of("live", "upcoming");
    private static final DateTimeFormatter ISO_DATE = DateTimeFormatter.ISO_LOCAL_DATE;
    private static final String[] DAYS = {"LUN", "MAR", "MIE", "JUE", "VIE", "SAB", "DOM"};

    private final EventRepository eventRepository;
    private final VenueTrendRepository venueTrendRepository;
    private final PresenceService presenceService;

    private List<EventDocument> activeEvents() {
        return eventRepository.findByStatusInOrderByStartsAtAsc(ACTIVE_STATUSES);
    }

    // venueId → nombre, tomado del catálogo desnormalizado en los eventos activos
    private Map<String, String> venueNamesFromActive(List<EventDocument> active) {
        Map<String, String> names = new LinkedHashMap<>();
        for (EventDocument e : active) {
            String vid = e.getVenueId();
            if (vid == null || vid.isBlank()) continue;
            names.putIfAbsent(vid, e.getVenueName() != null && !e.getVenueName().isBlank()
                    ? e.getVenueName() : vid);
        }
        return names;
    }

    public Summary getSummary() {
        List<EventDocument> active = activeEvents();
        List<EventDocument> live = active.stream()
                .filter(e -> "live".equals(e.getStatus()))
                .toList();

        Map<String, String> venues = venueNamesFromActive(active);

        // check-ins reales (redis live), no el attendeeCount aproximado de mongo
        int totalCheckins = active.stream()
                .mapToInt(e -> (int) presenceService.getAttendeeCount(e.getId()))
                .sum();
        int activeVenues = venues.size();

        // gente presente AHORA: suma de los sets de presencia por venue (redis)
        int totalPresentNow = venues.keySet().stream()
                .mapToInt(vid -> (int) presenceService.countPresent(vid))
                .sum();

        String topZone = active.stream()
                .collect(Collectors.groupingBy(this::zoneOf, Collectors.counting()))
                .entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("-");

        return new Summary(live.size(), totalCheckins, activeVenues, topZone, totalPresentNow);
    }

    public List<AttendeesByEvent> getAttendeesByEvent() {
        // anotados en vivo desde el counter de redis (no el attendeeCount de mongo)
        return activeEvents().stream()
                .map(e -> new AttendeesByEvent(
                        e.getId(), e.getName(),
                        (int) presenceService.getAttendeeCount(e.getId()),
                        e.getCapacity()))
                .sorted(Comparator.comparingInt(AttendeesByEvent::count).reversed())
                .toList();
    }

    // headcount en vivo por venue — lee los sets de presencia de redis (cero mongo)
    public List<LivePresence> getLivePresenceByVenue() {
        return venueNamesFromActive(activeEvents()).entrySet().stream()
                .map(e -> new LivePresence(
                        e.getKey(), e.getValue(),
                        (int) presenceService.countPresent(e.getKey())))
                .sorted(Comparator.comparingInt(LivePresence::count).reversed())
                .toList();
    }

    public List<EventsByZone> getEventsByZone() {
        Map<String, Long> byZone = activeEvents().stream()
                .collect(Collectors.groupingBy(this::zoneOf, Collectors.counting()));
        return byZone.entrySet().stream()
                .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                .map(e -> new EventsByZone(e.getKey(), e.getValue().intValue()))
                .toList();
    }

    public List<GenresByDate> getGenresByDate() {
        // mantiene orden cronológico por fecha; dentro de cada fecha, géneros por frecuencia
        Map<LocalDate, Map<String, Integer>> byDate = new LinkedHashMap<>();
        for (EventDocument e : activeEvents()) {
            if (e.getStartsAt() == null || e.getGenres() == null) continue;
            LocalDate date = e.getStartsAt().atZone(BA_ZONE).toLocalDate();
            Map<String, Integer> genres = byDate.computeIfAbsent(date, d -> new LinkedHashMap<>());
            for (String g : e.getGenres()) {
                genres.merge(g, 1, Integer::sum);
            }
        }
        return byDate.entrySet().stream()
                .map(entry -> {
                    List<GenreCount> genres = entry.getValue().entrySet().stream()
                            .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                            .map(g -> new GenreCount(g.getKey(), g.getValue()))
                            .toList();
                    return new GenresByDate(formatDate(entry.getKey()), genres);
                })
                .toList();
    }

    public List<CheckinPeak> getCheckinPeaks() {
        // agrega venue_trends de hoy por hora, sumando todos los venues activos
        String today = LocalDate.now(BA_ZONE).format(ISO_DATE);
        Map<Integer, Integer> byHour = new LinkedHashMap<>();

        List<String> venueIds = activeEvents().stream()
                .map(EventDocument::getVenueId)
                .filter(v -> v != null && !v.isBlank())
                .distinct()
                .toList();

        for (String venueId : venueIds) {
            for (VenueTrend trend : venueTrendRepository.findHourlyTrend(venueId, today)) {
                byHour.merge(trend.getHour(), trend.getCheckinCount(), Integer::sum);
            }
        }

        return byHour.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .map(e -> new CheckinPeak(String.format("%02d:00", e.getKey()), e.getValue()))
                .toList();
    }

    // — helpers —

    // "Palermo · Niceto Vega 5510" → "Palermo"; cae a city si no hay barrio
    private String zoneOf(EventDocument e) {
        String addr = e.getVenueAddress();
        if (addr != null && addr.contains("·")) {
            String zone = addr.split("·")[0].trim();
            if (!zone.isBlank()) return zone;
        }
        return e.getCity() != null && !e.getCity().isBlank() ? e.getCity() : "Sin zona";
    }

    private String formatDate(LocalDate date) {
        String day = DAYS[date.getDayOfWeek().getValue() - 1];
        return String.format(Locale.ROOT, "%s %02d/%02d", day, date.getDayOfMonth(), date.getMonthValue());
    }
}
