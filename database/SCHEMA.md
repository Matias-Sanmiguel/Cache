# Esquema de datos — MVP caché

Arquitectura políglota: cada motor modela lo que mejor sabe hacer. El `userId`
(UUID) y el `eventId` / `venueId` son las claves que cosen los cuatro motores.

| Motor | Rol | Persistencia |
|---|---|---|
| MongoDB | catálogo + identidad (events, venues, users) | durable |
| Neo4j | grafo social + recomendaciones | durable |
| Redis | presencia, contadores, sesiones, notificaciones | efímero (TTL) |
| Cassandra | historial crudo + métricas del dashboard | durable, append-only |

---

## MongoDB — catálogo e identidad

Base `cache`. Índices creados explícitamente en
[`IndexInitializer`](../backend/src/main/java/com/cache/config/IndexInitializer.java)
en cada arranque (idempotente; `auto-index-creation` no alcanza y los reimports
con `--drop` borran los índices).

### `users` — identidad y perfil (auth)
| Campo | Tipo | Notas |
|---|---|---|
| `userId` | string | UUID, **unique**. Compartido con el `UserNode` de Neo4j |
| `email` | string | lowercase, **unique** |
| `passwordHash` | string | bcrypt — nunca plaintext |
| `role` | enum | `VISITOR` \| `VENUE_OWNER` \| `ADMIN` |
| `venueId` | string | sólo `VENUE_OWNER`: venue que administra |
| `displayName` | string | |
| `handle` | string | sin `@`, **unique** |
| `avatarColor` | string | hex |
| `city` | string | |
| `createdAt` / `lastActiveAt` | instant | |

Índices: `userId` ⟂, `email` ⟂, `handle` ⟂ (todos unique).

### `events` — eventos
| Campo | Tipo | Notas |
|---|---|---|
| `_id` | string | `eventId` referenciado por Neo4j |
| `name` | string | indexado |
| `venueId` / `venueName` / `venueAddress` | string | desnormalizado desde `venues` |
| `location` | GeoJSON Point | índice `2dsphere` ("cerca de mí") |
| `startsAt` / `endsAt` | instant | `startsAt` indexado |
| `genres` | string[] | indexado |
| `lineup` | LineupSlot[] | `{ time, slot, artist }` |
| `price` | decimal | |
| `capacity` / `attendeeCount` | int | |
| `accessType` | string | `public` \| `private` \| `invite-only` |
| `hostUserId` | string | dueño del evento privado, o null |
| `status` | string | `upcoming` \| `live` \| `finished` (indexado) |
| `city` | string | indexado |

Índices: simples en `name/status/startsAt/genres/city`, geo en `location`,
compuesto `city_status_startsAt` (feed paginado).

### `venues` — locales
| Campo | Tipo | Notas |
|---|---|---|
| `venueId` | string | **unique** |
| `name` / `address` | string | |
| `city` | string | indexado |
| `location` | GeoJSON Point | índice `2dsphere` |
| `capacity` | int | |
| `tags` | string[] | `["techno","palermo","18+"]` — el **barrio/zona** sale de acá |

> **Zona**: el MVP no tiene un campo `zone` dedicado; la zona se deriva del
> barrio en `tags` / `address` (ej. "palermo", "chacarita"). Cassandra
> (`eventos_por_zona`) la guarda desnormalizada como texto.

---

## Neo4j — grafo social y recomendaciones

Mismo `userId` / `eventId` que Mongo. IDs internos generados por Neo4j.

### Nodos
- **`User`** `{ userId, name, city }`
- **`Event`** `{ eventId, name, venueId, venueName, genre, city, startsAtEpoch }`

### Relaciones
- **`(User)-[:FRIENDS_WITH]-(User)`** — amistad (no dirigida en la práctica)
- **`(User)-[:ATTENDING { registeredAt, status }]->(Event)`** — anotación;
  `status` = `confirmed` \| `pending` \| `cancelled`

### Query principal (recomendación)
Eventos donde se anotaron amigos directos:
```cypher
MATCH (me:User {userId:$userId})-[:FRIENDS_WITH]-(friend:User)-[:ATTENDING]->(e:Event)
RETURN e.eventId AS eventId, count(friend) AS friendCount
ORDER BY friendCount DESC
```

---

## Redis — tiempo real, sesiones y notificaciones

Sin esquema fijo; convención de keys (todas con TTL salvo contadores):

| Key | Tipo | TTL | Qué guarda |
|---|---|---|---|
| `session:<token>` | string | 7 d | `userId` — auth token opaco ([SessionService](../backend/src/main/java/com/cache/service/SessionService.java)) |
| `presence:<userId>` | string | 8 h | venueId donde está el user ahora |
| `venue:<venueId>:present` | set | 8 h | userIds presentes en el venue |
| `event:<eventId>:attendees` | string (int) | — | contador de anotados (incr/decr) |
| `notif:<userId>` | list | — | cola "tu amigo X se anotó en Y" *(pendiente de wiring)* |

---

## Cassandra — historial y dashboard

Keyspace `cache_ks` (`SimpleStrategy`, RF 1). Definición autoritativa en
[`schema.cql`](cassandra/schema.cql). Diseño **query-first**: cada tabla modela
una lectura concreta.

### Historial (append-only)
- **`checkin_history`** — PK `(user_id, checked_at DESC)`. "¿A qué fue este user?"

### Dashboard (fuente de verdad de métricas)
| Tabla | Pregunta | Partition key | Clustering | Tipo |
|---|---|---|---|---|
| `venue_trends_counter` | check-ins por venue / día / hora | `venue_id` | `date DESC, hour ASC` | COUNTER |
| `venue_hour_users` | membresía user×venue×hora (únicos) | `(venue_id, date, hour)` | `user_id` | rows (LWT) |
| `pico_de_anotaciones` | a qué hora se anota más la gente | `fecha` | `hora ASC` | COUNTER |
| `asistencias_por_evento` | quién se anotó, cuándo, desde qué zona | `event_id` | `anotado_at DESC, user_id` | rows |
| `eventos_por_zona` | qué zonas concentran más esta semana | `semana` (`2026-W23`) | `zona` | COUNTER |
| `generos_por_fecha` | qué géneros traccionan en el tiempo | `fecha` (`2026-06-01`) | `genero` | COUNTER |

Las tablas COUNTER se incrementan atómicamente en cada anotación (`x = x + 1`, sin
read-modify-write). `unique_users` usa una LWT (`IF NOT EXISTS`) sobre `venue_hour_users`.

> **Wiring actual:** `pico_de_anotaciones`, `venue_trends_counter` y `venue_hour_users`
> se escriben en cada check-in (`CassandraDashboardRepository`) y alimentan el pico de
> anotaciones del dashboard y las tendencias por venue. `eventos_por_zona` y
> `generos_por_fecha` hoy se derivan del catálogo Mongo (eventos activos) en el
> `DashboardService`; `asistencias_por_evento` queda disponible para la vista de
> asistentes del merchant.

---

## Cómo se cosen en una anotación ("anotarse a un evento")

1. **Redis** — `incr event:<id>:attendees` + presencia (tiempo real). **Sincrónico**:
   se hace en el hilo del request porque es lo más crítico y rápido.
2. **Kafka** — `CheckinService` publica un `CheckinEvent` al topic `domain.checkin`.
   El resto del fan-out ocurre **async** en `CheckinConsumer` (check-in resiliente y
   de baja latencia; consistencia eventual del grafo y las métricas):
   - **Neo4j** — crea `(:User)-[:ATTENDING]->(:Event)` (recomendaciones)
   - **Cassandra** — append a `checkin_history` e `incr` atómico en
     `pico_de_anotaciones` / `venue_trends_counter` (+ `venue_hour_users` para únicos)
3. **Mongo** — `attendeeCount` sólo para mostrar; la verdad vive en Redis/Cassandra

Orquestado en [`CheckinService`](../backend/src/main/java/com/cache/service/CheckinService.java)
(productor) y [`CheckinConsumer`](../backend/src/main/java/com/cache/service/CheckinConsumer.java)
(consumidor).
