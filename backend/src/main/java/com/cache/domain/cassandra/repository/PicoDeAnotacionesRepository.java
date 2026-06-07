package com.cache.domain.cassandra.repository;

import com.cache.domain.cassandra.entity.PicoDeAnotaciones;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PicoDeAnotacionesRepository extends CassandraRepository<PicoDeAnotaciones, Object> {

    @Query("SELECT * FROM pico_de_anotaciones WHERE fecha = ?0")
    List<PicoDeAnotaciones> findByFecha(String fecha);
}
