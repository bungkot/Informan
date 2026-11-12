import { config, ollamaRoot } from "./config.js";
import { ensureModel, listModels, waitForOllama } from "./health.js";
import { startOpencode } from "./opencode.js";

async function doctor(): Promise<void> {
  console.log(`Ollama root : ${ollamaRoot()}`);
  console.log(`Base URL    : ${config.ollamaBaseUrl}`);
  console.log(`Model       : ${config.model}`);
  await waitForOllama(15_000);
  console.log(`Models      : ${(await listModels()).join(", ") || "(kosong)"}`);
  await ensureModel();
  console.log("OK: Ollama siap dan model tersedia.");
}

async function ask(prompt: string): Promise<void> {
  await waitForOllama();
  await ensureModel();

  const { client, server } = await startOpencode();
  try {
    const session = await client.session.create({ body: { title: "ask" } });
    if (!session.data) {
      throw new Error(`Gagal membuat session: ${JSON.stringify(session.error)}`);
    }

    const result = await client.session.prompt({
      path: { id: session.data.id },
      body: {
        model: { providerID: "ollama", modelID: config.model },
        agent: "ask",
        tools: { "*": false },
        parts: [{ type: "text", text: prompt }],
      },
    });
    if (!result.data) {
      throw new Error(`Prompt gagal: ${JSON.stringify(result.error)}`);
    }

    const answer = result.data.parts
      .filter((part) => part.type === "text")
      .map((part) => part.text)
      .join("\n")
      .trim();
    if (!answer) throw new Error("OpenCode mengembalikan respons kosong dari Ollama.");
    console.log(answer);
  } finally {
    server.close();
  }
}

async function main(): Promise<void> {
  const [cmd, ...rest] = process.argv.slice(2);
  switch (cmd) {
    case "doctor":
      return doctor();
    case "ask": {
      const prompt = rest.join(" ").trim();
      if (!prompt) throw new Error('Pemakaian: ask "pertanyaan Anda"');
      return ask(prompt);
    }
    default:
      console.log('Perintah: doctor | ask "<prompt>"');
  }
}

main().catch((err) => {
  console.error(err instanceof Error ? err.message : err);
  process.exit(1);
});
