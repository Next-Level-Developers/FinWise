import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validateOcrCategorizeInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validateOcrCategorizeInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const systemPrompt = "You are FinWise OCR transaction categorizer. Convert receipt OCR text into a clean transaction object. Return valid JSON only.";
  const userPrompt = `Categorize this OCR text for a finance app:\n${JSON.stringify(d, null, 2)}\n\nReturn exact JSON keys: amount, currency, category, subCategory, merchantName, title, date, paymentMethod, tags, confidence, needsUserReview.`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    return NextResponse.json({
      success: true,
      insight_type: "ocr_categorization",
      result,
      cache_ttl: "none",
    });
  } catch (err) {
    console.error("[ocr-categorize] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
