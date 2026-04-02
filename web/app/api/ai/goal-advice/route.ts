import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validateGoalAdviceInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validateGoalAdviceInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const systemPrompt = "You are FinWise Goal Advisor. Predict realistic goal completion and suggest actionable strategies. Return valid JSON only.";
  const userPrompt = `Analyze this goal context:\n${JSON.stringify(d, null, 2)}\n\nReturn exact JSON keys: projectedCompletionDate, isOnTrack, shortfallAmount, requiredMonthlySaving, currentMonthlySaving, advice, strategies, milestoneMessage, riskLevel.`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    return NextResponse.json({
      success: true,
      insight_type: "goal_advice",
      result,
      cache_ttl_days: 3,
    });
  } catch (err) {
    console.error("[goal-advice] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
