-- Historial de check-ins por usuario.
-- Está pensada para responder:
-- "¿A qué eventos / venues fue este usuario?"
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

-- Tendencias horarias por venue.
-- Está pensada para responder:
-- "¿Cuánta gente hizo check-in en este venue, en este día y hora?"
CREATE TABLE IF NOT EXISTS venue_trends (
  venue_id TEXT,
  date TEXT,
  hour INT,
  checkin_count INT,
  unique_users INT,
  top_genre TEXT,

  -- venue_id es la partition key.
  -- date y hour ordenan las estadísticas por día y hora.
  PRIMARY KEY (venue_id, date, hour)
) WITH CLUSTERING ORDER BY (date DESC, hour ASC);
