import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validateGenerateBudgetInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validateGenerateBudgetInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const systemPrompt = "You are a personal budget planner for FinWise. Produce realistic allocations from historical spending and active goals. Respond only in valid JSON.";
  const userPrompt = `Generate a monthly budget using:\n${JSON.stringify(d, null, 2)}\n\nReturn exact JSON keys: totalBudget, categoryLimits, reasoning, goalAllocations, savingsTarget, alertThreshold, tips.`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    return NextResponse.json({
      success: true,
      insight_type: "budget_generation",
      result,
      cache_scope: "per_budget_document",
    });
  } catch (err) {
    console.error("[generate-budget] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
