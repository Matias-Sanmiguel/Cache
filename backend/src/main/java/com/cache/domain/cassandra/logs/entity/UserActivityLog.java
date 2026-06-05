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

// acciones generales del usuario: checkin, anotación, cambio de perfil, etc.
// partición por user_id + fecha: toda la actividad de un user en un día en un read.
@Table("user_activity_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserActivityLog {

    @PrimaryKeyColumn(name = "user_id", type = PrimaryKeyType.PARTITIONED)
    private String userId;

    @PrimaryKeyColumn(name = "activity_date", ordinal = 0, ordering = Ordering.DESCENDING)
    private LocalDate activityDate;

    @PrimaryKeyColumn(name = "activity_time", ordinal = 1, ordering = Ordering.DESCENDING)
    private Instant activityTime;

    // tipo de acción: CHECKIN | CHECKOUT | FRIEND_REQUEST | FRIEND_ACCEPT | PROFILE_UPDATE | etc.
    @Column("activity_type")
    private String activityType;

    // entidad sobre la que actuó: EVENT | VENUE | USER
    @Column("entity_type")
    private String entityType;

    @Column("entity_id")
    private String entityId;

    @Column("description")
    private String description;
}