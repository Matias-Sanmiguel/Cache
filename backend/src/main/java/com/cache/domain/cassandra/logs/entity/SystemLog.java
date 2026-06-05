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

// logs de infraestructura por servicio: errores, warnings, eventos de arranque.
// partición compuesta (service_name, log_date): los logs de un servicio en un día en
// un read, sin que la partición crezca infinito (un bucket por día evita hot partition).
// clustering desc: el más reciente primero.
@Table("system_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SystemLog {

    @PrimaryKeyColumn(name = "service_name", ordinal = 0, type = PrimaryKeyType.PARTITIONED)
    private String serviceName;

    @PrimaryKeyColumn(name = "log_date", ordinal = 1, type = PrimaryKeyType.PARTITIONED)
    private LocalDate logDate;

    @PrimaryKeyColumn(name = "event_time", ordinal = 0, ordering = Ordering.DESCENDING)
    private Instant eventTime;

    // INFO | WARN | ERROR
    @Column("level")
    private String level;

    @Column("message")
    private String message;
}