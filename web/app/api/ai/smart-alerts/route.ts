import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validateSmartAlertsInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validateSmartAlertsInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const systemPrompt = "You are FinWise Smart Alert Engine. Generate concise, actionable financial alerts from budget and goal signals. Return valid JSON only.";
  const userPrompt = `Generate smart alerts for this user state:\n${JSON.stringify(d, null, 2)}\n\nReturn exact JSON keys: alerts (array of objects with type,title,body,emoji,urgency,deepLink,refType,refId).`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    return NextResponse.json({
      success: true,
      insight_type: "smart_alert",
      result,
      cache_ttl: "event_driven",
    });
  } catch (err) {
    console.error("[smart-alerts] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
