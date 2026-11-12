# opencode-ollama-embedded

[![CI](https://github.com/<owner>/<repo>/actions/workflows/ci.yml/badge.svg)](https://github.com/<owner>/<repo>/actions/workflows/ci.yml)

A TypeScript project that embeds the **OpenCode SDK** with **Ollama** running in
**Docker Desktop** (VM memory > 3 GiB). For development, this repository provides
instructions, custom agents, and **GitHub Copilot** prompts in `.github/`.

## Prerequisites
- Docker Desktop (Compose v2), VM memory **> 3 GiB** (6-8 GiB recommended)
- Node.js >= 20 (optional when using the dev container)
- Git

## Quick start (fresh machine)
```bash
git clone <this-repo> && cd opencode-ollama-embedded
./scripts/bootstrap.sh      # check memory, create .env, start Ollama, pull model
npm install
npm run doctor              # verify Ollama + model
npm run ask -- "Write a TypeScript function to validate email"
```

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
The OpenCode SDK and CLI are pinned to a compatible version, 1.19.5. The CLI is
installed as a project dependency so that `npm run ask` does not accidentally
use a different global version; the app image uses the same local CLI.
