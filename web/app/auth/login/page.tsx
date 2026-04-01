"use client";

import { type FormEvent, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { signInWithEmailPassword, signInWithGoogle } from "@/lib/firebase/auth";

const demoEmail = process.env.NEXT_PUBLIC_DEMO_EMAIL || "";
const demoPassword = process.env.NEXT_PUBLIC_DEMO_PASSWORD || "";

export default function LoginPage() {
  const router = useRouter();
  const [loadingGoogle, setLoadingGoogle] = useState(false);
  const [loadingEmail, setLoadingEmail] = useState(false);
  const [loadingDemo, setLoadingDemo] = useState(false);
  const [email, setEmail] = useState(demoEmail);
  const [password, setPassword] = useState(demoPassword);
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

  async function handleEmailPasswordSignIn(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setLoadingEmail(true);
    setAuthError(null);

    try {
      await signInWithEmailPassword(email.trim(), password);
      router.push("/dashboard/overview");
    } catch {
      setAuthError("Email/password sign-in failed. Check your credentials.");
    } finally {
      setLoadingEmail(false);
    }
  }

  async function handleDemoSignIn() {
    if (!demoEmail || !demoPassword) {
      setAuthError("Demo email/password is not configured. Set NEXT_PUBLIC_DEMO_EMAIL and NEXT_PUBLIC_DEMO_PASSWORD.");
      return;
    }

    setLoadingDemo(true);
    setAuthError(null);

    try {
      setEmail(demoEmail);
      setPassword(demoPassword);
      await signInWithEmailPassword(demoEmail, demoPassword);
      router.push("/dashboard/overview");
    } catch {
      setAuthError("Demo sign-in failed. Make sure this demo user exists in Firebase Authentication (Email/Password provider).");
    } finally {
      setLoadingDemo(false);
    }
  }

  return (
    <div className="w-full max-w-md rounded-2xl border border-[#2a2b2e] bg-[#161719] p-6 shadow-2xl">
      <h1 className="text-2xl font-semibold text-[#f4f4f5]">Welcome back</h1>
      <p className="mt-1 text-sm text-[#9ca3af]">Sign in to continue.</p>

      <button
        type="button"
        onClick={handleGoogleSignIn}
        disabled={loadingGoogle || loadingEmail || loadingDemo}
        className="mt-5 w-full rounded-lg border border-[#2a2b2e] bg-[#121316] px-4 py-2 text-sm text-[#f4f4f5] disabled:opacity-60"
      >
        {loadingGoogle ? "Connecting..." : "Continue with Google"}
      </button>

      <button
        type="button"
        onClick={handleDemoSignIn}
        disabled={loadingGoogle || loadingEmail || loadingDemo}
        className="mt-2 w-full rounded-lg border border-[#2f3f2f] bg-[#162217] px-4 py-2 text-sm text-[#86efac] disabled:opacity-60"
      >
        {loadingDemo ? "Signing in..." : "Demo Login"}
      </button>

      {demoEmail ? <p className="mt-2 text-xs text-[#9ca3af]">Demo email auto-filled for judges.</p> : null}

      {authError ? <p className="mt-2 text-xs text-[#f87171]">{authError}</p> : null}

      <div className="my-4 flex items-center gap-3 text-xs text-[#6b7280]">
        <span className="h-px flex-1 bg-[#2a2b2e]" />
        or continue with email
        <span className="h-px flex-1 bg-[#2a2b2e]" />
      </div>

      <form className="space-y-3" onSubmit={handleEmailPasswordSignIn}>
        <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
        <input type="password" className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} required />
        <div className="text-right text-xs text-[#9ca3af]">
          <Link href="/auth/forgot-password" className="hover:text-[#f4f4f5]">Forgot password?</Link>
        </div>
        <button type="submit" disabled={loadingGoogle || loadingEmail || loadingDemo} className="w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:opacity-60">{loadingEmail ? "Signing in..." : "Sign In"}</button>
      </form>

      <p className="mt-4 text-sm text-[#9ca3af]">
        Don&apos;t have an account? <Link href="/auth/register" className="text-[#4ade80]">Sign up</Link>
      </p>
      <p className="mt-4 text-xs text-[#6b7280]">Protected by Firebase Auth and encrypted storage.</p>
    </div>
  );
}
