#!/usr/bin/env bash
# Menyiapkan proyek di mesin baru: cek prasyarat, buat .env, jalankan stack, tarik model.
set -euo pipefail
cd "$(dirname "$0")/.."

need() { command -v "$1" >/dev/null 2>&1 || { echo "ERROR: '$1' tidak ditemukan."; exit 1; }; }
need docker
docker compose version >/dev/null 2>&1 || { echo "ERROR: Docker Compose v2 tidak ditemukan."; exit 1; }
docker info >/dev/null 2>&1 || { echo "ERROR: Docker daemon tidak berjalan. Buka Docker Desktop."; exit 1; }

# --- cek memori VM Docker (syarat: > 3 GiB)
mem_bytes=$(docker info --format '{{.MemTotal}}')
mem_mib=$(( mem_bytes / 1024 / 1024 ))
echo "Memori Docker : ${mem_mib} MiB"
if [ "$mem_mib" -le 3072 ]; then
  echo "ERROR: Memori Docker Desktop <= 3 GiB. Naikkan di Settings > Resources > Memory (disarankan 6-8 GiB)."
  exit 1
elif [ "$mem_mib" -lt 5120 ]; then
  echo "PERINGATAN: < 5 GiB. Gunakan model kecil (qwen2.5-coder:3b) dan OLLAMA_MEM_LIMIT=3g."
fi

[ -f .env ] || { cp .env.example .env; echo "Dibuat .env dari .env.example"; }
if [ -f .env ]; then set -a; . ./.env; set +a; fi
MODEL="${OLLAMA_MODEL:-qwen2.5-coder:3b}"

echo "Menjalankan stack..."
docker compose up -d

echo "Menunggu Ollama siap..."
for _ in $(seq 1 60); do
  if curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then break; fi
  sleep 2
done
if ! curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
  echo "ERROR: Ollama tidak merespons. Lihat: docker compose logs ollama"; exit 1
fi

echo "Menarik model $MODEL (unduhan pertama bisa beberapa menit)..."
docker compose exec -T ollama ollama pull "$MODEL"

echo "Selesai. Lanjut: npm install && npm run doctor"
