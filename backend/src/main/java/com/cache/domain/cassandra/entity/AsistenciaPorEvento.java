package com.cache.domain.cassandra.entity;

import java.time.Instant;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.cql.Ordering;
import org.springframework.data.cassandra.core.cql.PrimaryKeyType;
import org.springframework.data.cassandra.core.mapping.Column;
import org.springframework.data.cassandra.core.mapping.PrimaryKeyColumn;
import org.springframework.data.cassandra.core.mapping.Table;

// registro inmutable de quién se anotó a cada evento y desde qué zona
// partición por event_id → todas las anotaciones de un evento en una lectura
@Table("asistencias_por_evento")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AsistenciaPorEvento {

    @PrimaryKeyColumn(name = "event_id", type = PrimaryKeyType.PARTITIONED)
    private String eventId;

    @PrimaryKeyColumn(name = "anotado_at", ordinal = 0, ordering = Ordering.DESCENDING)
    private Instant anotadoAt;

    @PrimaryKeyColumn(name = "user_id", ordinal = 1)
    private String userId;

    @Column("user_handle")
    private String userHandle;

    @Column("zona")
    private String zona;

    @Column("genre")
    private String genre;
}
