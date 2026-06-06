package com.cache.domain.cassandra.repository;

import com.cache.domain.cassandra.entity.EventosPorZona;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EventosPorZonaRepository extends CassandraRepository<EventosPorZona, Object> {

    @Query("SELECT * FROM eventos_por_zona WHERE semana = ?0")
    List<EventosPorZona> findBySemana(String semana);
}
