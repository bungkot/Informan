import { createOpencode } from "@opencode-ai/sdk";
import { config } from "./config.js";

/**
 * Starts the OpenCode server (requires the "opencode" CLI on PATH) and returns
 * a typed client. The Ollama provider configuration is passed inline so the
 * application does not depend on a config file on the host machine.
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
