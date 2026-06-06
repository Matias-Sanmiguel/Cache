package com.cache.domain.cassandra.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.cql.PrimaryKeyType;
import org.springframework.data.cassandra.core.mapping.Column;
import org.springframework.data.cassandra.core.mapping.PrimaryKeyColumn;
import org.springframework.data.cassandra.core.mapping.Table;

// check-ins por género por día — COUNTER table (solo lectura via Spring Data)
// partición por fecha → todos los géneros de ese día en una lectura
@Table("generos_por_fecha")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GenerosPorFecha {

    @PrimaryKeyColumn(name = "fecha", type = PrimaryKeyType.PARTITIONED)
    private String fecha;

    @PrimaryKeyColumn(name = "genero", ordinal = 0)
    private String genero;

    @Column("anotaciones")
    private long anotaciones;
}
