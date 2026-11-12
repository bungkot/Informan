/** Konfigurasi terpusat, dibaca dari environment. */
export const config = {
  /** Endpoint OpenAI-compatible milik Ollama (berakhiran /v1). */
  ollamaBaseUrl: process.env.OLLAMA_BASE_URL ?? "http://localhost:11434/v1",
  /** Nama model Ollama, mis. qwen2.5-coder:3b */
  model: process.env.OLLAMA_MODEL ?? "qwen2.5-coder:3b",
  opencodeHost: process.env.OPENCODE_HOST ?? "127.0.0.1",
  opencodePort: Number(process.env.OPENCODE_PORT ?? 4096),
} as const;

/** Root Ollama tanpa suffix /v1, untuk API native (/api/tags). */
export function ollamaRoot(): string {
  return config.ollamaBaseUrl.replace(/\/v1\/?$/, "");
}
