#!/usr/bin/env bash
# Carga el dataset real de database/ en las 4 bases (lo que pushearon en database/).
# A diferencia de seed.sh (data inline mínima), esto importa los export/*.json reales,
# el grafo completo de neo4j, las tablas de analytics de cassandra y la presencia de redis.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DB_DIR="$ROOT_DIR/database"
source "$ROOT_DIR/.env"

# hash bcrypt real de la password 'cache123' (generado con el BCryptPasswordEncoder
# del backend) — los export traen "bcrypt_hash_demo" placeholder, lo reemplazamos
# para que el login funcione de verdad.
PW_HASH='$2a$10$hXTLnmbcBFNGTMrCmARPluuaAG74cHqBqCM0f4jbHjORRo9OzFW/q'

echo "→ mongodb: importando users / venues / events (export reales)"
for col in users venues events; do
  docker exec -i cache_mongo mongoimport \
    --username "$MONGO_USER" --password "$MONGO_PASSWORD" --authenticationDatabase admin \
    --db "$MONGO_DB" --collection "$col" --jsonArray --drop \
    < "$DB_DIR/mongodb/export/${col}.json"
done

echo "→ mongodb: seteando password hash real (login con password 'cache123')"
docker exec cache_mongo mongosh --quiet \
  --username "$MONGO_USER" --password "$MONGO_PASSWORD" --authenticationDatabase admin \
  --eval "db.getSiblingDB('$MONGO_DB').users.updateMany({}, { \$set: { passwordHash: '$PW_HASH' } })"

echo "→ neo4j: cargando grafo social completo (venues, users, events, genres, amistades)"
docker exec -i cache_neo4j cypher-shell \
  -u "$NEO4J_USER" -p "$NEO4J_PASSWORD" \
  < "$DB_DIR/neo4j/seed_neo4j.cypher"

echo "→ cassandra: keyspace de la app ($CASSANDRA_KEYSPACE) + historial de check-ins"
docker exec -i cache_cassandra cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" <<CQL
CREATE KEYSPACE IF NOT EXISTS ${CASSANDRA_KEYSPACE} WITH replication = {'class':'SimpleStrategy','replication_factor':1};
CREATE TABLE IF NOT EXISTS ${CASSANDRA_KEYSPACE}.checkin_history (user_id text, checked_at timestamp, event_id text, venue_id text, venue_name text, genre text, city text, PRIMARY KEY (user_id, checked_at)) WITH CLUSTERING ORDER BY (checked_at DESC);
TRUNCATE ${CASSANDRA_KEYSPACE}.checkin_history;
INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city) VALUES ('USR002', toTimestamp(now()), 'EVT001', 'VEN001', 'Niceto Club', 'techno', 'buenos aires');
INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city) VALUES ('USR002', '2026-05-20T23:30:00Z', 'EVT003', 'VEN001', 'Niceto Club', 'indie', 'buenos aires');
INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city) VALUES ('USR003', toTimestamp(now()), 'EVT001', 'VEN001', 'Niceto Club', 'techno', 'buenos aires');
INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city) VALUES ('USR003', '2026-05-18T22:00:00Z', 'EVT002', 'VEN002', 'Crobar', 'techno', 'buenos aires');
CQL

echo "→ cassandra: schema de logs + analytics (cache_logs)"
docker exec -i cache_cassandra cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" < "$DB_DIR/cassandra/init_cassandra.cql"
docker exec -i cache_cassandra cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" < "$DB_DIR/cassandra/nuevas_tablas_analytics.cql"

echo "→ redis: presencia / sesiones / contadores"
REDIS_PASSWORD="$REDIS_PASSWORD" bash "$DB_DIR/redis/seed_redis.sh"

echo "✓ populate completo — login: gus@cache.com / cache123"
