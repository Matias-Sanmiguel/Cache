package com.cache.domain.cassandra.repository;

import com.cache.domain.cassandra.entity.VenueTrend;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VenueTrendRepository extends CassandraRepository<VenueTrend, Object> {

    // tendencia de un venue en los últimos N días
    @Query("SELECT * FROM venue_trends WHERE venue_id = ?0 AND date >= ?1 LIMIT ?2")
    List<VenueTrend> findTrendsByVenueAndDateFrom(String venueId, String fromDate, int limit);

    // pico horario de un venue en una fecha específica
    @Query("SELECT * FROM venue_trends WHERE venue_id = ?0 AND date = ?1")
    List<VenueTrend> findHourlyTrend(String venueId, String date);
}
