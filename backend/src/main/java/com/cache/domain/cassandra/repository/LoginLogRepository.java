package com.cache.domain.cassandra.logs.repository;

import com.cache.domain.cassandra.logs.entity.LoginLog;
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
public class LoginLogRepository {

    @Qualifier("logsTemplate")
    private final CassandraTemplate logsTemplate;

    public void save(LoginLog log) {
        logsTemplate.insert(log);
    }

    // historial de logins de un user — aprovecha el clustering desc
    public List<LoginLog> findRecentByUserId(String userId, int limit) {
        return logsTemplate.select(
                Query.query(Criteria.where("user_id").is(userId)).limit(limit),
                LoginLog.class
        );
    }

    // logins de un user en una fecha específica
    public List<LoginLog> findByUserIdAndDate(String userId, LocalDate date) {
        return logsTemplate.select(
                Query.query(
                        Criteria.where("user_id").is(userId)
                                .and("event_date").is(date)
                ),
                LoginLog.class
        );
    }

    // solo los logins fallidos — para detección de fuerza bruta
    public List<LoginLog> findFailedByUserId(String userId, int limit) {
        return logsTemplate.select(
                Query.query(
                        Criteria.where("user_id").is(userId)
                                .and("success").is(false)
                ).limit(limit),
                LoginLog.class
        );
    }
}