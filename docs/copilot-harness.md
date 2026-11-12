# GitHub Copilot harness

Konfigurasi Copilot berada di repository agar berlaku konsisten di VS Code dan
ikut ter-clone bersama kode. Harness ini hanya mengatur pengalaman
pengembangan; aplikasi tetap memakai OpenCode SDK untuk berkomunikasi dengan
Ollama.

| Lokasi | Fungsi |
|---|---|
| `.github/copilot-instructions.md` | Aturan proyek yang otomatis berlaku di chat Copilot |
| `.github/agents/architect.agent.md` | Custom agent read-only untuk perencanaan |
| `.github/agents/reviewer.agent.md` | Custom agent read-only untuk meninjau perubahan |
| `.github/prompts/verify.prompt.md` | `/verify`: typecheck, build, dan perbaikan |
| `.github/prompts/doctor.prompt.md` | `/doctor`: diagnosis Docker/Ollama |
| `.github/prompts/docs-sync.prompt.md` | `/docs-sync`: sinkronkan dokumentasi dengan konfigurasi |
| `.github/prompts/review.prompt.md` | `/review`: tinjau perubahan menggunakan reviewer |

## Menggunakan
1. Buka repository di VS Code dengan GitHub Copilot aktif.
2. Aturan proyek dimuat otomatis dari `.github/copilot-instructions.md`.
3. Pilih custom agent melalui agent picker, atau jalankan prompt dengan `/`
   lalu pilih `verify`, `doctor`, `docs-sync`, atau `review`.

Instruksi utama menjaga TypeScript strict, import ESM dengan suffix `.js`,
konfigurasi environment terpusat, dan batasan keselamatan Docker/Git. Prompt
`/verify` menjalankan `npm run typecheck` dan `npm run build`; `/doctor`
menjalankan `npm run doctor`.

## Menambah customization
- Tambahkan aturan lintas proyek di `.github/copilot-instructions.md`.
- Tambahkan persona dengan fokus tunggal sebagai `.agent.md` di
  `.github/agents/`.
- Tambahkan alur tugas yang dipanggil pengguna sebagai `.prompt.md` di
  `.github/prompts/`.

Gunakan custom agent untuk peran/akses yang berbeda dan prompt untuk satu tugas
berulang. Validasi frontmatter YAML dan pastikan deskripsi agent menjelaskan
kapan agent tersebut digunakan.
