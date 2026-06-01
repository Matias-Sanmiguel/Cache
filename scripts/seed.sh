#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/.env"

# datos de prueba coherentes entre los 4 motores.
# clave compartida: userId (u1..u5) y eventId (e1..e3) son los mismos en mongo y neo4j,
# así las recomendaciones de neo4j (que devuelven ids) resuelven contra el catálogo de mongo.
#
# grafo social sembrado:
#   u1 ── u2 ── u3        (triángulo de amigos)
#    └──────┘   └── u4    (u4 amigo de u3 → "quizás conozcas" para u1)
#   u5 ─→ u1              (solicitud PENDING_FRIEND hacia u1)
# asistencias: u2→e1, u3→e1, u3→e2, u2→e3

echo "→ seeding mongodb (users, venues, events)"
docker exec cache_mongo mongosh \
  --username "$MONGO_USER" --password "$MONGO_PASSWORD" \
  --authenticationDatabase admin \
  --eval "
    db = db.getSiblingDB('$MONGO_DB');

    db.users.deleteMany({});
    db.venues.deleteMany({});
    db.events.deleteMany({});

    const now = new Date();
    // hash bcrypt placeholder (password: 'cache123') — solo para datos de prueba
    const pw = '\$2a\$10\$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy';

    db.users.insertMany([
      { userId:'u1', email:'luca@cache.dev',   passwordHash:pw, displayName:'luca',   handle:'luca',   avatarColor:'#FF2E2E', city:'buenos aires', createdAt:now, lastActiveAt:now },
      { userId:'u2', email:'mia@cache.dev',    passwordHash:pw, displayName:'mia',    handle:'mia',    avatarColor:'#2EE6FF', city:'buenos aires', createdAt:now, lastActiveAt:now },
      { userId:'u3', email:'tomas@cache.dev',  passwordHash:pw, displayName:'tomas',  handle:'tomas',  avatarColor:'#E8E6DF', city:'buenos aires', createdAt:now, lastActiveAt:now },
      { userId:'u4', email:'jazmin@cache.dev', passwordHash:pw, displayName:'jazmin', handle:'jazmin', avatarColor:'#B14EFF', city:'buenos aires', createdAt:now, lastActiveAt:now },
      { userId:'u5', email:'nico@cache.dev',   passwordHash:pw, displayName:'nico',   handle:'nico',   avatarColor:'#4EFF7A', city:'buenos aires', createdAt:now, lastActiveAt:now }
    ]);

    db.venues.insertMany([
      { venueId:'v1', name:'niceto club',       address:'cnel niceto vega 5510', city:'buenos aires',
        location:{ type:'Point', coordinates:[-58.435, -34.585] }, capacity:300, tags:['techno','18+'] },
      { venueId:'v2', name:'terraza san telmo', address:'defensa 1100',          city:'buenos aires',
        location:{ type:'Point', coordinates:[-58.371, -34.621] }, capacity:150, tags:['latin','live'] }
    ]);

    db.events.insertMany([
      { _id:'e1', name:'electronic night', venueId:'v1', venueName:'niceto club',
        location:{ type:'Point', coordinates:[-58.435, -34.585] },
        startsAt:new Date('2026-06-14T23:00:00Z'), endsAt:new Date('2026-06-15T05:00:00Z'),
        genres:['techno','underground'], price:1500, capacity:300, attendeeCount:0,
        accessType:'public', status:'upcoming', city:'buenos aires' },
      { _id:'e2', name:'salsa rooftop', venueId:'v2', venueName:'terraza san telmo',
        location:{ type:'Point', coordinates:[-58.371, -34.621] },
        startsAt:new Date('2026-06-15T21:00:00Z'), endsAt:new Date('2026-06-16T02:00:00Z'),
        genres:['latin','live'], price:800, capacity:150, attendeeCount:0,
        accessType:'public', status:'upcoming', city:'buenos aires' },
      { _id:'e3', name:'indie session', venueId:'v1', venueName:'niceto club',
        location:{ type:'Point', coordinates:[-58.435, -34.585] },
        startsAt:new Date('2026-06-20T22:00:00Z'), endsAt:new Date('2026-06-21T03:00:00Z'),
        genres:['indie','rock'], price:1200, capacity:300, attendeeCount:0,
        accessType:'public', status:'upcoming', city:'buenos aires' }
    ]);
  "

echo "→ seeding neo4j (grafo social + eventos)"
docker exec cache_neo4j cypher-shell \
  -u "$NEO4J_USER" -p "$NEO4J_PASSWORD" \
  "MATCH (n) DETACH DELETE n;

   CREATE (:User {userId:'u1', name:'luca',   city:'buenos aires'}),
          (:User {userId:'u2', name:'mia',    city:'buenos aires'}),
          (:User {userId:'u3', name:'tomas',  city:'buenos aires'}),
          (:User {userId:'u4', name:'jazmin', city:'buenos aires'}),
          (:User {userId:'u5', name:'nico',   city:'buenos aires'});

   CREATE (:Event {eventId:'e1', name:'electronic night', venueId:'v1', venueName:'niceto club',       genre:'techno', city:'buenos aires', startsAtEpoch: datetime('2026-06-14T23:00:00Z').epochMillis}),
          (:Event {eventId:'e2', name:'salsa rooftop',    venueId:'v2', venueName:'terraza san telmo', genre:'latin',  city:'buenos aires', startsAtEpoch: datetime('2026-06-15T21:00:00Z').epochMillis}),
          (:Event {eventId:'e3', name:'indie session',    venueId:'v1', venueName:'niceto club',       genre:'indie',  city:'buenos aires', startsAtEpoch: datetime('2026-06-20T22:00:00Z').epochMillis});

   MATCH (a:User {userId:'u1'}),(b:User {userId:'u2'}) CREATE (a)-[:FRIENDS_WITH {since: timestamp()}]->(b);
   MATCH (a:User {userId:'u1'}),(b:User {userId:'u3'}) CREATE (a)-[:FRIENDS_WITH {since: timestamp()}]->(b);
   MATCH (a:User {userId:'u2'}),(b:User {userId:'u3'}) CREATE (a)-[:FRIENDS_WITH {since: timestamp()}]->(b);
   MATCH (a:User {userId:'u3'}),(b:User {userId:'u4'}) CREATE (a)-[:FRIENDS_WITH {since: timestamp()}]->(b);

   MATCH (a:User {userId:'u5'}),(b:User {userId:'u1'}) CREATE (a)-[:PENDING_FRIEND {requestedAt: timestamp()}]->(b);

   MATCH (u:User {userId:'u2'}),(e:Event {eventId:'e1'}) CREATE (u)-[:ATTENDING {registeredAt: datetime(), status:'confirmed'}]->(e);
   MATCH (u:User {userId:'u3'}),(e:Event {eventId:'e1'}) CREATE (u)-[:ATTENDING {registeredAt: datetime(), status:'confirmed'}]->(e);
   MATCH (u:User {userId:'u3'}),(e:Event {eventId:'e2'}) CREATE (u)-[:ATTENDING {registeredAt: datetime(), status:'confirmed'}]->(e);
   MATCH (u:User {userId:'u2'}),(e:Event {eventId:'e3'}) CREATE (u)-[:ATTENDING {registeredAt: datetime(), status:'confirmed'}]->(e);"

echo "→ seeding redis (presencia)"
docker exec cache_redis redis-cli -a "$REDIS_PASSWORD" \
  SET "presence:u2" "v1" EX 3600
docker exec cache_redis redis-cli -a "$REDIS_PASSWORD" \
  SADD "venue:v1:present" "u2"

echo "→ seeding cassandra (historial de check-ins)"
# columnas alineadas con la entidad CheckinHistory (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
# se siembran check-ins de los amigos de u1 (u2, u3) → alimentan "venues frecuentes de tus amigos"
docker exec cache_cassandra cqlsh \
  -u "$CASSANDRA_USER" -p "$CASSANDRA_PASSWORD" \
  -e "
    CREATE KEYSPACE IF NOT EXISTS $CASSANDRA_KEYSPACE
      WITH replication = {'class':'SimpleStrategy','replication_factor':1};

    CREATE TABLE IF NOT EXISTS ${CASSANDRA_KEYSPACE}.checkin_history (
      user_id    text,
      checked_at timestamp,
      event_id   text,
      venue_id   text,
      venue_name text,
      genre      text,
      city       text,
      PRIMARY KEY (user_id, checked_at)
    ) WITH CLUSTERING ORDER BY (checked_at DESC);

    TRUNCATE ${CASSANDRA_KEYSPACE}.checkin_history;

    INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
      VALUES ('u2', toTimestamp(now()), 'e1', 'v1', 'niceto club', 'techno', 'buenos aires');
    INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
      VALUES ('u2', '2026-05-20T23:30:00Z', 'e3', 'v1', 'niceto club', 'indie', 'buenos aires');
    INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
      VALUES ('u3', toTimestamp(now()), 'e1', 'v1', 'niceto club', 'techno', 'buenos aires');
    INSERT INTO ${CASSANDRA_KEYSPACE}.checkin_history (user_id, checked_at, event_id, venue_id, venue_name, genre, city)
      VALUES ('u3', '2026-05-18T22:00:00Z', 'e2', 'v2', 'terraza san telmo', 'latin', 'buenos aires');"

echo "✓ seed completo"
