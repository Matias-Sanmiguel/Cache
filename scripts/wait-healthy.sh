#!/usr/bin/env bash
set -euo pipefail

SERVICES=("cache_neo4j" "cache_redis" "cache_mongo" "cache_cassandra")
MAX_WAIT=180
INTERVAL=5

wait_for_service() {
  local name="$1"
  local elapsed=0
  echo -n "  esperando $name"
  while true; do
    status=$(docker inspect --format='{{.State.Health.Status}}' "$name" 2>/dev/null || echo "missing")
    if [ "$status" = "healthy" ]; then
      echo " ✓"
      return 0
    fi
    if [ "$elapsed" -ge "$MAX_WAIT" ]; then
      echo " ✗ timeout"
      return 1
    fi
    echo -n "."
    sleep "$INTERVAL"
    elapsed=$((elapsed + INTERVAL))
  done
}

for svc in "${SERVICES[@]}"; do
  wait_for_service "$svc"
done
