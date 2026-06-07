package com.cache.domain.cassandra.repository;

import com.datastax.oss.driver.api.core.CqlSession;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

// crea la tabla de notificaciones persistidas al arrancar.
// el CassandraConfig manual no escanea este paquete para schema-action, así que la
// creamos explícitamente (idempotente) — alineada con la entidad Notification.
@Component
@RequiredArgsConstructor
public class NotificationSchema {

    private final CqlSession cassandraSession;

    @PostConstruct
    void init() {
        cassandraSession.execute("""
            CREATE TABLE IF NOT EXISTS notifications (
              user_id text,
              created_at timestamp,
              notif_id uuid,
              kind text,
              tag text,
              body text,
              sub text,
              icon text,
              cta text,
              cta2 text,
              grp text,
              avatar_name text,
              avatar_color text,
              ref_id text,
              read boolean,
              PRIMARY KEY ((user_id), created_at, notif_id)
            ) WITH CLUSTERING ORDER BY (created_at DESC, notif_id ASC)
            """);
    }
}
