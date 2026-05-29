#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "→ bajando contenedores y eliminando volúmenes"
(cd "$ROOT_DIR" && docker compose down -v)

echo "→ levantando desde cero"
(cd "$ROOT_DIR" && docker compose up -d)

echo "→ esperando healthchecks"
"$ROOT_DIR/scripts/wait-healthy.sh"

echo "→ cargando seed"
"$ROOT_DIR/scripts/seed.sh"

echo "✓ reset completo"
