# opencode-ollama-embedded

Proyek TypeScript yang menanamkan **OpenCode SDK** dengan **Ollama** yang berjalan
di **Docker Desktop** (memori VM > 3 GiB). Untuk pengembangan, repository ini
menyediakan instruksi, custom agent, dan prompt **GitHub Copilot** di `.github/`.

## Prasyarat
- Docker Desktop (Compose v2), memori VM **> 3 GiB** (disarankan 6-8 GiB)
- Node.js >= 20 (opsional jika memakai container dev)
- Git

## Mulai cepat (mesin baru)
```bash
git clone <repo-ini> && cd opencode-ollama-embedded
./scripts/bootstrap.sh      # cek memori, buat .env, jalankan Ollama, tarik model
npm install
npm run doctor              # verifikasi Ollama + model
npm run ask -- "Buat fungsi TypeScript untuk validasi email"
```

Tanpa Node di host:
```bash
docker compose --profile app run --rm --build app ask "Halo"
```

## Mode pengembangan
| Mode | Perintah |
|---|---|
| Di host (Node + Ollama di Docker) | `npm run dev -- doctor` |
| Container dev | `npm run stack:dev` lalu `docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bash` |
| VS Code Dev Containers | "Reopen in Container" |

Di VS Code, GitHub Copilot membaca `.github/copilot-instructions.md`.
Custom agents tersedia di `.github/agents/` dan prompt proyek di
`.github/prompts/`; lihat [dokumentasi harness](docs/copilot-harness.md).

## Dokumentasi
- [Arsitektur](docs/architecture.md)
- [Setup di mesin lain](docs/setup-other-machine.md)
- [Harness GitHub Copilot](docs/copilot-harness.md)
- [Ukuran model dan memori](docs/memory-sizing.md)
- [Troubleshooting](docs/troubleshooting.md)

## Status verifikasi
SDK dan CLI OpenCode dipatok ke versi 1.19.5 yang kompatibel. CLI dipasang
sebagai dependency proyek agar `npm run ask` tidak tanpa sengaja memakai versi
global yang berbeda; image app memakai CLI lokal yang sama.
