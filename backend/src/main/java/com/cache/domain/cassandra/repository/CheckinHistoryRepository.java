package com.cache.domain.cassandra.repository;

import com.cache.domain.cassandra.entity.CheckinHistory;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;

@Repository
public interface CheckinHistoryRepository extends CassandraRepository<CheckinHistory, Object> {

    // historial reciente de un user — aprovecha el clustering desc
    @Query("SELECT * FROM checkin_history WHERE user_id = ?0 LIMIT ?1")
    List<CheckinHistory> findRecentByUserId(String userId, int limit);

    // historial entre fechas — para analytics de perfil
    @Query("SELECT * FROM checkin_history WHERE user_id = ?0 AND checked_at >= ?1 AND checked_at <= ?2")
    List<CheckinHistory> findByUserIdBetween(String userId, Instant from, Instant to);

    // si el user fue a un venue — base para recomendaciones de lugar
    @Query("SELECT * FROM checkin_history WHERE user_id = ?0 AND venue_id = ?1 ALLOW FILTERING")
    List<CheckinHistory> findByUserIdAndVenueId(String userId, String venueId);
}
