#!/usr/bin/env bash
set -euo pipefail

# Seed para Redis - Cache
# Genera el estado VOLÁTIL (presencia + contadores) con las MISMAS claves que usa el
# backend en runtime, para que el dashboard y la presencia de amigos muestren datos
# reales apenas se levanta el stack (sin esperar a check-ins en vivo).
#
# Claves canónicas (las que leen PresenceService / DashboardService):
#   presence:<USR###>               -> venueId donde está el user ahora (string, TTL)
#   venue:<VEN###>:present          -> SET de userIds presentes en ese venue
#   event:<mongoObjectId>:attendees -> contador de anotados en vivo (e.getId() = _id de mongo)
#
# IMPORTANTE: los userIds son USR### (los del grafo neo4j y del catálogo mongo), NO u<n>.
# Los venueIds son VEN### (los del catálogo mongo), NO el venue_id numérico de
# venue_mongodb.json. Antes el seed usaba u<n>/venue:<n>/event:e<n> y NADA matcheaba con
# lo que lee el backend -> dashboard.livePresence y attendeesByEvent siempre daban 0.

: "${REDIS_PASSWORD:?REDIS_PASSWORD no esta definido. Carga el .env o exportalo antes de ejecutar.}"

REDIS="docker exec -i cache_redis redis-cli -a $REDIS_PASSWORD --no-auth-warning"

PRESENCE_TTL=28800   # 8h, igual que PresenceService.PRESENCE_TTL

# --- catálogo canónico (alineado con database/mongodb/export/{venues,events}.json) ---
# venue:capacity:eventObjectId:presentCount  (un evento por venue, 1:1)
VENUES=(
  "VEN001:400:6a1c38e3a7db7e77cdd805dd:180"  # Niceto Club  / SUB00.
  "VEN002:600:6a1c38e3a7db7e77cdd805de:240"  # Crobar       / KERNEL
  "VEN003:250:6a1c38e3a7db7e77cdd805df:120"  # Galpon       / HUMEDAL
  "VEN004:800:6a1c38e3a7db7e77cdd805e0:200"  # Amerika      / CLUB BERLIN
  "VEN005:350:6a1c38e3a7db7e77cdd805e1:110"  # Colegiales   / TRESDE
  "VEN006:120:6a1c38e3a7db7e77cdd805e2:50"   # confidencial / CASA PELICANO
)

echo "Seeding Redis (presencia + contadores, claves canónicas)..."

# Limpieza: borra las claves del seed (nuevas Y viejas u<n>/numéricas) sin tocar
# sesiones de login ni caché de clima. --scan + DEL por patrón.
clean_pattern() {
  $REDIS --scan --pattern "$1" | tr -d '\r' | xargs -r -n 100 \
    docker exec -i cache_redis redis-cli -a "$REDIS_PASSWORD" --no-auth-warning DEL >/dev/null
}
clean_pattern "presence:*"
clean_pattern "venue:*:present"
clean_pattern "event:*:attendees"

# Construimos TODOS los SET/SADD en memoria y los mandamos en UN solo pipe a redis-cli
# (lee stdin línea por línea). Mucho más rápido que un docker exec por clave.
build_commands() {
  local uid=1   # USR001, USR002, ... asignado secuencialmente entre venues (sin repetir)
  for entry in "${VENUES[@]}"; do
    IFS=':' read -r venue cap oid count <<< "$entry"

    # contador de anotados del evento (clave por ObjectId = e.getId() en runtime).
    # un número plano es JSON válido → el GenericJackson2JsonRedisSerializer lo lee bien.
    echo "SET event:${oid}:attendees ${count}"

    for ((i = 0; i < count; i++)); do
      local usr
      usr=$(printf 'USR%03d' "$uid")
      # los valores deben ser JSON (el RedisTemplate del backend usa
      # GenericJackson2JsonRedisSerializer): un string va entre comillas → '"USR001"'.
      # Sin las comillas, SMEMBERS/GET revientan con JsonParseException (500).
      echo "SADD venue:${venue}:present '\"${usr}\"'"
      echo "SET presence:${usr} '\"${venue}\"' EX ${PRESENCE_TTL}"
      uid=$((uid + 1))
    done
    echo "EXPIRE venue:${venue}:present ${PRESENCE_TTL}"
  done
  echo "  usuarios presentes: $((uid - 1)) (USR001..$(printf 'USR%03d' $((uid - 1))))" >&2
}

build_commands | $REDIS >/dev/null

echo "✓ Redis seed completo — presencia en VEN001..VEN006, contadores por evento."
