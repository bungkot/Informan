# GitHub Copilot harness

The Copilot configuration lives in the repository so it applies consistently in
VS Code and gets cloned along with the code. This harness only shapes the
development experience; the application itself uses the OpenCode SDK to talk to
Ollama.

| Location | Purpose |
|---|---|
| `.github/copilot-instructions.md` | Project rules applied automatically in Copilot chat |
| `.github/agents/architect.agent.md` | Read-only custom agent for planning |
| `.github/agents/reviewer.agent.md` | Read-only custom agent for reviewing changes |
| `.github/prompts/verify.prompt.md` | `/verify`: typecheck, build, and fixes |
| `.github/prompts/doctor.prompt.md` | `/doctor`: Docker/Ollama diagnosis |
| `.github/prompts/docs-sync.prompt.md` | `/docs-sync`: keep documentation in sync with configuration |
| `.github/prompts/review.prompt.md` | `/review`: review changes using the reviewer |

## Usage
1. Open the repository in VS Code with GitHub Copilot active.
2. Project rules are loaded automatically from `.github/copilot-instructions.md`.
3. Pick a custom agent via the agent picker, or run a prompt with `/` and choose
   `verify`, `doctor`, `docs-sync`, or `review`.

The main instructions keep TypeScript strict, enforce ESM imports with the `.js`
suffix, centralized environment configuration, and Docker/Git safety guardrails.
The `/verify` prompt runs `npm run typecheck` and `npm run build`; `/doctor`
runs `npm run doctor`.

## Adding customization
- Add cross-project rules in `.github/copilot-instructions.md`.
- Add single-focus personas as `.agent.md` files in `.github/agents/`.
- Add user-invoked task flows as `.prompt.md` files in `.github/prompts/`.

Use custom agents for different roles/access levels and prompts for a single
repeated task. Validate the YAML frontmatter and make sure the agent description
explains when that agent should be used.
