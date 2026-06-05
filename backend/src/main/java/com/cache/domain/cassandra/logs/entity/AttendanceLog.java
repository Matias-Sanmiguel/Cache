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

// registro inmutable de anotaciones y cancelaciones a eventos.
// partición por user_id: toda la historia de asistencia de un user en un read.
// clustering desc por action_time: la más reciente primero.
@Table("attendance_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AttendanceLog {

    @PrimaryKeyColumn(name = "user_id", type = PrimaryKeyType.PARTITIONED)
    private String userId;

    @PrimaryKeyColumn(name = "action_time", ordinal = 0, ordering = Ordering.DESCENDING)
    private Instant actionTime;

    @Column("event_id")
    private String eventId;

    // ATTEND | CANCEL
    @Column("action_type")
    private String actionType;
}