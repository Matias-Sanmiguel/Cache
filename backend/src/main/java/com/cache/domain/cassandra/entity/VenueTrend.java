package com.cache.domain.cassandra.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.cql.Ordering;
import org.springframework.data.cassandra.core.cql.PrimaryKeyType;
import org.springframework.data.cassandra.core.mapping.Column;
import org.springframework.data.cassandra.core.mapping.PrimaryKeyColumn;
import org.springframework.data.cassandra.core.mapping.Table;

// agrega checkins por venue/día/hora — para calcular picos de asistencia
// partición por venue_id — todas las tendencias de un venue en un read
@Table("venue_trends")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VenueTrend {

    @PrimaryKeyColumn(name = "venue_id", type = PrimaryKeyType.PARTITIONED)
    private String venueId;

    @PrimaryKeyColumn(name = "date", ordinal = 0, ordering = Ordering.DESCENDING)
    private String date; // "2025-05-02"

    @PrimaryKeyColumn(name = "hour", ordinal = 1)
    private int hour; // 0-23

    @Column("checkin_count")
    private int checkinCount;

    @Column("unique_users")
    private int uniqueUsers;

    @Column("top_genre")
    private String topGenre;
}
