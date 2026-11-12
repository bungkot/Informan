/** Centralized configuration, read from environment variables. */
export const config = {
  /** Ollama's OpenAI-compatible endpoint (ends with /v1). */
  ollamaBaseUrl: process.env.OLLAMA_BASE_URL ?? "http://localhost:11434/v1",
  /** Ollama model name, e.g. qwen3.5:2b-q4_K_M */
  model: process.env.OLLAMA_MODEL ?? "qwen3.5:2b-q4_K_M",
  opencodeHost: process.env.OPENCODE_HOST ?? "127.0.0.1",
  opencodePort: Number(process.env.OPENCODE_PORT ?? 4096),
} as const;

/** Ollama root without the /v1 suffix, for the native API (/api/tags). */
export function ollamaRoot(): string {
  return config.ollamaBaseUrl.replace(/\/v1\/?$/, "");
}
