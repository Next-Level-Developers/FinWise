"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { signInWithGoogle } from "@/lib/firebase/auth";

export default function LoginPage() {
  const router = useRouter();
  const [loadingGoogle, setLoadingGoogle] = useState(false);
  const [authError, setAuthError] = useState<string | null>(null);

  async function handleGoogleSignIn() {
    setLoadingGoogle(true);
    setAuthError(null);

    try {
      await signInWithGoogle();
      router.push("/dashboard/overview");
    } catch {
      setAuthError("Google sign-in failed. Please try again.");
    } finally {
      setLoadingGoogle(false);
    }
  }

  return (
    <div className="w-full max-w-md rounded-2xl border border-[#2a2b2e] bg-[#161719] p-6 shadow-2xl">
      <h1 className="text-2xl font-semibold text-[#f4f4f5]">Welcome back</h1>
      <p className="mt-1 text-sm text-[#9ca3af]">Sign in to continue.</p>

      <button
        type="button"
        onClick={handleGoogleSignIn}
        disabled={loadingGoogle}
        className="mt-5 w-full rounded-lg border border-[#2a2b2e] bg-[#121316] px-4 py-2 text-sm text-[#f4f4f5] disabled:opacity-60"
      >
        {loadingGoogle ? "Connecting..." : "Continue with Google"}
      </button>

      {authError ? <p className="mt-2 text-xs text-[#f87171]">{authError}</p> : null}

      <div className="my-4 flex items-center gap-3 text-xs text-[#6b7280]">
        <span className="h-px flex-1 bg-[#2a2b2e]" />
        or continue with email
        <span className="h-px flex-1 bg-[#2a2b2e]" />
      </div>

      <form className="space-y-3">
        <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Email" />
        <input type="password" className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Password" />
        <div className="text-right text-xs text-[#9ca3af]">
          <Link href="/auth/forgot-password" className="hover:text-[#f4f4f5]">Forgot password?</Link>
        </div>
        <button type="button" className="w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Sign In</button>
      </form>

      <p className="mt-4 text-sm text-[#9ca3af]">
        Don&apos;t have an account? <Link href="/auth/register" className="text-[#4ade80]">Sign up</Link>
      </p>
      <p className="mt-4 text-xs text-[#6b7280]">Protected by Firebase Auth and encrypted storage.</p>
    </div>
  );
}
