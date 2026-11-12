#!/usr/bin/env bash
# Quick diagnostics without Node. Usage: ./scripts/doctor.sh
set -uo pipefail
cd "$(dirname "$0")/.."
[ -f .env ] && set -a && . ./.env && set +a
MODEL="${OLLAMA_MODEL:-qwen3.5:2b-q4_K_M}"
ok()   { echo "  [OK]   $*"; }
fail() { echo "  [FAIL] $*"; }

echo "Docker:"
if docker info >/dev/null 2>&1; then
  ok "daemon running, memory $(( $(docker info --format '{{.MemTotal}}') / 1024 / 1024 )) MiB"
else
  fail "daemon not running"; exit 1
fi

echo "Ollama:"
if curl -fsS http://127.0.0.1:11434/api/tags >/tmp/tags.json 2>/dev/null; then
  ok "API responding at 127.0.0.1:11434"
  if grep -q "\"$MODEL\"" /tmp/tags.json; then ok "model $MODEL available"; else fail "model $MODEL not pulled yet"; fi
else
  fail "API not responding (docker compose up -d?)"
fi

echo "OpenCode CLI:"
if command -v opencode >/dev/null 2>&1; then ok "$(opencode --version 2>/dev/null)"; else fail "not installed on host (optional; available in the dev container)"; fi
