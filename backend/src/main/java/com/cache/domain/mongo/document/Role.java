package com.cache.domain.mongo.document;

// roles de la app:
// VISITOR     → cliente, se anota a eventos (default)
// VENUE_OWNER → dueño de local, gestiona su venue/eventos
// ADMIN       → equipo caché, acceso total + dashboard
public enum Role {
    VISITOR,
    VENUE_OWNER,
    ADMIN
}
