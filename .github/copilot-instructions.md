# Project instructions

This TypeScript (ESM, Node >= 20) application embeds the OpenCode SDK and
connects to Ollama in Docker Desktop. Project documentation is in `docs/`.

## Structure
- `src/config.ts`: centralized environment-based configuration.
- `src/health.ts`: Ollama readiness and model checks.
- `src/opencode.ts`: OpenCode SDK server/client setup with inline Ollama provider.
- `src/index.ts`: `doctor` and `ask "<prompt>"` CLI commands.
- `docker-compose.yml`, `docker-compose.dev.yml`, `Dockerfile`: container setup.
- `.github/agents/` and `.github/prompts/`: GitHub Copilot customizations.

## Commands
- Typecheck: `npm run typecheck`
- Build: `npm run build`
- Diagnose: `npm run doctor`
- Start stack: `npm run stack:up`

## Rules
1. Keep changes focused and preserve existing behavior.
2. Keep TypeScript strict; do not use `any`.
3. Use ESM. Relative TypeScript imports must end in `.js`.
4. Read environment variables only through `src/config.ts`.
5. Inside Docker, Ollama is `http://ollama:11434/v1`, not `localhost`.
6. Never hardcode secrets or commit `.env`.
7. Run `npm run typecheck` after code changes and fix introduced errors.
8. If environment variables, ports, or services change, update `.env.example`,
   Compose files, and the matching documentation in the same change.
9. Never run `git push`, `docker system prune`, or delete Docker volumes without
   explicit user approval.

## Small-model guidance
- The default Ollama model is 3B; keep prompts and tool workflows focused.
- Read a file before editing it and prefer precise, minimal changes.
- If a tool call fails twice, stop and report the blocker instead of guessing.
