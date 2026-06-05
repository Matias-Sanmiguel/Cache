package com.cache.domain.cassandra.logs.repository;

import com.cache.domain.cassandra.logs.entity.RecommendationLog;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.cassandra.core.CassandraTemplate;
import org.springframework.data.cassandra.core.query.Criteria;
import org.springframework.data.cassandra.core.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class RecommendationLogRepository {

    @Qualifier("logsTemplate")
    private final CassandraTemplate logsTemplate;

    public void save(RecommendationLog log) {
        logsTemplate.insert(log);
    }

    // últimas recomendaciones mostradas a un user — para auditoría del algoritmo
    public List<RecommendationLog> findRecentByUserId(String userId, int limit) {
        return logsTemplate.select(
                Query.query(Criteria.where("user_id").is(userId)).limit(limit),
                RecommendationLog.class
        );
    }
}