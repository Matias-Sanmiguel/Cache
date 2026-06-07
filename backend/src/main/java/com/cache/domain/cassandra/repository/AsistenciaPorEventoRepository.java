package com.cache.domain.cassandra.repository;

import com.cache.domain.cassandra.entity.AsistenciaPorEvento;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AsistenciaPorEventoRepository extends CassandraRepository<AsistenciaPorEvento, Object> {

    @Query("SELECT * FROM asistencias_por_evento WHERE event_id = ?0 LIMIT ?1")
    List<AsistenciaPorEvento> findByEventId(String eventId, int limit);
}
