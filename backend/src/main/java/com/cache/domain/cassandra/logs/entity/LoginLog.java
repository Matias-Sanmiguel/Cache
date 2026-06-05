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

// cada intento de login — éxito o fallo, con IP y dispositivo.
// partición por user_id + fecha: todos los logins de un user en un día en un read.
// clustering desc: el más reciente primero.
@Table("login_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginLog {

    @PrimaryKeyColumn(name = "user_id", type = PrimaryKeyType.PARTITIONED)
    private String userId;

    @PrimaryKeyColumn(name = "event_date", ordinal = 0, ordering = Ordering.DESCENDING)
    private LocalDate eventDate;

    @PrimaryKeyColumn(name = "event_time", ordinal = 1, ordering = Ordering.DESCENDING)
    private Instant eventTime;

    @Column("ip_address")
    private String ipAddress;

    @Column("device")
    private String device;

    @Column("success")
    private boolean success;
}   