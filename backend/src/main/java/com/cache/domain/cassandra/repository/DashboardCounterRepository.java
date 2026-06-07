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
        // crea las tablas counter si no existen (schema-action de Spring no maneja COUNTER)
        // antes de preparar los statements → el backend arranca sin schema.cql manual
        cassandraSession.execute(
            "CREATE TABLE IF NOT EXISTS eventos_por_zona (semana text, zona text, anotaciones counter, PRIMARY KEY (semana, zona))"
        );
        cassandraSession.execute(
            "CREATE TABLE IF NOT EXISTS generos_por_fecha (fecha text, genero text, anotaciones counter, PRIMARY KEY (fecha, genero))"
        );
        cassandraSession.execute(
            "CREATE TABLE IF NOT EXISTS pico_de_anotaciones (fecha text, hora int, anotaciones counter, PRIMARY KEY (fecha, hora)) WITH CLUSTERING ORDER BY (hora ASC)"
        );

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
