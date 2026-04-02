import { NextResponse } from "next/server";
import { invokeStructuredJSON } from "@/lib/groq-client";
import { invalidJsonResponse, readJsonBody, validationErrorResponse } from "@/lib/ai-route-helpers";
import { validateChatInput } from "@/lib/ai-validators";

export async function POST(request: Request) {
  const parsedBody = await readJsonBody(request);
  if (!parsedBody.ok) return invalidJsonResponse();

  const validation = validateChatInput(parsedBody.body);
  if (!validation.valid) return validationErrorResponse(validation.errors);

  const d = validation.data;

  const recentHistory = d.recentMessages
    .slice(-20)
    .map((m) => `${m.role}: ${m.content}`)
    .join("\n");

  const systemPrompt = "You are FinWise AI Chat Assistant. Give practical, empathetic, concise financial guidance. Never request or output PII. Return JSON only.";
  const userPrompt = `User context and latest query:\n${JSON.stringify(
    {
      mode: d.mode,
      sessionId: d.sessionId,
      userContext: d.userContext,
      financialSnapshot: d.financialSnapshot,
      activeGoals: d.activeGoals,
      currentBudget: d.currentBudget,
      currentMessage: d.message,
    },
    null,
    2,
  )}\n\nRecent conversation:\n${recentHistory || "No previous messages."}\n\nReturn exact JSON keys: reply, suggestedActions, followUpSuggestions.`;

  try {
    const result = await invokeStructuredJSON<Record<string, unknown>>(systemPrompt, userPrompt);

    return NextResponse.json({
      success: true,
      insight_type: "chat_message",
      session_id: d.sessionId,
      result,
      cache_ttl: "none",
    });
  } catch (err) {
    console.error("[chat] AI error:", err);
    return NextResponse.json(
      { error: "AI processing failed", message: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
}
