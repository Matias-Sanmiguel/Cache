package com.cache.domain.cassandra.repository;

import com.cache.domain.cassandra.entity.Notification;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Repository
public interface NotificationRepository extends CassandraRepository<Notification, Object> {

    // notifs recientes de un user — aprovecha el clustering desc por created_at
    @Query("SELECT * FROM notifications WHERE user_id = ?0 LIMIT ?1")
    List<Notification> findRecentByUserId(String userId, int limit);

    // marca una notif como leída — la PK completa es obligatoria en un UPDATE de Cassandra
    @Query("UPDATE notifications SET read = true WHERE user_id = ?0 AND created_at = ?1 AND notif_id = ?2")
    void markRead(String userId, Instant createdAt, UUID notifId);
}
