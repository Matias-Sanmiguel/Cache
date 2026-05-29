#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -f "$ROOT_DIR/.env" ]; then
  echo "error: .env no encontrado — corré scripts/setup.sh primero"
  exit 1
fi

(cd "$ROOT_DIR" && docker compose up -d)

echo "→ servicios corriendo:"
echo "   neo4j browser:  http://localhost:7474"
echo "   mongodb:        localhost:27017"
echo "   redis:          localhost:6379"
echo "   cassandra:      localhost:9042"
echo ""
echo "→ herramientas admin (docker compose --profile admin up -d):"
echo "   mongo express:  http://localhost:8081"
echo "   redisinsight:   http://localhost:5540"
