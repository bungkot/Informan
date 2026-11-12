# Arsitektur

```
Host (laptop/server)
└─ Docker Desktop VM  (memori > 3 GiB)
   ├─ ollama        :11434  volume "ollama" (model persisten)
   ├─ app           Node + opencode CLI + SDK   (profile "app")
   └─ dev           Node + opencode CLI, kode di-mount (override dev)
```

## Alur permintaan
1. `src/index.ts` memanggil `waitForOllama()` dan `ensureModel()` (fail-fast dengan pesan jelas).
2. `startOpencode()` menjalankan server OpenCode lokal (port 4096) lewat `createOpencode()`;
   konfigurasi provider Ollama diberikan inline.
3. `client.session.create()` lalu `client.session.prompt()` memakai agent `ask`
   tanpa tools, supaya prompt awal tetap ringan untuk model kecil.
4. OpenCode memanggil `http://ollama:11434/v1` (OpenAI-compatible) dan mengembalikan hasil.

## Keputusan desain
| Keputusan | Alasan |
|---|---|
| Provider `@ai-sdk/openai-compatible` | Cara standar OpenCode memakai Ollama |
| Config provider inline di SDK | Aplikasi mandiri dan tidak bergantung pada konfigurasi CLI host |
| Versi SDK dan CLI dipatok bersama | Mencegah ketidakcocokan protokol server |
| Port Ollama hanya `127.0.0.1` | Mencegah akses dari jaringan |
| `OLLAMA_NUM_PARALLEL=1`, `MAX_LOADED_MODELS=1` | Hemat RAM |
| `mem_limit` pada container | Mencegah OOM menjatuhkan seluruh VM Docker |
| Konteks 8192 (`OLLAMA_CONTEXT_LENGTH`) | Agent mengirim prompt panjang, tapi RAM Ollama dibatasi 2g |
| Multi-stage Dockerfile (dev/build/runtime) | Image runtime kecil, dev lengkap |

## Batasan
- Tanpa GPU, inferensi lambat (terutama model 7B).
- Model <= 3B sering gagal pada tool-calling; gunakan untuk PoC.
- Jangan menaruh Ollama di balik reverse proxy yang tidak mendukung SSE
  (streaming bisa menggantung).
