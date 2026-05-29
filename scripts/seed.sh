#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/.env"

echo "→ seeding neo4j"
docker exec cache_neo4j cypher-shell \
  -u "$NEO4J_USER" -p "$NEO4J_PASSWORD" \
  "CREATE (:User {id: 'u1', name: 'luca', age: 25})
   CREATE (:User {id: 'u2', name: 'mia', age: 23})
   CREATE (:Venue {id: 'v1', name: 'niceto club', lat: -34.585, lon: -58.435})
   MATCH (a:User {id:'u1'}), (b:User {id:'u2'}) CREATE (a)-[:FRIENDS_WITH]->(b)
   MATCH (u:User {id:'u1'}), (v:Venue {id:'v1'}) CREATE (u)-[:CHECKED_IN {at: datetime()}]->(v);"

echo "→ seeding redis"
docker exec cache_redis redis-cli -a "$REDIS_PASSWORD" \
  SET "presence:u1" '{"status":"online","venue":"v1","since":1700000000}' EX 3600
docker exec cache_redis redis-cli -a "$REDIS_PASSWORD" \
  SADD "venue:v1:present" "u1"

echo "→ seeding mongodb"
docker exec cache_mongo mongosh \
  --username "$MONGO_USER" --password "$MONGO_PASSWORD" \
  --authenticationDatabase admin \
  --eval "
    use $MONGO_DB;
    db.events.insertMany([
      {
        _id: ObjectId(),
        name: 'electronic night',
        venue_id: 'v1',
        date: new Date('2025-06-14T23:00:00Z'),
        tags: ['techno', 'underground'],
        capacity: 300,
        ticket_price: 1500
      },
      {
        _id: ObjectId(),
        name: 'salsa rooftop',
        venue_id: 'v1',
        date: new Date('2025-06-15T21:00:00Z'),
        tags: ['latin', 'live'],
        capacity: 150,
        ticket_price: 800
      }
    ]);
  "

echo "→ seeding cassandra"
docker exec cache_cassandra cqlsh \
  -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" \
  -e "
    CREATE KEYSPACE IF NOT EXISTS $CASSANDRA_KEYSPACE
      WITH replication = {'class':'SimpleStrategy','replication_factor':1};

    CREATE TABLE IF NOT EXISTS ${CASSANDRA_KEYSPACE}.checkin_history (
      user_id   text,
      venue_id  text,
      checked_at timestamp,
      PRIMARY KEY (user_id, checked_at)
    ) WITH CLUSTERING ORDER BY (checked_at DESC);

    INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, venue_id, checked_at)
      VALUES ('u1', 'v1', toTimestamp(now()));
    INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, venue_id, checked_at)
      VALUES ('u2', 'v1', toTimestamp(now()));
  "

echo "✓ seed completo"
