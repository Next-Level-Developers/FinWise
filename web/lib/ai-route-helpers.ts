import { NextResponse } from "next/server";

export async function readJsonBody(request: Request): Promise<{ ok: true; body: unknown } | { ok: false }> {
  try {
    const body = await request.json();
    return { ok: true, body };
  } catch {
    return { ok: false };
  }
}

export function invalidJsonResponse() {
  return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
}

export function validationErrorResponse(errors: string[]) {
  return NextResponse.json({ error: "Validation failed", details: errors }, { status: 422 });
}
