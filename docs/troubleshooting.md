# Troubleshooting

| Gejala | Penyebab umum | Solusi |
|---|---|---|
| `bootstrap.sh`: memori <= 3 GiB | Batas Docker Desktop | Settings > Resources > Memory |
| `Ollama tidak merespons` | Stack belum jalan | `docker compose up -d`, cek `docker compose logs ollama` |
| `Model ... belum ada` | Model belum ditarik | `docker compose exec ollama ollama pull <model>` |
| `Timeout waiting for server to start` | Versi CLI global tidak cocok dengan SDK | Jalankan lewat `npm run ask` agar memakai CLI proyek; di Docker, build ulang image app |
| Connection refused ke `localhost:11434` dari container | Salah host | Di container pakai `http://ollama:11434/v1` |
| Port 4096 dipakai | Server OpenCode lain aktif | Set `OPENCODE_PORT` |
| Respons menggantung | Proxy memblokir SSE, atau model terlalu lambat | Akses Ollama langsung tanpa proxy; cek `docker stats` |
| Agent salah memanggil tool | Model terlalu kecil | Pakai `qwen2.5-coder:7b` |
| `OOMKilled` | RAM kurang | Lihat `memory-sizing.md` |
| `git: dubious ownership` di container | UID mount berbeda | Sudah ditangani via `safe.directory` di Dockerfile |
