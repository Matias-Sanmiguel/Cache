package com.cache.domain.cassandra.logs.repository;

import com.cache.domain.cassandra.logs.entity.AttendanceLog;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.cassandra.core.CassandraTemplate;
import org.springframework.data.cassandra.core.query.Criteria;
import org.springframework.data.cassandra.core.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class AttendanceLogRepository {

    @Qualifier("logsTemplate")
    private final CassandraTemplate logsTemplate;

    public void save(AttendanceLog log) {
        logsTemplate.insert(log);
    }

    // historial completo de asistencias de un user
    public List<AttendanceLog> findByUserId(String userId, int limit) {
        return logsTemplate.select(
                Query.query(Criteria.where("user_id").is(userId)).limit(limit),
                AttendanceLog.class
        );
    }
}