package com.cache.domain.cassandra.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.cql.Ordering;
import org.springframework.data.cassandra.core.cql.PrimaryKeyType;
import org.springframework.data.cassandra.core.mapping.Column;
import org.springframework.data.cassandra.core.mapping.PrimaryKeyColumn;
import org.springframework.data.cassandra.core.mapping.Table;

// check-ins por hora del día — COUNTER table (solo lectura via Spring Data)
// partición por fecha → 24 filas (una por hora), ordenadas asc
@Table("pico_de_anotaciones")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PicoDeAnotaciones {

    @PrimaryKeyColumn(name = "fecha", type = PrimaryKeyType.PARTITIONED)
    private String fecha;

    @PrimaryKeyColumn(name = "hora", ordinal = 0, ordering = Ordering.ASCENDING)
    private int hora;

    @Column("anotaciones")
    private long anotaciones;
}
