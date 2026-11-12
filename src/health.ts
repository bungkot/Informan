import { config, ollamaRoot } from "./config.js";

const sleep = (ms: number) => new Promise<void>((r) => setTimeout(r, ms));

export async function listModels(): Promise<string[]> {
  const res = await fetch(`${ollamaRoot()}/api/tags`, {
    signal: AbortSignal.timeout(5_000),
  });
  if (!res.ok) throw new Error(`Ollama /api/tags -> HTTP ${res.status}`);
  const body = (await res.json()) as { models?: { name: string }[] };
  return (body.models ?? []).map((m) => m.name);
}

export async function waitForOllama(timeoutMs = 120_000): Promise<void> {
  const deadline = Date.now() + timeoutMs;
  let last: unknown;
  while (Date.now() < deadline) {
    try {
      await listModels();
      return;
    } catch (err) {
      last = err;
      await sleep(2_000);
    }
  }
  throw new Error(
    `Ollama tidak merespons di ${ollamaRoot()} dalam ${timeoutMs / 1000}s. ` +
      `Jalankan "docker compose up -d". Detail: ${String(last)}`,
  );
}

export async function ensureModel(): Promise<void> {
  const models = await listModels();
  const wanted = config.model.includes(":") ? config.model : `${config.model}:latest`;
  if (!models.includes(wanted)) {
    throw new Error(
      `Model "${wanted}" belum ada di Ollama. Tersedia: [${models.join(", ")}]. ` +
        `Tarik dengan: docker compose exec ollama ollama pull ${wanted}`,
    );
  }
}
