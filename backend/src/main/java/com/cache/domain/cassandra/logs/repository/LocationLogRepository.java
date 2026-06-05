package com.cache.domain.cassandra.logs.repository;

import com.cache.domain.cassandra.logs.entity.LocationLog;
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
public class LocationLogRepository {

    @Qualifier("logsTemplate")
    private final CassandraTemplate logsTemplate;

    public void save(LocationLog log) {
        logsTemplate.insert(log);
    }

    // movimientos de un user en una fecha
    public List<LocationLog> findByUserIdAndDate(String userId, LocalDate date) {
        return logsTemplate.select(
                Query.query(
                        Criteria.where("user_id").is(userId)
                                .and("log_date").is(date)
                ),
                LocationLog.class
        );
    }
}