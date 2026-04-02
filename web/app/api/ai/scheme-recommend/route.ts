import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validateSchemeRecommendInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validateSchemeRecommendInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const systemPrompt = "You are FinWise Government Scheme Recommender for Indian users. Match schemes by eligibility and explain the rationale clearly. Return valid JSON only.";
  const userPrompt = `Recommend government schemes for this profile:\n${JSON.stringify(d, null, 2)}\n\nReturn exact JSON keys: recommendations, totalSchemesFetched, totalMatched.`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    return NextResponse.json({
      success: true,
      insight_type: "scheme_recommendation",
      result,
      cache_ttl_days: 7,
    });
  } catch (err) {
    console.error("[scheme-recommend] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
