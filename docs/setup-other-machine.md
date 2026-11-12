# Setup on another machine

## 1. Prepare Docker Desktop
Settings > Resources > Memory: **at minimum > 3 GiB, 6-8 GiB recommended**, then
Apply & Restart.
Linux without Docker Desktop: memory follows host RAM; set `OLLAMA_MEM_LIMIT`.

## 2. Get the code and bootstrap
```bash
git clone <repo> && cd opencode-ollama-embedded
./scripts/bootstrap.sh
```
The script refuses to continue if Docker memory is <= 3 GiB, creates `.env`,
starts the stack, and waits for the model pull to finish.

## 3. Choose how to develop
**A. On host:** `npm install && npm run doctor`

**B. Dev container:**
```bash
npm run stack:dev
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bash
npm install && npm run doctor
```

**C. VS Code:** open the folder, "Dev Containers: Reopen in Container".

## 4. GitHub Copilot in VS Code
Open the repository in VS Code with GitHub Copilot active. Project instructions
are loaded from `.github/copilot-instructions.md`; custom agents live in
`.github/agents/`, and ready-to-use prompts are in `.github/prompts/`.
See the [harness documentation](./copilot-harness.md).

`npm run ask` still runs the OpenCode SDK application with the CLI pinned as a
project dependency; a global CLI is not required.

## 5. Change the model
Edit `OLLAMA_MODEL` in `.env`, then run `docker compose up -d`. The application
uses that model for SDK requests.

## Air-gapped machines (no internet)
On an internet-connected machine: `docker save ollama/ollama` and copy the model
volume (`docker run --rm -v ollama:/d -v $PWD:/o alpine tar czf /o/ollama.tgz -C /d .`).
On the target machine: `docker load`, create the `ollama` volume, extract the archive.
