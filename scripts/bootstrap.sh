#!/usr/bin/env bash
# Set up the project on a new machine: check prerequisites, create .env, start the stack, pull the model.
set -euo pipefail
cd "$(dirname "$0")/.."

need() { command -v "$1" >/dev/null 2>&1 || { echo "ERROR: '$1' not found."; exit 1; }; }
need docker
docker compose version >/dev/null 2>&1 || { echo "ERROR: Docker Compose v2 not found."; exit 1; }
docker info >/dev/null 2>&1 || { echo "ERROR: Docker daemon is not running. Open Docker Desktop."; exit 1; }

# --- check Docker VM memory (requirement: > 3 GiB)
mem_bytes=$(docker info --format '{{.MemTotal}}')
mem_mib=$(( mem_bytes / 1024 / 1024 ))
echo "Docker memory : ${mem_mib} MiB"
if [ "$mem_mib" -le 3072 ]; then
  echo "ERROR: Docker Desktop memory <= 3 GiB. Increase it in Settings > Resources > Memory (6-8 GiB recommended)."
  exit 1
elif [ "$mem_mib" -lt 5120 ]; then
  echo "WARNING: < 5 GiB. Use a small model (qwen3.5:2b-q4_K_M) and OLLAMA_MEM_LIMIT=3g."
fi

[ -f .env ] || { cp .env.example .env; echo "Created .env from .env.example"; }
if [ -f .env ]; then set -a; . ./.env; set +a; fi
MODEL="${OLLAMA_MODEL:-qwen3.5:2b-q4_K_M}"

echo "Starting stack..."
docker compose up -d

echo "Waiting for Ollama to be ready..."
for _ in $(seq 1 60); do
  if curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then break; fi
  sleep 2
done
if ! curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
  echo "ERROR: Ollama is not responding. See: docker compose logs ollama"; exit 1
fi

echo "Pulling model $MODEL (first download may take a few minutes)..."
docker compose exec -T ollama ollama pull "$MODEL"

echo "Done. Next: npm install && npm run doctor"
