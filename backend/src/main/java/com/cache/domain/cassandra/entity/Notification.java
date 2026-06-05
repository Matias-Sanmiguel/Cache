package com.cache.domain.cassandra.entity;

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
import java.util.UUID;

// notificaciones persistidas por usuario (pings sociales: amistades, check-ins de amigos).
// partición por user_id — todas las notifs de un user en un read.
// clustering desc por created_at — las más nuevas primero, sin sort manual.
// notif_id (UUID) desempata notifs del mismo instante y completa la PK para los UPDATE de "leído".
@Table("notifications")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Notification {

    @PrimaryKeyColumn(name = "user_id", type = PrimaryKeyType.PARTITIONED)
    private String userId;

    @PrimaryKeyColumn(name = "created_at", ordinal = 0, ordering = Ordering.DESCENDING)
    private Instant createdAt;

    @PrimaryKeyColumn(name = "notif_id", ordinal = 1)
    private UUID notifId;

    // friend-joined | live | urgent | recommend | system (alineado con el front)
    @Column("kind")
    private String kind;

    @Column("tag")
    private String tag;

    @Column("body")
    private String body;

    @Column("sub")
    private String sub;

    @Column("icon")
    private String icon;

    @Column("cta")
    private String cta;

    @Column("cta2")
    private String cta2;

    @Column("grp")
    private String grp;

    // avatar del actor (si la notif viene de otra persona)
    @Column("avatar_name")
    private String avatarName;

    @Column("avatar_color")
    private String avatarColor;

    // entidad referida (eventId / userId del actor) — para navegar desde el ping
    @Column("ref_id")
    private String refId;

    @Column("read")
    private boolean read;
}
