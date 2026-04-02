import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validateExpenseInsightsInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validateExpenseInsightsInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const systemPrompt = "You are FinWise AI for expense insights. Use provided non-PII financial data only. Respond with raw valid JSON only.";
  const userPrompt = `Generate monthly expense insights using this data:\n${JSON.stringify(d, null, 2)}\n\nReturn exact JSON with keys: summary (string with detailed analysis), topCategories, savingsHealth, savingsRateComment, anomalies, recommendations, nextMonthForecast.`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    if (!result.summary) {
      console.warn("[expense-insights] AI response missing summary field", { result });
    }

    return NextResponse.json({
      success: true,
      insight_type: "expense_insights",
      result,
      cache_ttl_hours: 24,
    });
  } catch (err) {
    console.error("[expense-insights] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
