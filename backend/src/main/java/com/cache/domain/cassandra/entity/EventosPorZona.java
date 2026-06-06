package com.cache.domain.cassandra.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.cql.PrimaryKeyType;
import org.springframework.data.cassandra.core.mapping.Column;
import org.springframework.data.cassandra.core.mapping.PrimaryKeyColumn;
import org.springframework.data.cassandra.core.mapping.Table;

// anotaciones por zona por semana — COUNTER table (solo lectura via Spring Data)
// partición por semana → todas las zonas de la semana en una lectura
@Table("eventos_por_zona")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EventosPorZona {

    @PrimaryKeyColumn(name = "semana", type = PrimaryKeyType.PARTITIONED)
    private String semana;

    @PrimaryKeyColumn(name = "zona", ordinal = 0)
    private String zona;

    @Column("anotaciones")
    private long anotaciones;
}
