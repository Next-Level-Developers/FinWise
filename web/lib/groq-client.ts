import { ChatGroq } from "@langchain/groq";

function getEnv(name: string, fallback?: string): string {
  const value = process.env[name] ?? fallback;
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

function normalizeAIContent(content: unknown): string {
  if (typeof content === "string") return content;

  if (Array.isArray(content)) {
    return content
      .map((part) => {
        if (typeof part === "string") return part;
        if (part && typeof part === "object" && "text" in part && typeof (part as { text?: unknown }).text === "string") {
          return (part as { text: string }).text;
        }
        return "";
      })
      .join("\n")
      .trim();
  }

  return "";
}

function parseJSONFromText<T>(text: string): T {
  const cleaned = text.replace(/```json|```/gi, "").trim();

  try {
    return JSON.parse(cleaned) as T;
  } catch {
    const firstBrace = cleaned.indexOf("{");
    const lastBrace = cleaned.lastIndexOf("}");

    if (firstBrace >= 0 && lastBrace > firstBrace) {
      const candidate = cleaned.slice(firstBrace, lastBrace + 1);
      return JSON.parse(candidate) as T;
    }

    throw new Error("Model did not return valid JSON");
  }
}

export async function invokeStructuredJSON<T>(systemPrompt: string, userPrompt: string): Promise<T> {
  const llm = new ChatGroq({
    apiKey: getEnv("GROQ_API_KEY"),
    model: getEnv("GROQ_MODEL", "llama-3.3-70b-versatile"),
    temperature: 0.2,
  });

  const response = await llm.invoke([
    { role: "system", content: systemPrompt },
    { role: "user", content: userPrompt },
  ]);

  const text = normalizeAIContent(response.content);
  if (!text) {
    throw new Error("Model returned an empty response");
  }

  return parseJSONFromText<T>(text);
}
