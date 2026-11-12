# Setup di mesin lain

## 1. Siapkan Docker Desktop
Settings > Resources > Memory: **minimal > 3 GiB, disarankan 6-8 GiB**, lalu Apply & Restart.
Linux tanpa Docker Desktop: memori mengikuti RAM host; atur `OLLAMA_MEM_LIMIT`.

## 2. Ambil kode dan bootstrap
```bash
git clone <repo> && cd opencode-ollama-embedded
./scripts/bootstrap.sh
```
Skrip menolak lanjut jika memori Docker <= 3 GiB, membuat `.env`, menjalankan
stack, dan menunggu model selesai ditarik.

## 3. Pilih cara mengembangkan
**A. Di host:** `npm install && npm run doctor`

**B. Container dev:**
```bash
npm run stack:dev
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bash
npm install && npm run doctor
```

**C. VS Code:** buka folder, "Dev Containers: Reopen in Container".

## 4. GitHub Copilot di VS Code
Buka repository di VS Code dengan GitHub Copilot aktif. Instruksi proyek
dimuat dari `.github/copilot-instructions.md`; custom agent ada di
`.github/agents/`, dan prompt siap pakai ada di `.github/prompts/`.
Lihat [dokumentasi harness](./copilot-harness.md).

`npm run ask` tetap menjalankan aplikasi OpenCode SDK dengan CLI yang dipatok
sebagai dependency proyek; CLI global tidak diperlukan.

## 5. Ganti model
Edit `OLLAMA_MODEL` di `.env`, lalu jalankan `docker compose up -d`. Aplikasi
menggunakan model tersebut untuk request SDK.

## Mesin tanpa internet (air-gapped)
Di mesin berinternet: `docker save ollama/ollama` dan salin volume model
(`docker run --rm -v ollama:/d -v $PWD:/o alpine tar czf /o/ollama.tgz -C /d .`).
Di mesin tujuan: `docker load`, buat volume `ollama`, ekstrak arsipnya.
