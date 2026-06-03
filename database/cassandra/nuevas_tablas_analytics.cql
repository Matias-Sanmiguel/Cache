-- =====================================================
-- CACHÉ — Tablas de analytics y tendencias
-- Archivo: nuevas_tablas_analytics.cql
-- =====================================================
-- Todas las tablas siguen el modelo Chebotko:
-- partition key diseñada para el patrón de acceso principal,
-- clustering keys para el ordenamiento natural de la query.
-- =====================================================

USE cache_logs;


-- -----------------------------------------------------
-- Q: ¿Quién se anotó a un evento, a qué hora y desde qué zona?
--
-- Partition key: event_id → todas las anotaciones de un evento
--   en la misma partición, listo para leer de un solo shot.
-- Clustering: signup_time DESC → los más recientes primero.
-- zone es campo regular porque filtramos por zona
--   en memoria o con ALLOW FILTERING (bajo cardinalidad).
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS assists_per_event (
    event_id    UUID,
    signup_time TIMESTAMP,
    user_id     UUID,
    zone        TEXT,

    PRIMARY KEY ((event_id), signup_time, user_id)
)
WITH CLUSTERING ORDER BY (signup_time DESC, user_id ASC);


-- -----------------------------------------------------
-- Q: ¿Qué zonas están concentrando más anotaciones esta semana?
--
-- Partition key compuesta (zone, week) → una partición por
--   zona por semana. Evita hotspots en zonas muy populares
--   y acota el tamaño de partición naturalmente.
-- week formato ISO: '2025-W23'
-- Clustering: signup_time DESC → recientes primero.
-- signup_count es un counter que se incrementa por cada
--   anotación nueva en esa zona+semana.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS events_per_zone (
    zone        TEXT,
    week        TEXT,
    signup_time TIMESTAMP,
    event_id    UUID,
    event_name  TEXT,

    PRIMARY KEY ((zone, week), signup_time, event_id)
)
WITH CLUSTERING ORDER BY (signup_time DESC, event_id ASC);


-- -----------------------------------------------------
-- Q: ¿Qué géneros musicales están traccionando más en el tiempo?
--
-- Partition key: genre → todos los eventos de un género juntos.
-- Clustering: event_date DESC → los más recientes primero,
--   permite rangos temporales con event_date >= ?
-- signup_count permite comparar tracción entre géneros
--   para la misma fecha sin leer todas las filas.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS genres_per_date (
    genre        TEXT,
    event_date   DATE,
    event_id     UUID,
    event_name   TEXT,
    signup_count INT,

    PRIMARY KEY ((genre), event_date, event_id)
)
WITH CLUSTERING ORDER BY (event_date DESC, event_id ASC);


-- -----------------------------------------------------
-- Q: ¿A qué hora del día la gente se anota más en eventos?
--
-- Partition key: signup_date → un día entero por partición,
--   acotado y predecible en tamaño (max 24 filas por día
--   si agrupamos por hora).
-- Clustering: hour ASC → de 0 a 23, natural para graficar
--   la curva de anotaciones a lo largo del día.
-- signup_count se incrementa con cada anotación en esa hora.
-- unique_users permite distinguir si es un usuario
--   registrándose muchas veces o muchos usuarios distintos.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS annotations_peak (
    signup_date  DATE,
    hour         INT,
    signup_count INT,
    unique_users INT,

    PRIMARY KEY ((signup_date), hour)
)
WITH CLUSTERING ORDER BY (hour ASC);
