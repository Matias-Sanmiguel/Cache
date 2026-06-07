-- Seed data for Cassandra.
-- Run schema.cql and init_cassandra.cql before this file.
--
USE cache_logs;

-- Dev seed: reset target tables so the script can be re-run.
TRUNCATE login_logs;
TRUNCATE user_activity_logs;
TRUNCATE attendance_logs;
TRUNCATE location_logs;
TRUNCATE recommendation_logs;
TRUNCATE system_logs;

INSERT INTO login_logs (user_id, event_date, event_time, ip_address, device, success)
VALUES ('USR001', '2026-06-01', '2026-06-01T20:05:12Z', '181.44.10.22', 'mobile-ios', true);
INSERT INTO login_logs (user_id, event_date, event_time, ip_address, device, success)
VALUES ('USR001', '2026-06-02', '2026-06-02T22:14:51Z', '181.44.10.22', 'mobile-ios', true);
INSERT INTO login_logs (user_id, event_date, event_time, ip_address, device, success)
VALUES ('USR002', '2026-06-01', '2026-06-01T18:21:03Z', '190.19.88.10', 'web-chrome', true);
INSERT INTO login_logs (user_id, event_date, event_time, ip_address, device, success)
VALUES ('USR003', '2026-06-02', '2026-06-02T23:40:10Z', '201.231.76.9', 'mobile-android', false);
INSERT INTO login_logs (user_id, event_date, event_time, ip_address, device, success)
VALUES ('USR004', '2026-06-03', '2026-06-03T00:12:44Z', '186.12.45.91', 'web-firefox', true);

INSERT INTO user_activity_logs (user_id, activity_date, activity_time, activity_type, entity_type, entity_id, description)
VALUES ('USR001', '2026-06-01', '2026-06-01T20:08:00Z', 'VIEW_EVENT', 'event', 'EVT002', 'Viewed Crobar event detail');
INSERT INTO user_activity_logs (user_id, activity_date, activity_time, activity_type, entity_type, entity_id, description)
VALUES ('USR001', '2026-06-01', '2026-06-01T20:10:31Z', 'SAVE_EVENT', 'event', 'EVT002', 'Saved event to favorites');
INSERT INTO user_activity_logs (user_id, activity_date, activity_time, activity_type, entity_type, entity_id, description)
VALUES ('USR002', '2026-06-01', '2026-06-01T18:23:09Z', 'SEARCH', 'genre', 'techno', 'Searched techno events');
INSERT INTO user_activity_logs (user_id, activity_date, activity_time, activity_type, entity_type, entity_id, description)
VALUES ('USR003', '2026-06-02', '2026-06-02T23:42:55Z', 'VIEW_VENUE', 'venue', 'VEN001', 'Viewed Niceto Club venue detail');
INSERT INTO user_activity_logs (user_id, activity_date, activity_time, activity_type, entity_type, entity_id, description)
VALUES ('USR004', '2026-06-03', '2026-06-03T00:15:12Z', 'SHARE_EVENT', 'event', 'EVT001', 'Shared event with friends');

INSERT INTO attendance_logs (user_id, event_id, action_time, action_type)
VALUES ('USR001', 'EVT002', '2026-06-01T20:11:00Z', 'JOIN');
INSERT INTO attendance_logs (user_id, event_id, action_time, action_type)
VALUES ('USR002', 'EVT002', '2026-06-01T18:25:10Z', 'JOIN');
INSERT INTO attendance_logs (user_id, event_id, action_time, action_type)
VALUES ('USR003', 'EVT001', '2026-06-02T23:45:20Z', 'JOIN');
INSERT INTO attendance_logs (user_id, event_id, action_time, action_type)
VALUES ('USR004', 'EVT006', '2026-06-03T00:16:43Z', 'JOIN');
INSERT INTO attendance_logs (user_id, event_id, action_time, action_type)
VALUES ('USR002', 'EVT002', '2026-06-03T01:10:00Z', 'LEAVE');

INSERT INTO location_logs (user_id, log_date, event_time, latitude, longitude)
VALUES ('USR001', '2026-06-01', '2026-06-01T20:12:00Z', -34.571200, -58.420500);
INSERT INTO location_logs (user_id, log_date, event_time, latitude, longitude)
VALUES ('USR002', '2026-06-01', '2026-06-01T18:26:00Z', -34.571200, -58.420500);
INSERT INTO location_logs (user_id, log_date, event_time, latitude, longitude)
VALUES ('USR003', '2026-06-02', '2026-06-02T23:46:00Z', -34.586500, -58.435500);
INSERT INTO location_logs (user_id, log_date, event_time, latitude, longitude)
VALUES ('USR004', '2026-06-03', '2026-06-03T00:17:00Z', -34.588200, -58.456100);

INSERT INTO recommendation_logs (user_id, recommendation_time, event_id, score, reason)
VALUES ('USR001', '2026-06-01T20:20:00Z', 'EVT002', 0.94, 'Friends are attending and genre matches techno');
INSERT INTO recommendation_logs (user_id, recommendation_time, event_id, score, reason)
VALUES ('USR002', '2026-06-01T18:30:00Z', 'EVT005', 0.89, 'Recent searches mention melodic techno');
INSERT INTO recommendation_logs (user_id, recommendation_time, event_id, score, reason)
VALUES ('USR003', '2026-06-02T23:50:00Z', 'EVT001', 0.82, 'Nearby venue with high activity');
INSERT INTO recommendation_logs (user_id, recommendation_time, event_id, score, reason)
VALUES ('USR004', '2026-06-03T00:20:00Z', 'EVT006', 0.91, 'Similar past attendance pattern');

INSERT INTO system_logs (service_name, log_date, event_time, level, message)
VALUES ('backend', '2026-06-01', '2026-06-01T20:00:00Z', 'INFO', 'Application started');
INSERT INTO system_logs (service_name, log_date, event_time, level, message)
VALUES ('recommendation-worker', '2026-06-01', '2026-06-01T20:18:00Z', 'INFO', 'Generated recommendations batch');
INSERT INTO system_logs (service_name, log_date, event_time, level, message)
VALUES ('attendance-consumer', '2026-06-02', '2026-06-02T23:45:25Z', 'INFO', 'Attendance event persisted');
INSERT INTO system_logs (service_name, log_date, event_time, level, message)
VALUES ('backend', '2026-06-03', '2026-06-03T00:12:45Z', 'WARN', 'Login failed for USR003');

USE cache_ks;

-- Dev seed: reset target tables so the script can be re-run.
TRUNCATE venue_trends_counter;
TRUNCATE venue_hour_users;
TRUNCATE checkin_history;
TRUNCATE asistencias_por_evento;
TRUNCATE eventos_por_zona;
TRUNCATE generos_por_fecha;
TRUNCATE pico_de_anotaciones;
TRUNCATE notifications;

INSERT INTO checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
VALUES ('USR001', '2026-06-01T20:11:00Z', 'EVT002', 'VEN002', 'Crobar', 'techno', 'buenos aires');
INSERT INTO checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
VALUES ('USR001', '2026-06-02T21:35:00Z', 'EVT001', 'VEN001', 'Niceto Club', 'techno', 'buenos aires');
INSERT INTO checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
VALUES ('USR002', '2026-06-01T18:25:10Z', 'EVT002', 'VEN002', 'Crobar', 'techno', 'buenos aires');
INSERT INTO checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
VALUES ('USR003', '2026-06-02T23:45:20Z', 'EVT003', 'VEN003', 'Galpon sin nombre', 'bass', 'buenos aires');
INSERT INTO checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
VALUES ('USR004', '2026-06-03T00:16:43Z', 'EVT006', 'VEN006', 'Direccion confidencial', 'minimal', 'buenos aires');

INSERT INTO asistencias_por_evento (event_id, anotado_at, user_id, user_handle, zona, genre)
VALUES ('EVT002', '2026-06-01T20:11:00Z', 'USR001', '@gus', 'costanera', 'techno');
INSERT INTO asistencias_por_evento (event_id, anotado_at, user_id, user_handle, zona, genre)
VALUES ('EVT002', '2026-06-01T18:25:10Z', 'USR002', '@mati', 'costanera', 'techno');
INSERT INTO asistencias_por_evento (event_id, anotado_at, user_id, user_handle, zona, genre)
VALUES ('EVT003', '2026-06-02T23:45:20Z', 'USR003', '@jule', 'chacarita', 'bass');
INSERT INTO asistencias_por_evento (event_id, anotado_at, user_id, user_handle, zona, genre)
VALUES ('EVT006', '2026-06-03T00:16:43Z', 'USR004', '@luna004', 'chacarita', 'minimal');

-- Counter tables must be updated with increments; Cassandra does not accept
-- normal INSERT values for counter columns.
INSERT INTO venue_hour_users (venue_id, date, hour, user_id)
VALUES ('VEN002', '2026-06-01', 20, 'USR001');
INSERT INTO venue_hour_users (venue_id, date, hour, user_id)
VALUES ('VEN002', '2026-06-01', 18, 'USR002');
INSERT INTO venue_hour_users (venue_id, date, hour, user_id)
VALUES ('VEN003', '2026-06-02', 23, 'USR003');
INSERT INTO venue_hour_users (venue_id, date, hour, user_id)
VALUES ('VEN006', '2026-06-03', 0, 'USR004');

UPDATE venue_trends_counter SET checkin_count = checkin_count + 1, unique_users = unique_users + 1 WHERE venue_id = 'VEN002' AND date = '2026-06-01' AND hour = 20;
UPDATE venue_trends_counter SET checkin_count = checkin_count + 1, unique_users = unique_users + 1 WHERE venue_id = 'VEN002' AND date = '2026-06-01' AND hour = 18;
UPDATE venue_trends_counter SET checkin_count = checkin_count + 1, unique_users = unique_users + 1 WHERE venue_id = 'VEN003' AND date = '2026-06-02' AND hour = 23;
UPDATE venue_trends_counter SET checkin_count = checkin_count + 1, unique_users = unique_users + 1 WHERE venue_id = 'VEN006' AND date = '2026-06-03' AND hour = 0;

UPDATE eventos_por_zona SET anotaciones = anotaciones + 42 WHERE semana = '2026-W23' AND zona = 'palermo';
UPDATE eventos_por_zona SET anotaciones = anotaciones + 31 WHERE semana = '2026-W23' AND zona = 'costanera';
UPDATE eventos_por_zona SET anotaciones = anotaciones + 18 WHERE semana = '2026-W23' AND zona = 'chacarita';
UPDATE eventos_por_zona SET anotaciones = anotaciones + 15 WHERE semana = '2026-W23' AND zona = 'colegiales';

UPDATE generos_por_fecha SET anotaciones = anotaciones + 28 WHERE fecha = '2026-06-01' AND genero = 'rock';
UPDATE generos_por_fecha SET anotaciones = anotaciones + 22 WHERE fecha = '2026-06-01' AND genero = 'techno';
UPDATE generos_por_fecha SET anotaciones = anotaciones + 17 WHERE fecha = '2026-06-02' AND genero = 'pop';
UPDATE generos_por_fecha SET anotaciones = anotaciones + 24 WHERE fecha = '2026-06-03' AND genero = 'indie';

UPDATE pico_de_anotaciones SET anotaciones = anotaciones + 8 WHERE fecha = '2026-06-01' AND hora = 18;
UPDATE pico_de_anotaciones SET anotaciones = anotaciones + 14 WHERE fecha = '2026-06-01' AND hora = 20;
UPDATE pico_de_anotaciones SET anotaciones = anotaciones + 20 WHERE fecha = '2026-06-02' AND hora = 23;
UPDATE pico_de_anotaciones SET anotaciones = anotaciones + 11 WHERE fecha = '2026-06-03' AND hora = 0;
