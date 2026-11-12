---
name: Doctor
description: "Diagnose Docker, Ollama readiness, and configured model availability without changing files."
agent: agent
---
Run `npm run doctor` and inspect Docker Compose status or logs only as needed to
explain a failure. Do not change files, containers, images, or volumes.
Summarize each failing check and provide the exact safe command that can resolve
it. Additional scope: ${input:scope:Optional scope or constraints}
