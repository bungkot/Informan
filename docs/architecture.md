# Architecture

```
Host (laptop/server)
└─ Docker Desktop VM  (memory > 3 GiB)
   ├─ ollama        :11434  volume "ollama" (persistent models)
   ├─ app           Node + opencode CLI + SDK   (profile "app")
   └─ dev           Node + opencode CLI, mounted code (dev override)
```

## Request flow
1. `src/index.ts` calls `waitForOllama()` and `ensureModel()` (fail-fast with clear messages).
2. `startOpencode()` runs a local OpenCode server (port 4096) via `createOpencode()`;
   the Ollama provider configuration is passed inline.
3. `client.session.create()` then `client.session.prompt()` uses the `ask` agent
   without tools, keeping the initial prompt light for small models.
4. OpenCode calls `http://ollama:11434/v1` (OpenAI-compatible) and returns the result.

## Design decisions
| Decision | Rationale |
|---|---|
| Provider `@ai-sdk/openai-compatible` | The standard way OpenCode uses Ollama |
| Provider config inline in the SDK | Self-contained app, no dependency on host CLI configuration |
| SDK and CLI versions pinned together | Prevents server protocol mismatches |
| Ollama port bound to `127.0.0.1` only | Prevents access from the network |
| `OLLAMA_NUM_PARALLEL=1`, `MAX_LOADED_MODELS=1` | Saves RAM |
| `mem_limit` on containers | Prevents an OOM from taking down the whole Docker VM |
| Context 8192 (`OLLAMA_CONTEXT_LENGTH`) | Agents send long prompts, but Ollama RAM is capped at 2g |
| Multi-stage Dockerfile (dev/build/runtime) | Small runtime image, full-featured dev image |

## Limitations
- Without a GPU, inference is slow (especially for 7B models).
- Models <= 3B often fail at tool-calling; use them for PoC.
- Do not place Ollama behind a reverse proxy that does not support SSE
  (streaming can hang).
