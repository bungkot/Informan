---
name: Docs sync
description: "Check and update documentation to match environment variables, Compose services, scripts, and application behavior."
agent: agent
---
Compare `.env.example`, `docker-compose.yml`, `docker-compose.dev.yml`,
`package.json` scripts, `README.md`, and relevant files in `docs/`. Identify
outdated or missing documentation for variables, ports, services, commands, and
runtime behavior, then make minimal documentation-only edits. Preserve the
existing Indonesian documentation style. Report the mismatches fixed.
Additional scope: ${input:scope:Optional scope or constraints}
