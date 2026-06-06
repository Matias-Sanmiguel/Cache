package com.cache.domain.cassandra.repository;

import com.cache.domain.cassandra.entity.GenerosPorFecha;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GenerosPorFechaRepository extends CassandraRepository<GenerosPorFecha, Object> {

    @Query("SELECT * FROM generos_por_fecha WHERE fecha = ?0")
    List<GenerosPorFecha> findByFecha(String fecha);
}
