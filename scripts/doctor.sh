#!/usr/bin/env bash
# Diagnostik cepat tanpa Node. Pakai: ./scripts/doctor.sh
set -uo pipefail
cd "$(dirname "$0")/.."
[ -f .env ] && set -a && . ./.env && set +a
MODEL="${OLLAMA_MODEL:-qwen2.5-coder:3b}"
ok()   { echo "  [OK]   $*"; }
fail() { echo "  [FAIL] $*"; }

echo "Docker:"
if docker info >/dev/null 2>&1; then
  ok "daemon berjalan, memori $(( $(docker info --format '{{.MemTotal}}') / 1024 / 1024 )) MiB"
else
  fail "daemon tidak berjalan"; exit 1
fi

echo "Ollama:"
if curl -fsS http://127.0.0.1:11434/api/tags >/tmp/tags.json 2>/dev/null; then
  ok "API merespons di 127.0.0.1:11434"
  if grep -q "\"$MODEL\"" /tmp/tags.json; then ok "model $MODEL tersedia"; else fail "model $MODEL belum ditarik"; fi
else
  fail "API tidak merespons (docker compose up -d?)"
fi

echo "OpenCode CLI:"
if command -v opencode >/dev/null 2>&1; then ok "$(opencode --version 2>/dev/null)"; else fail "belum terpasang di host (opsional; ada di container dev)"; fi
