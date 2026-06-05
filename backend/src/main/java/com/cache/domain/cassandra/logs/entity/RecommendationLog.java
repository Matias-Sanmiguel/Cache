package com.cache.domain.cassandra.logs.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.cql.Ordering;
import org.springframework.data.cassandra.core.cql.PrimaryKeyType;
import org.springframework.data.cassandra.core.mapping.Column;
import org.springframework.data.cassandra.core.mapping.PrimaryKeyColumn;
import org.springframework.data.cassandra.core.mapping.Table;

import java.time.Instant;

// qué recomendaciones se le mostraron a cada user, con qué score y por qué razón.
// partición por user_id: todo el historial de recomendaciones de un user en un read.
// clustering desc: la más reciente primero.
@Table("recommendation_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationLog {

    @PrimaryKeyColumn(name = "user_id", type = PrimaryKeyType.PARTITIONED)
    private String userId;

    @PrimaryKeyColumn(name = "recommendation_time", ordinal = 0, ordering = Ordering.DESCENDING)
    private Instant recommendationTime;

    @Column("event_id")
    private String eventId;

    // score calculado por el motor de neo4j (friendCount u otro ranking)
    @Column("score")
    private double score;

    // razón legible: FRIEND_ATTENDING | POPULAR_IN_CITY | GENRE_MATCH
    @Column("reason")
    private String reason;
}