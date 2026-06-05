package com.cache.domain.cassandra.logs.repository;

import com.cache.domain.cassandra.logs.entity.SystemLog;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.cassandra.core.CassandraTemplate;
import org.springframework.data.cassandra.core.query.Criteria;
import org.springframework.data.cassandra.core.query.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class SystemLogRepository {

    @Qualifier("logsTemplate")
    private final CassandraTemplate logsTemplate;

    public void save(SystemLog log) {
        logsTemplate.insert(log);
    }

    // logs de un servicio en una fecha — para monitoreo
    public List<SystemLog> findByServiceAndDate(String serviceName, LocalDate date) {
        return logsTemplate.select(
                Query.query(
                        Criteria.where("service_name").is(serviceName)
                                .and("log_date").is(date)
                ),
                SystemLog.class
        );
    }

    // últimos N logs de un servicio (cualquier fecha)
    public List<SystemLog> findRecentByService(String serviceName, int limit) {
        return logsTemplate.select(
                Query.query(Criteria.where("service_name").is(serviceName)).limit(limit),
                SystemLog.class
        );
    }
}