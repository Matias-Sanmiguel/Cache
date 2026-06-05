package com.cache.domain.cassandra.logs.entity;

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
import java.time.LocalDate;

// movimientos geográficos del usuario — para analytics de zona.
// partición por user_id + fecha: todos los movimientos de un user en un día en un read.
@Table("location_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LocationLog {

    @PrimaryKeyColumn(name = "user_id", type = PrimaryKeyType.PARTITIONED)
    private String userId;

    @PrimaryKeyColumn(name = "log_date", ordinal = 0, ordering = Ordering.DESCENDING)
    private LocalDate logDate;

    @PrimaryKeyColumn(name = "event_time", ordinal = 1, ordering = Ordering.DESCENDING)
    private Instant eventTime;

    @Column("latitude")
    private double latitude;

    @Column("longitude")
    private double longitude;
}