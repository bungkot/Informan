# Troubleshooting

| Symptom | Common cause | Fix |
|---|---|---|
| `bootstrap.sh`: memory <= 3 GiB | Docker Desktop limit | Settings > Resources > Memory |
| `Ollama is not responding` | Stack not running | `docker compose up -d`, check `docker compose logs ollama` |
| `Model ... is not available` | Model not pulled | `docker compose exec ollama ollama pull <model>` |
| `Timeout waiting for server to start` | Global CLI version mismatches the SDK | Run via `npm run ask` to use the project CLI; in Docker, rebuild the app image |
| Connection refused to `localhost:11434` from a container | Wrong host | Inside containers use `http://ollama:11434/v1` |
| Port 4096 in use | Another OpenCode server is running | Set `OPENCODE_PORT` |
| Response hangs | Proxy blocking SSE, or model too slow | Access Ollama directly without a proxy; check `docker stats` |
| Agent calls tools incorrectly | Model too small | Use `qwen3.5:4b` or larger |
| `OOMKilled` | Not enough RAM | See `memory-sizing.md` |
| `git: dubious ownership` in the container | Different mount UID | Already handled via `safe.directory` in the Dockerfile |
