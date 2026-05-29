#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "→ copiando .env.example a .env"
if [ ! -f "$ROOT_DIR/.env" ]; then
  cp "$ROOT_DIR/.env.example" "$ROOT_DIR/.env"
  echo "  .env creado — revisá las credenciales antes de continuar en producción"
else
  echo "  .env ya existe, se omite"
fi

echo "→ instalando dependencias frontend"
if command -v pnpm &>/dev/null; then
  (cd "$ROOT_DIR/frontend" && pnpm install)
elif command -v npm &>/dev/null; then
  (cd "$ROOT_DIR/frontend" && npm install)
else
  echo "  error: npm o pnpm requerido"
  exit 1
fi

echo "→ levantando servicios docker"
(cd "$ROOT_DIR" && docker compose up -d)

echo "→ esperando healthchecks"
"$ROOT_DIR/scripts/wait-healthy.sh"

echo "✓ setup completo — corré scripts/seed.sh para cargar datos de prueba"
