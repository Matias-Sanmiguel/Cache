# caché

red social de vida nocturna. arquitectura políglota:

| motor | uso | puerto |
|---|---|---|
| neo4j | grafo de relaciones y recomendaciones | 7687 / 7474 |
| redis | presencia en tiempo real, sesiones | 6379 |
| mongodb | catálogo de eventos | 27017 |
| cassandra | historial de check-ins, tendencias | 9042 |

stack: next.js 14 · spring boot 3.3 · java 21

---

## setup

```bash
cp .env.example .env
# editá .env con tus credenciales
bash scripts/setup.sh
```

## comandos

```bash
bash scripts/start.sh          # levanta docker
bash scripts/seed.sh           # carga datos de prueba
bash scripts/reset.sh          # limpia todo y vuelve a levantar

docker compose --profile admin up -d   # sube herramientas admin
```

## verificar healthchecks

```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```

salida esperada — los cuatro motores en estado `(healthy)`:

```
NAMES               STATUS
cache_neo4j         Up X minutes (healthy)
cache_redis         Up X minutes (healthy)
cache_mongo         Up X minutes (healthy)
cache_cassandra     Up X minutes (healthy)
```

verificación manual por motor:

```bash
# neo4j
curl -s http://localhost:7474 | head -c 50

# redis
docker exec cache_redis redis-cli -a $REDIS_PASSWORD ping

# mongodb
docker exec cache_mongo mongosh --quiet \
  --username $MONGO_USER --password $MONGO_PASSWORD \
  --authenticationDatabase admin \
  --eval "db.adminCommand('ping')"

# cassandra
docker exec cache_cassandra cqlsh \
  -u $CASSANDRA_USER -p $CASSANDRA_PASSWORD \
  -e "describe keyspaces"
```

## herramientas admin (dev)

```bash
docker compose --profile admin up -d
```

- mongo express: http://localhost:8081
- redisinsight: http://localhost:5540

## estructura

```
cache/
├── frontend/          # next.js 14
├── backend/           # spring boot 3.3
│   └── src/main/java/com/cache/config/   # singleton db connectors
├── scripts/
│   ├── setup.sh
│   ├── start.sh
│   ├── seed.sh
│   ├── reset.sh
│   └── wait-healthy.sh
├── docker-compose.yml
└── .env.example
```
