-- Keyspace principal del proyecto CACHE.
-- En Cassandra, el keyspace sería parecido a una "base de datos".
CREATE KEYSPACE IF NOT EXISTS cache_ks
WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': 1
}
AND durable_writes = true;

USE cache_ks;

-- =====================================================================
-- HISTORIAL (base append-only) — el registro crudo desde el día uno
-- =====================================================================

-- Historial de check-ins por usuario.
-- Responde: "¿A qué eventos / venues fue este usuario?"
CREATE TABLE IF NOT EXISTS checkin_history (
  user_id TEXT,
  checked_at TIMESTAMP,
  event_id TEXT,
  venue_id TEXT,
  venue_name TEXT,
  genre TEXT,
  city TEXT,

  -- user_id es la partition key.
  -- checked_at ordena los check-ins del usuario por fecha.
  PRIMARY KEY (user_id, checked_at)
) WITH CLUSTERING ORDER BY (checked_at DESC);

-- Tendencias horarias por venue (tabla COUNTER).
-- Responde: "¿Cuánta gente hizo check-in en este venue, en este día y hora?"
-- Los counters se incrementan atómicamente en cada anotación (sin read-modify-write).
CREATE TABLE IF NOT EXISTS venue_trends_counter (
  venue_id TEXT,
  date TEXT,
  hour INT,
  checkin_count COUNTER,
  unique_users COUNTER,

  -- venue_id es la partition key; date y hour ordenan por día y hora.
  PRIMARY KEY ((venue_id), date, hour)
) WITH CLUSTERING ORDER BY (date DESC, hour ASC);

-- Membresía user×venue×hora — soporta el conteo de usuarios ÚNICOS sin race.
-- En cada anotación se hace INSERT ... IF NOT EXISTS (LWT): solo si aplica
-- (primer check-in del user en esa hora) se incrementa unique_users.
CREATE TABLE IF NOT EXISTS venue_hour_users (
  venue_id TEXT,
  date TEXT,
  hour INT,
  user_id TEXT,

  PRIMARY KEY ((venue_id, date, hour), user_id)
);

-- =====================================================================
-- DASHBOARD (fuente de verdad de las métricas) — Cassandra con protagonismo.
-- Diseño query-first: cada tabla está modelada para UNA lectura del panel.
-- Las tablas COUNTER se incrementan atómicamente en cada anotación.
-- =====================================================================

-- 1) asistencias_por_evento
-- Responde: "¿Quién se anotó a este evento, a qué hora y desde qué zona?"
-- Partición = event_id → todas las anotaciones de un evento en una sola lectura,
-- ordenadas de la más reciente a la más vieja.
CREATE TABLE IF NOT EXISTS asistencias_por_evento (
  event_id TEXT,
  anotado_at TIMESTAMP,
  user_id TEXT,
  user_handle TEXT,
  zona TEXT,
  genre TEXT,

  PRIMARY KEY (event_id, anotado_at, user_id)
) WITH CLUSTERING ORDER BY (anotado_at DESC);

-- 2) eventos_por_zona
-- Responde: "¿Qué zonas concentran más anotaciones esta semana?"
-- Partición = semana (ISO, ej "2026-W23") → todas las zonas de la semana en una
-- lectura; el dashboard ordena por 'anotaciones' del lado del cliente.
CREATE TABLE IF NOT EXISTS eventos_por_zona (
  semana TEXT,
  zona TEXT,
  anotaciones COUNTER,

  PRIMARY KEY (semana, zona)
);

-- 3) generos_por_fecha
-- Responde: "¿Qué géneros musicales traccionan más en el tiempo?"
-- Partición = fecha ("2026-06-01") → todos los géneros de ese día en una lectura.
CREATE TABLE IF NOT EXISTS generos_por_fecha (
  fecha TEXT,
  genero TEXT,
  anotaciones COUNTER,

  PRIMARY KEY (fecha, genero)
);

-- 4) pico_de_anotaciones
-- Responde: "¿A qué hora del día se anota más la gente?"
-- Partición = fecha → 24 filas (una por hora), ordenadas por hora asc.
CREATE TABLE IF NOT EXISTS pico_de_anotaciones (
  fecha TEXT,
  hora INT,
  anotaciones COUNTER,

  PRIMARY KEY (fecha, hora)
) WITH CLUSTERING ORDER BY (hora ASC);
