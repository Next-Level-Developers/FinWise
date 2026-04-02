import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validateLearningPathInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validateLearningPathInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const systemPrompt = "You are FinWise Learning Path Personalizer. Recommend personalized module sequence and motivation notes. Return valid JSON only.";
  const userPrompt = `Generate a personalized learning path:\n${JSON.stringify(d, null, 2)}\n\nReturn exact JSON keys: recommendedPath, learnerLevel, motivationNote, nextBadgeHint.`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    return NextResponse.json({
      success: true,
      insight_type: "learning_path",
      result,
      cache_ttl_days: 14,
    });
  } catch (err) {
    console.error("[learning-path] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
