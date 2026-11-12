# Ukuran model dan memori

Angka di bawah adalah **perkiraan kasar** (kuantisasi Q4, konteks 8192). Ukur sendiri
dengan `docker stats`.

| Model | RAM perkiraan | VM Docker minimum | Catatan |
|---|---|---|---|
| `qwen2.5-coder:1.5b` | 1-2 GiB | 3 GiB | Paling aman untuk batas 3g |
| `qwen2.5-coder:3b` | 2-3 GiB | 3-4 GiB | Default; mepet di batas 3g |
| `qwen2.5-coder:7b` | 6-7 GiB | 8 GiB | Tidak muat dalam batas 3g |

Konfigurasi bawaan membatasi total stack ke **3g**: Ollama `mem_limit=2g`
(model muat di dalamnya) + dev/app `mem_limit=1g`.

## Cara menurunkan pemakaian
- Turunkan `OLLAMA_CONTEXT_LENGTH` dari default 8192 (mis. 4096) jika RAM mepet.
- Pertahankan `OLLAMA_NUM_PARALLEL=1` dan `OLLAMA_MAX_LOADED_MODELS=1`.
- `OLLAMA_FLASH_ATTENTION=1` + `OLLAMA_KV_CACHE_TYPE=q8_0` memangkas KV cache ~75%.
- `OLLAMA_KEEP_ALIVE=5m` agar model cepat di-unload saat idle.
- Set `OLLAMA_MEM_LIMIT` lebih kecil dari memori VM (sisakan >= 1 GiB untuk dev/app dan Docker).

## Tanda kehabisan memori
Container `ollama` restart sendiri, atau `docker inspect ollama` menunjukkan
`OOMKilled: true`. Solusi: model lebih kecil, konteks lebih pendek, atau naikkan memori VM.
