# caché

red social de vida nocturna. arquitectura políglota — cada motor modela lo que mejor sabe hacer:

| motor | uso | puerto |
|---|---|---|
| mongodb | catálogo e identidad (events, venues, users) | 27017 |
| neo4j | grafo social y recomendaciones | 7687 / 7474 |
| redis | presencia en tiempo real, sesiones, contadores | 6379 |
| cassandra | historial de check-ins, tendencias, métricas del dashboard | 9042 |
| kafka | broker — ingesta async de clima (Open-Meteo) | 9092 |

stack: **next.js 14** · **spring boot 3.3** · **java 21**

esquema de datos completo en [database/SCHEMA.md](database/SCHEMA.md).

---

## requisitos

| herramienta | versión | para qué |
|---|---|---|
| docker + docker compose | v2+ | levantar los 5 motores |
| java (JDK) | 21 | compilar/correr el backend |
| maven | 3.9+ | build del backend |
| node | 18+ (probado 20) | frontend next.js |

---

## quickstart (TL;DR)

```bash
# 1. credenciales + deps frontend + docker arriba
cp .env.example .env
bash scripts/setup.sh

# 2. cargar el dataset real (incluye login de prueba)
bash scripts/populate.sh

# 3. backend (terminal 1) — OJO: exportá .env antes (ver nota)
set -a; source .env; set +a
cd backend && mvn spring-boot:run

# 4. frontend (terminal 2)
cd frontend && npm run dev   # http://localhost:3000
```

login de prueba: **gus@cache.com** / **cache123**

---

## paso a paso

### 1. configurar entorno

```bash
cp .env.example .env       # editá credenciales si querés
bash scripts/setup.sh      # copia .env, instala deps frontend, levanta docker, espera healthchecks
```

### 2. levantar los motores (si no lo hizo setup)

```bash
bash scripts/start.sh          # docker compose up -d
bash scripts/wait-healthy.sh   # espera a que los 4 motores estén (healthy)
```

verificar:

```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```

los 5 contenedores (`cache_mongo`, `cache_neo4j`, `cache_redis`, `cache_cassandra`, `cache_kafka`) deben estar `Up ... (healthy)`. cassandra tarda ~90s en arrancar.

### 3. cargar datos

```bash
bash scripts/populate.sh   # dataset REAL: export json, grafo completo, analytics cassandra, presencia redis
# o, para data mínima inline:
bash scripts/seed.sh
```

> ⚠️ `populate.sh` usa `mongoimport --drop`, que **borra los índices de mongo** (incluido el `2dsphere` de `events.location`). Reiniciá el backend después de poblar para que `IndexInitializer` los recree, sino `/api/events/nearby` da 500.

### 4. correr el backend (puerto 8080)

`mvn spring-boot:run` **no lee `.env`**. Hay que exportar las variables primero (cassandra/mongo/redis/jwt no tienen default y el arranque falla sin ellas):

```bash
# desde la raíz del repo — bash o zsh
set -a; source .env; set +a
cd backend && mvn spring-boot:run
```

<details>
<summary>shell fish</summary>

```fish
for l in (grep -v '^#' .env | grep '=')
    set kv (string split -m1 = $l)
    set -gx $kv[1] $kv[2]
end
cd backend; and mvn spring-boot:run
```
</details>

alternativa (jar standalone, cwd-independiente — útil para background):

```bash
cd backend && mvn package -DskipTests
set -a; source ../.env; set +a
java -jar target/cache-backend-0.1.0.jar
```

backend listo cuando loguea `Started CacheApplication`. probar: `curl http://localhost:8080/api/dashboard/summary`

### 5. correr el frontend (puerto 3000)

```bash
cd frontend
npm install        # si no corriste setup.sh
npm run dev        # http://localhost:3000
```

> El frontend **debe** correr en `localhost:3000` o `:3001` — son los únicos orígenes en `CORS_ORIGINS`. Si next agarra otro puerto (3002+), los `fetch` del browser (login, anotarse) fallan por CORS. Liberá el 3000 o agregá el puerto a `CORS_ORIGINS` en `.env` y reiniciá el backend.

el `NEXT_PUBLIC_API_URL` (default `http://localhost:8080`) define a dónde pega el front.

---

## URLs y puertos

| servicio | URL |
|---|---|
| frontend | http://localhost:3000 |
| backend API | http://localhost:8080 |
| neo4j browser | http://localhost:7474 |
| mongo express (admin) | http://localhost:8081 |
| redisinsight (admin) | http://localhost:5540 |

herramientas admin (opcionales): `docker compose --profile admin up -d`

---

## scripts

| script | qué hace |
|---|---|
| `scripts/setup.sh` | copia `.env`, instala deps frontend, levanta docker, espera healthchecks |
| `scripts/start.sh` | `docker compose up -d` |
| `scripts/wait-healthy.sh` | espera a que los motores estén `(healthy)` |
| `scripts/populate.sh` | carga el dataset real (json export + grafo + analytics + redis) |
| `scripts/seed.sh` | data mínima inline |
| `scripts/reset.sh` | baja todo con volúmenes y vuelve a levantar + seed |

---

## troubleshooting

| síntoma | causa / fix |
|---|---|
| `Could not resolve placeholder 'CASSANDRA_PASSWORD'` al arrancar backend | no exportaste `.env` antes de `mvn`. Corré `set -a; source .env; set +a` desde la raíz |
| cassandra `NoNodeAvailableException` / pide datacenter `dc1` | el nodo reporta `datacenter1` (SimpleSnitch ignora `CASSANDRA_DC`). Ya fijado en `application.yml` (`local-datacenter: datacenter1`) |
| mongo `AuthenticationFailed code 18` | el `MONGO_URI` debe terminar en `?authSource=admin` (el user root vive en la db `admin`) |
| `/api/events/nearby` da 500 / faltan índices | reiniciá el backend tras `populate.sh` — `IndexInitializer` recrea los índices que `mongoimport --drop` borró |
| login / botón "anotarme" fallan en el browser (CORS) | el frontend no está en `:3000`/`:3001`. Los GET del dashboard andan (SSR, sin CORS) pero los fetch del browser no. Corré el front en 3000 |
| backend no arranca, `BindException: Address already in use` (8080) | hay un backend viejo. Buscalo `lsof -ti :8080` y matalo por PID (no uses `pkill -f spring-boot`) |
| GET nuevo da 403 | falta `permitAll()` para esa ruta en `SecurityConfig` (todo lo no-`/api/auth/**` exige token) |
| kafka `bitnami/kafka:3.7: not found` | usar `apache/kafka:3.9.0` (ya en `docker-compose.yml`) |

---

## estructura

```
cache/
├── frontend/                 # next.js 14 (app router, PWA)
│   └── src/
│       ├── app/              # rutas: /, /login, /dashboard, /evento/[id], /mapa, /perfil, /pings
│       ├── components/screens/
│       └── lib/api.ts        # cliente del backend
├── backend/                  # spring boot 3.3
│   └── src/main/java/com/cache/
│       ├── api/              # controllers + DTOs
│       ├── service/          # lógica (orquesta los 4 motores)
│       ├── domain/           # entities/repos por motor (mongo, neo4j, cassandra)
│       └── config/           # conectores singleton de cada DB
├── database/                 # esquemas + seeds por motor (SCHEMA.md)
├── scripts/                  # setup / start / seed / populate / reset
├── docker-compose.yml
└── .env.example
```
