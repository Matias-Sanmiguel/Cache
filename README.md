# caché

> Red social de vida nocturna con **arquitectura políglota** — cada motor de datos modela lo que mejor sabe hacer.

<p>
  <img alt="Next.js" src="https://img.shields.io/badge/Next.js-14-black?logo=next.js">
  <img alt="Spring Boot" src="https://img.shields.io/badge/Spring%20Boot-3.3-6DB33F?logo=springboot&logoColor=white">
  <img alt="Java" src="https://img.shields.io/badge/Java-21-007396?logo=openjdk&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-compose-2496ED?logo=docker&logoColor=white">
</p>

---

## Tabla de contenidos

- [Arquitectura](#arquitectura)
- [Stack](#stack)
- [Requisitos](#requisitos)
- [Quickstart](#quickstart)
- [Dos formas de correr el backend](#dos-formas-de-correr-el-backend)
  - [Forma A — todo en Docker](#forma-a--todo-en-docker)
  - [Forma B — backend local con Maven](#forma-b--backend-local-con-maven)
- [Frontend en modo desarrollo](#frontend-en-modo-desarrollo)
- [Datos de prueba](#datos-de-prueba)
- [URLs y puertos](#urls-y-puertos)
- [API](#api)
- [Scripts](#scripts)
- [Estructura del repo](#estructura-del-repo)
- [Troubleshooting](#troubleshooting)

---

## Arquitectura

Cada motor se eligió por su fortaleza específica, no por uniformidad. El backend (Spring Boot) los orquesta a todos.

| Motor | Versión | Rol en la app | Puerto(s) |
|---|---|---|---|
| **MongoDB** | 7 | Catálogo e identidad (`events`, `venues`, `users`) | `27017` |
| **Neo4j** | 5 | Grafo social y recomendaciones | `7687` / `7474` |
| **Redis** | 7 | Presencia en tiempo real, sesiones, contadores, pub/sub | `6379` |
| **Cassandra** | 4.1 | Historial de check-ins, tendencias, métricas del dashboard | `9042` |
| **Kafka** | 3.9 | Broker — ingesta async de clima (Open-Meteo) | `9092` |

> Diagramas en [diagramas/](diagramas/) · esquema de datos completo en [database/SCHEMA.md](database/SCHEMA.md).

**Flujo del clima:** el job `WeatherJobs` publica al topic `external.weather`; `WeatherConsumer` cachea el resultado en Redis (`weather:current:<ciudad>`).

---

## Stack

- **Frontend** — Next.js 14 (App Router, TypeScript, PWA), Leaflet (mapa), Recharts (dashboard) · [`frontend/`](frontend/)
- **Backend** — Spring Boot 3.3.4, Java 21, Maven · conectores singleton por motor vía `@Bean` · auth JWT (access 15 min / refresh 7 días) · [`backend/`](backend/)
- **Infra** — Docker Compose levanta los 5 motores + backend + frontend + herramientas de admin.

---

## Requisitos

| Herramienta | Versión | Para qué |
|---|---|---|
| Docker + Docker Compose | v2+ | Levantar los 5 motores (+ backend/frontend) |
| Java (JDK) | 21 | Compilar/correr el backend con Maven |
| Maven | 3.9+ | Build del backend |
| Node | 18+ (probado en 20) | Frontend Next.js |

> Java + Maven sólo hacen falta para correr el backend **local** ([Forma B](#forma-b--backend-local-con-maven)). En la [Forma A](#forma-a--todo-en-docker) todo va en Docker.

---

## Quickstart

```bash
# 0. credenciales (una vez)
cp .env.example .env

# 1. levantar TODO en docker (5 motores + backend + frontend)
docker compose up -d
bash scripts/wait-healthy.sh        # cassandra tarda ~90s

# 2. cargar el dataset real (incluye usuarios de prueba)
bash scripts/populate.sh
docker compose restart backend       # recrea índices mongo que mongoimport borró
```

Abrir **http://localhost:3000**.

**Logins de prueba** (todos con password `cache123`):

| Email | Rol |
|---|---|
| `gus@cache.com` | VISITOR |
| `mati@cache.com` | VENUE_OWNER (VEN001) |
| `jule@cache.com` | ADMIN |

---

## Dos formas de correr el backend

El frontend (Next.js) corre igual en ambas con `npm run dev` (o dentro de Docker en la Forma A).

| | Forma A — todo en Docker | Forma B — backend local (Maven) |
|---|---|---|
| Backend corre en | contenedor `cache_backend` | tu máquina (`mvn spring-boot:run`) |
| Frontend corre en | contenedor `cache_frontend` | tu máquina (`npm run dev`) |
| Ideal para | levantar rápido, demo | desarrollar (hot reload) |
| Necesita Java/Maven/Node | no | sí |
| Hosts de DB | nombres de red (`mongodb`, `redis`…) | `localhost` (puertos publicados) |

> ⚠️ **No corras el backend de Docker y el local a la vez** — ambos usan el puerto `8080`. Si corrés local, bajá el contenedor: `docker compose stop backend` (ídem `frontend` en `3000`).

### Forma A — todo en Docker

```bash
cp .env.example .env           # una vez
docker compose up -d           # 5 motores + backend + frontend
bash scripts/wait-healthy.sh   # espera (healthy)
```

El servicio `backend` usa los nombres de la red interna para las DBs y toma `JWT_SECRET`, `MONGO_URI`, etc. del `.env`. **El `.env` debe incluir el bloque `JWT_SECRET`** (≥32 bytes) o el arranque falla.

El servicio `frontend` se sirve en http://localhost:3000. El browser corre fuera de Docker, así que le pega al backend en `localhost:8080` (no al nombre de red). Ese origen se **hornea en el build** vía el arg `NEXT_PUBLIC_API_URL` — si lo cambiás, reconstruí con `--build`.

Verificar:

```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
curl http://localhost:8080/api/dashboard/summary   # backend
curl -I http://localhost:3000                       # frontend
```

Tras tocar código, reconstruir el servicio: `docker compose up -d --build backend` (o `frontend`).

### Forma B — backend local con Maven

Los 5 motores siguen en Docker; sólo el backend corre en tu máquina.

```bash
docker compose up -d cassandra mongodb neo4j redis kafka   # motores, NO el backend
bash scripts/wait-healthy.sh
docker compose stop backend        # por si quedó levantado
```

`mvn spring-boot:run` **no lee `.env`** — hay que exportar las variables primero (cassandra/mongo/redis/jwt no tienen default):

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

<details>
<summary>jar standalone (cwd-independiente — útil para background)</summary>

```bash
cd backend && mvn package -DskipTests
set -a; source ../.env; set +a
java -jar target/cache-backend-0.1.0.jar
```
</details>

Backend listo cuando loguea `Started CacheApplication`. Probar: `curl http://localhost:8080/api/dashboard/summary`.

---

## Frontend en modo desarrollo

En la Forma A ya corre en Docker (`cache_frontend`). Esto es sólo para desarrollar el front con hot reload — bajá el contenedor primero:

```bash
docker compose stop frontend
cd frontend
npm install        # primera vez
npm run dev        # http://localhost:3000
```

> El frontend **debe** correr en `localhost:3000` o `:3001` — son los únicos orígenes en `CORS_ORIGINS`. Si Next agarra otro puerto (3002+), los `fetch` del browser (login, anotarse) fallan por CORS. Liberá el 3000 o agregá el puerto a `CORS_ORIGINS` en `.env` y reiniciá el backend.

`NEXT_PUBLIC_API_URL` (default `http://localhost:8080`) define a dónde pega el front.

---

## Datos de prueba

```bash
bash scripts/populate.sh   # dataset REAL: json export + grafo + analytics cassandra + presencia redis
# o, data mínima inline:
bash scripts/seed.sh
```

`populate.sh` carga ~1000 users, 1000 eventos, 50 venues, ~264k relaciones de grafo, analytics en Cassandra y presencia en Redis con IDs canónicos (`USR###` / `VEN###`).

> ⚠️ `populate.sh` usa `mongoimport --drop`, que **borra los índices de mongo** (incluido el `2dsphere` de `events.location`). El propio script recrea los índices, pero si corrés el backend aparte reinícialo después de poblar para que `IndexInitializer` actúe, sino `/api/events/nearby` da 500.
> - Forma A: `docker compose restart backend`
> - Forma B: reiniciá el proceso `mvn`

---

## URLs y puertos

| Servicio | URL |
|---|---|
| Frontend | http://localhost:3000 |
| Backend API | http://localhost:8080 |
| Neo4j Browser | http://localhost:7474 |
| Mongo Express (admin) | http://localhost:8081 |
| RedisInsight (admin) | http://localhost:5540 |

Las herramientas de admin son opcionales: `docker compose --profile admin up -d`.

---

## API

Base: `http://localhost:8080/api`. Todo lo que no sea `/api/auth/**` (y algunos GET públicos de eventos/venues/weather/dashboard) exige `Authorization: Bearer <token>`.

| Recurso | Endpoints |
|---|---|
| **Auth** `/api/auth` | `POST /register` · `POST /login` · `POST /refresh` · `POST /logout` |
| **Users** `/api/users` | `GET /me` · `PUT /me` · `DELETE /me` · `GET /{id}` · `GET /search` |
| **Friends** `/api/friends` | `POST /request` · `PUT /request/{id}/accept` · `DELETE /request/{id}` · `DELETE /request/{id}/cancel` · `GET /requests` · `GET /requests/sent` · `DELETE /{id}` |
| **Events** `/api/events` | `GET /feed` · `GET /live` · `GET /nearby` · `GET /search` · `GET /mine` · `GET /{id}` · `PUT /{id}` · `DELETE /{id}` |
| **Venues** `/api/venues` | `GET /nearby` · `GET /{venueId}` · `GET /{venueId}/trends` · `GET /{venueId}/presence` |
| **Check-in** `/api/checkin` | `POST /` · `DELETE /{eventId}` · `GET /{eventId}/status` · `GET /history` |
| **Recommendations** `/api` | `GET /recommendations/events` · `/people` · `/venues` · `/popular` · `GET /events/{id}/friends-attending` |
| **Notifications** `/api/notifications` | `GET /stream` (SSE) · `PUT /read` · `PUT /{id}/read` |
| **Dashboard** `/api/dashboard` | `GET /summary` · `/attendees-by-event` · `/events-by-zone` · `/genres-by-date` · `/checkin-peaks` · `/live-presence` |
| **Weather** `/api/weather` | `GET /` |

> Las notificaciones usan SSE (`/api/notifications/stream`); como `EventSource` no setea headers, el token va por query param (`?token=`).

---

## Scripts

| Script | Qué hace |
|---|---|
| [`scripts/setup.sh`](scripts/setup.sh) | Copia `.env`, instala deps frontend, levanta Docker, espera healthchecks |
| [`scripts/start.sh`](scripts/start.sh) | `docker compose up -d` |
| [`scripts/wait-healthy.sh`](scripts/wait-healthy.sh) | Espera a que los motores estén `(healthy)` |
| [`scripts/populate.sh`](scripts/populate.sh) | Carga el dataset real (json export + grafo + analytics + redis) |
| [`scripts/seed.sh`](scripts/seed.sh) | Data mínima inline |
| [`scripts/reset.sh`](scripts/reset.sh) | Baja todo con volúmenes y vuelve a levantar + seed |

---

## Estructura del repo

```
cache/
├── frontend/                 # next.js 14 (app router, PWA)
│   └── src/
│       ├── app/              # rutas: /, /login, /dashboard, /evento/[id], /mapa, /perfil, /pings
│       ├── components/       # screens, feed, social, mapa…
│       └── lib/api.ts        # cliente del backend
├── backend/                  # spring boot 3.3
│   └── src/main/java/com/cache/
│       ├── api/              # controllers + dto
│       ├── service/          # lógica (orquesta los motores)
│       ├── domain/           # entities/repos por motor (mongo, neo4j, cassandra)
│       ├── job/              # jobs async (clima, transición de estado de eventos)
│       ├── security/         # jwt, filtros, config de seguridad
│       └── config/           # conectores singleton de cada DB
├── database/                 # esquemas + seeds por motor (SCHEMA.md)
├── diagramas/                # diagramas de arquitectura
├── scripts/                  # setup / start / seed / populate / reset
├── docker-compose.yml
└── .env.example
```

---

## Troubleshooting

| Síntoma | Causa / fix |
|---|---|
| Backend (docker) muere con `JWT_SECRET ... blank` / `Failed to instantiate JwtService` | El `.env` no tiene el bloque `JWT_SECRET` (≥32 bytes). Copialo de `.env.example` y `docker compose up -d --build backend` |
| `Conexión rehusada localhost:9042` / `:27017` al arrancar | Los motores no están arriba. `docker compose up -d` + `bash scripts/wait-healthy.sh`. **No es error de compilación** aunque Maven diga BUILD FAILURE en `spring-boot:run` |
| `Could not resolve placeholder 'CASSANDRA_PASSWORD'` al arrancar backend local | No exportaste `.env` antes de `mvn`. Corré `set -a; source .env; set +a` desde la raíz |
| Cassandra `NoNodeAvailableException` / pide datacenter `dc1` | El nodo reporta `datacenter1` (SimpleSnitch ignora `CASSANDRA_DC`). Ya fijado en `application.yml` (`local-datacenter: datacenter1`) |
| Mongo `AuthenticationFailed code 18` | El `MONGO_URI` debe terminar en `?authSource=admin` (el user root vive en la db `admin`) |
| `/api/events/nearby` da 500 / faltan índices | Reiniciá el backend tras `populate.sh` — `IndexInitializer` recrea los índices que `mongoimport --drop` borró |
| Login / botón "anotarme" fallan en el browser (CORS) | El frontend no está en `:3000`/`:3001`. Los GET del dashboard andan (SSR, sin CORS) pero los fetch del browser no. Corré el front en 3000 |
| `BindException: Address already in use` (8080) | Hay un backend viejo. Si es el contenedor: `docker compose stop backend`. Si es un Maven colgado: `lsof -ti :8080` y matalo por PID (no uses `pkill -f spring-boot`) |
| GET nuevo da 403 | Falta `permitAll()` para esa ruta en `SecurityConfig` (todo lo no-`/api/auth/**` exige token) |
| Kafka `bitnami/kafka:3.7: not found` | Usar `apache/kafka:3.9.0` (ya en `docker-compose.yml`) |
