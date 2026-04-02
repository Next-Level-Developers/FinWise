import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validateVideoInsightsInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validateVideoInsightsInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const systemPrompt = "You are FinWise Video Insight Analyzer. Summarize personal finance videos into actionable tips for the user's context. Return JSON only.";
  const userPrompt = `Analyze this transcript and context:\n${JSON.stringify(d, null, 2)}\n\nReturn exact JSON keys: summary, keyTips, actionPoints, relevanceScore, relatedGoals, relatedCategory.`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    return NextResponse.json({
      success: true,
      insight_type: "video_insights",
      video_id: d.videoId,
      result,
      cache_ttl: "permanent_per_video_id",
    });
  } catch (err) {
    console.error("[video-insights] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
