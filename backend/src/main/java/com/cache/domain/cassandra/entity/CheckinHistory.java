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

import java.time.Instant;

// partición por user_id — todas las salidas de un user en un read
// clustering desc por timestamp — get historial reciente sin sort manual
@Table("checkin_history")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CheckinHistory {

    @PrimaryKeyColumn(name = "user_id", type = PrimaryKeyType.PARTITIONED)
    private String userId;

    @PrimaryKeyColumn(name = "checked_at", ordinal = 0, ordering = Ordering.DESCENDING)
    private Instant checkedAt;

    @Column("event_id")
    private String eventId;

    @Column("venue_id")
    private String venueId;

    @Column("venue_name")
    private String venueName;

    @Column("genre")
    private String genre;

    @Column("city")
    private String city;
}
