package com.cache.domain.cassandra.repository;

import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.cql.PreparedStatement;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

// escribe en las 3 tablas COUNTER del dashboard via CQL raw.
// Spring Data no soporta incremento de counters via save() — solo UPDATE counter = counter + N.
@Repository
@RequiredArgsConstructor
public class DashboardCounterRepository {

    // sesión primaria (cache_ks) — @Primary en CassandraConfig
    private final CqlSession cassandraSession;

    private PreparedStatement stmtZona;
    private PreparedStatement stmtGenero;
    private PreparedStatement stmtPico;

    @PostConstruct
    void prepare() {
        stmtZona = cassandraSession.prepare(
            "UPDATE eventos_por_zona SET anotaciones = anotaciones + 1 WHERE semana = ? AND zona = ?"
        );
        stmtGenero = cassandraSession.prepare(
            "UPDATE generos_por_fecha SET anotaciones = anotaciones + 1 WHERE fecha = ? AND genero = ?"
        );
        stmtPico = cassandraSession.prepare(
            "UPDATE pico_de_anotaciones SET anotaciones = anotaciones + 1 WHERE fecha = ? AND hora = ?"
        );
    }

    public void incrementZona(String semana, String zona) {
        cassandraSession.execute(stmtZona.bind(semana, zona));
    }

    public void incrementGenero(String fecha, String genero) {
        cassandraSession.execute(stmtGenero.bind(fecha, genero));
    }

    public void incrementPico(String fecha, int hora) {
        cassandraSession.execute(stmtPico.bind(fecha, hora));
    }
}
