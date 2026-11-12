import { createOpencode } from "@opencode-ai/sdk";
import { config } from "./config.js";

/**
 * Menjalankan server OpenCode (butuh CLI "opencode" di PATH) dan mengembalikan
 * klien bertipe. Konfigurasi provider Ollama diberikan inline sehingga
 * aplikasi tidak bergantung pada file config di mesin host.
 */
export async function startOpencode() {
  return createOpencode({
    hostname: config.opencodeHost,
    port: config.opencodePort,
    timeout: 30_000,
    config: {
      model: `ollama/${config.model}`,
      provider: {
        ollama: {
          npm: "@ai-sdk/openai-compatible",
          name: "Ollama (Docker)",
          options: { baseURL: config.ollamaBaseUrl },
          models: {
            [config.model]: { name: config.model },
          },
        },
      },
      agent: {
        ask: {
          model: `ollama/${config.model}`,
          mode: "primary",
          prompt: "Answer the user directly and concisely. Do not use tools.",
          tools: { "*": false },
        },
      },
    },
  });
}
