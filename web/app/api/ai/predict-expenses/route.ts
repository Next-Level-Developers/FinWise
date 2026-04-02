import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validatePredictExpensesInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validatePredictExpensesInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const systemPrompt = "You are FinWise Expense Prediction Engine. Forecast next month spend using historical summaries and recurring costs. Return valid JSON only.";
  const userPrompt = `Predict next month expenses from:\n${JSON.stringify(d, null, 2)}\n\nReturn exact JSON keys: predictedTotalExpense, confidence, categoryForecasts, warnings, savingsProjection, recommendedBudgetAdjustments.`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    return NextResponse.json({
      success: true,
      insight_type: "expense_prediction",
      result,
      cache_ttl_days: 7,
    });
  } catch (err) {
    console.error("[predict-expenses] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
