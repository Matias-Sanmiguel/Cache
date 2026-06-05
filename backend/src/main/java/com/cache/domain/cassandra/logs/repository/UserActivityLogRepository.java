package com.cache.domain.cassandra.logs.repository;

import com.cache.domain.cassandra.logs.entity.UserActivityLog;
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
public class UserActivityLogRepository {

    @Qualifier("logsTemplate")
    private final CassandraTemplate logsTemplate;

    public void save(UserActivityLog log) {
        logsTemplate.insert(log);
    }

    // actividad reciente de un user (todas las acciones)
    public List<UserActivityLog> findRecentByUserId(String userId, int limit) {
        return logsTemplate.select(
                Query.query(Criteria.where("user_id").is(userId)).limit(limit),
                UserActivityLog.class
        );
    }

    // actividad de un user en una fecha
    public List<UserActivityLog> findByUserIdAndDate(String userId, LocalDate date) {
        return logsTemplate.select(
                Query.query(
                        Criteria.where("user_id").is(userId)
                                .and("activity_date").is(date)
                ),
                UserActivityLog.class
        );
    }
}