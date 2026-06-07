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

# schema + datos de cassandra desde los .cql canónicos (single source of truth).
# orden: schema.cql (cache_ks + tablas + counters) → init_cassandra.cql (cache_logs)
# → populate_cassandra.cql (seed: logs + checkin_history + dashboard counters, IDs
# alineados con el export de mongo). idempotente: IF NOT EXISTS + TRUNCATE → re-runs ok.
# nota: docker compose ya carga el schema vía cassandra-init; lo repetimos acá para que
# populate.sh sea self-contained si lo corren contra una DB levantada sin ese servicio.
echo "→ cassandra: schema (cache_ks + cache_logs + tablas)"
docker exec -i cache_cassandra cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" < "$DB_DIR/cassandra/schema.cql"
docker exec -i cache_cassandra cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" < "$DB_DIR/cassandra/init_cassandra.cql"

echo "→ cassandra: seed (logs + check-ins + métricas del dashboard)"
docker exec -i cache_cassandra cqlsh -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" < "$DB_DIR/cassandra/populate_cassandra.cql"

echo "→ redis: presencia / sesiones / contadores"
REDIS_PASSWORD="$REDIS_PASSWORD" bash "$DB_DIR/redis/seed_redis.sh"

echo "✓ populate completo — login: gus@cache.com / cache123"
echo "⚠ mongoimport --drop borró los índices de mongo (incluido el 2dsphere de events.location)."
echo "  Reiniciá el backend para que IndexInitializer los recree, sino /api/events/nearby da 500."
