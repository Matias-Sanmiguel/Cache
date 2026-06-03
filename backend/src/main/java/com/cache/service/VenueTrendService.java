package com.cache.service;

import com.cache.domain.cassandra.entity.VenueTrend;
import com.cache.domain.cassandra.repository.VenueTrendRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

// cassandra: tendencias horarias de asistencia por venue
@Service
@RequiredArgsConstructor
public class VenueTrendService {

    private static final ZoneId BA = ZoneId.of("America/Argentina/Buenos_Aires");

    private final VenueTrendRepository trendRepo;

    // tendencias del venue desde una fecha (default: últimos 7 días)
    public List<VenueTrend> getTrends(String venueId, String fromDate, int limit) {
        String from = (fromDate != null && !fromDate.isBlank())
                ? fromDate
                : LocalDate.now(BA).minusDays(7).toString();
        return trendRepo.findTrendsByVenueAndDateFrom(venueId, from, limit);
    }
}
