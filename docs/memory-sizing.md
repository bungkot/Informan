# Model and memory sizing

The numbers below are **rough estimates** (Q4 quantization, 8192 context).
Measure on your own with `docker stats`.

| Model | Estimated RAM | Docker VM minimum | Notes |
|---|---|---|---|
| `qwen3.5:0.8b` | 1-2 GiB | 3 GiB | Fallback for very tight memory |
| `qwen3.5:2b-q4_K_M` | 2-3 GiB | 3-4 GiB | Default; ~1.9 GB on disk, native tool calling + thinking |
| `qwen3.5:4b` | 4-5 GiB | 6 GiB | Does not fit within the 3g cap |
| `qwen3.5:9b` | 7-8 GiB | 9 GiB | Needs a much larger Docker VM |

The default configuration caps the total stack at **3g**: Ollama `mem_limit=2g`
(the model fits inside it) + dev/app `mem_limit=1g`.

## How to reduce usage
- Lower `OLLAMA_CONTEXT_LENGTH` from the default 8192 (e.g. 4096) if RAM is tight.
- Keep `OLLAMA_NUM_PARALLEL=1` and `OLLAMA_MAX_LOADED_MODELS=1`.
- `OLLAMA_FLASH_ATTENTION=1` + `OLLAMA_KV_CACHE_TYPE=q8_0` trims the KV cache by ~75%.
- `OLLAMA_KEEP_ALIVE=5m` so the model is unloaded quickly when idle.
- Set `OLLAMA_MEM_LIMIT` smaller than the VM memory (leave >= 1 GiB for dev/app and Docker).

## Signs of memory exhaustion
The `ollama` container restarts on its own, or `docker inspect ollama` shows
`OOMKilled: true`. Fixes: a smaller model, a shorter context, or more VM memory.
