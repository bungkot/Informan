# Informan

[![CI](https://github.com/bungkot/Informan/actions/workflows/ci.yml/badge.svg)](https://github.com/bungkot/Informan/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A TypeScript project that embeds the **OpenCode SDK** with **Ollama** running in
**Docker Desktop** (VM memory > 3 GiB). Ask a local LLM from your terminal with
`npm run ask` — no cloud API keys required.

For development, this repository provides instructions, custom agents, and
**GitHub Copilot** prompts in `.github/`.

## Prerequisites
- Docker Desktop (Compose v2), VM memory **> 3 GiB** (6-8 GiB recommended)
- Node.js >= 20 (optional when using the dev container)
- Git

## Quick start (fresh machine)
```bash
git clone https://github.com/bungkot/Informan.git && cd Informan
./scripts/bootstrap.sh      # check memory, create .env, start Ollama, pull model
npm install
npm run doctor              # verify Ollama + model
npm run ask -- "Write a TypeScript function to validate email"
```

Example session:
```text
$ npm run doctor
Ollama root : http://localhost:11434
Base URL    : http://localhost:11434
Model       : qwen3.5:2b-q4_K_M
Models      : qwen3.5:2b-q4_K_M
OK: Ollama is ready and the model is available.

$ npm run ask -- "Write a TypeScript function to validate email"
Here is a TypeScript function to validate an email address:

export function isValidEmail(email: string): boolean {
  const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return pattern.test(email);
}
```
(Output varies by model; run it on your machine to see the live result.)

Without Node on the host:
```bash
docker compose --profile app run --rm --build app ask "Hello"
```

## Development modes
| Mode | Command |
|---|---|
| On host (Node + Ollama in Docker) | `npm run dev -- doctor` |
| Dev container | `npm run stack:dev` then `docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bash` |
| VS Code Dev Containers | "Reopen in Container" |

In VS Code, GitHub Copilot reads `.github/copilot-instructions.md`.
Custom agents are available in `.github/agents/` and project prompts in
`.github/prompts/`; see the [harness documentation](docs/copilot-harness.md).

## Documentation
- [Architecture](docs/architecture.md)
- [Setup on another machine](docs/setup-other-machine.md)
- [GitHub Copilot harness](docs/copilot-harness.md)
- [Model and memory sizing](docs/memory-sizing.md)
- [Troubleshooting](docs/troubleshooting.md)

## Verification status
- **Pinned toolchain**: the OpenCode SDK and CLI are pinned to a compatible
  version, 1.19.5. The CLI is installed as a project dependency so that
  `npm run ask` does not accidentally use a different global version; the app
  image uses the same local CLI.
- **Tested models** (Q4 quantization, 8192 context — estimates from
  [memory sizing](docs/memory-sizing.md); measure on your own with `docker stats`):

  | Model | Estimated RAM | Docker VM minimum | Notes |
  |---|---|---|---|
  | `qwen3.5:2b-q4_K_M` | 2-3 GiB | 3-4 GiB | Default; native tool calling + thinking |
  | `qwen3.5:0.8b` | 1-2 GiB | 3 GiB | Fallback for very tight memory |
  | `qwen3.5:4b` | 4-5 GiB | 6 GiB | Does not fit within the 3g cap |
  | `qwen3.5:9b` | 7-8 GiB | 9 GiB | Needs a much larger Docker VM |

- **Memory guardrails**: the default stack is capped at 3 GiB — Ollama
  `mem_limit=2g` (the model fits inside it) + dev/app `mem_limit=1g`.
  `npm run doctor` verifies Ollama health and model availability before use.

## License
[MIT](LICENSE)
