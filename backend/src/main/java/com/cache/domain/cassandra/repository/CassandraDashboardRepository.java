package com.cache.domain.cassandra.repository;

import com.cache.api.dto.VenueTrendDTO;
import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.cql.PreparedStatement;
import com.datastax.oss.driver.api.core.cql.Row;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

// métricas del dashboard en cassandra mediante counters atómicos.
// usamos CqlSession crudo (no Spring Data) por dos razones:
//  - las tablas COUNTER no se pueden crear ni escribir vía save() de un @Table entity;
//  - el incremento `x = x + 1` es atómico → sin race de read-modify-write.
@Repository
@RequiredArgsConstructor
public class CassandraDashboardRepository {

    private static final DateTimeFormatter ISO_DATE = DateTimeFormatter.ISO_LOCAL_DATE;

    private final CqlSession session;

    private PreparedStatement incPeak;
    private PreparedStatement incVenueCheckins;
    private PreparedStatement incVenueUnique;
    private PreparedStatement addVenueHourUser;
    private PreparedStatement selPeaks;
    private PreparedStatement selVenueTrends;

    // crea las tablas (idempotente) y prepara los statements al arrancar.
    // schema-action de Spring no sirve para COUNTER → las creamos acá explícitamente.
    @PostConstruct
    void init() {
        session.execute("""
            CREATE TABLE IF NOT EXISTS pico_de_anotaciones (
              fecha text, hora int, anotaciones counter,
              PRIMARY KEY (fecha, hora)
            ) WITH CLUSTERING ORDER BY (hora ASC)
            """);
        session.execute("""
            CREATE TABLE IF NOT EXISTS venue_trends_counter (
              venue_id text, date text, hour int,
              checkin_count counter, unique_users counter,
              PRIMARY KEY ((venue_id), date, hour)
            ) WITH CLUSTERING ORDER BY (date DESC, hour ASC)
            """);
        session.execute("""
            CREATE TABLE IF NOT EXISTS venue_hour_users (
              venue_id text, date text, hour int, user_id text,
              PRIMARY KEY ((venue_id, date, hour), user_id)
            )
            """);

        incPeak = session.prepare(
                "UPDATE pico_de_anotaciones SET anotaciones = anotaciones + 1 WHERE fecha = ? AND hora = ?");
        incVenueCheckins = session.prepare(
                "UPDATE venue_trends_counter SET checkin_count = checkin_count + 1 WHERE venue_id = ? AND date = ? AND hour = ?");
        incVenueUnique = session.prepare(
                "UPDATE venue_trends_counter SET unique_users = unique_users + 1 WHERE venue_id = ? AND date = ? AND hour = ?");
        addVenueHourUser = session.prepare(
                "INSERT INTO venue_hour_users (venue_id, date, hour, user_id) VALUES (?, ?, ?, ?) IF NOT EXISTS");
        selPeaks = session.prepare(
                "SELECT hora, anotaciones FROM pico_de_anotaciones WHERE fecha = ?");
        selVenueTrends = session.prepare(
                "SELECT date, hour, checkin_count, unique_users FROM venue_trends_counter WHERE venue_id = ? AND date >= ? LIMIT ?");
    }

    // — escritura (en cada anotación nueva) —

    // incrementa los counters de la noche de forma atómica. el conteo de usuarios únicos
    // usa una LWT (IF NOT EXISTS): solo suma cuando es el primer check-in del user en esa hora.
    public void recordCheckin(String venueId, String userId, LocalDateTime baTime) {
        String date = baTime.toLocalDate().format(ISO_DATE);
        int hour = baTime.getHour();

        session.execute(incPeak.bind(date, hour));

        if (venueId != null && !venueId.isBlank()) {
            session.execute(incVenueCheckins.bind(venueId, date, hour));
            boolean firstThisHour = session
                    .execute(addVenueHourUser.bind(venueId, date, hour, userId))
                    .wasApplied();
            if (firstThisHour) {
                session.execute(incVenueUnique.bind(venueId, date, hour));
            }
        }
    }

    // — lectura (dashboard / venue) —

    public record HourCount(int hour, long count) {}

    // pico horario global de una fecha — una sola lectura de partición (sin N+1)
    public List<HourCount> getCheckinPeaks(String fecha) {
        List<HourCount> peaks = new ArrayList<>();
        for (Row row : session.execute(selPeaks.bind(fecha))) {
            peaks.add(new HourCount(row.getInt("hora"), row.getLong("anotaciones")));
        }
        return peaks;
    }

    // tendencia horaria de un venue desde una fecha
    public List<VenueTrendDTO> getVenueTrends(String venueId, String fromDate, int limit) {
        List<VenueTrendDTO> trends = new ArrayList<>();
        for (Row row : session.execute(selVenueTrends.bind(venueId, fromDate, limit))) {
            trends.add(new VenueTrendDTO(
                    row.getString("date"),
                    row.getInt("hour"),
                    row.getLong("checkin_count"),
                    row.getLong("unique_users")));
        }
        return trends;
    }
}
