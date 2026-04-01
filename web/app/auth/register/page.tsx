"use client";

import { type FormEvent, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { registerWithEmailPassword, signInWithGoogle } from "@/lib/firebase/auth";

export default function RegisterPage() {
  const router = useRouter();
  const [loadingGoogle, setLoadingGoogle] = useState(false);
  const [loadingEmail, setLoadingEmail] = useState(false);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [acceptedTerms, setAcceptedTerms] = useState(false);
  const [authError, setAuthError] = useState<string | null>(null);

  async function handleGoogleSignUp() {
    setLoadingGoogle(true);
    setAuthError(null);

    try {
      await signInWithGoogle();
      router.push("/auth/onboarding");
    } catch {
      setAuthError("Google sign-up failed. Please try again.");
    } finally {
      setLoadingGoogle(false);
    }
  }

  async function handleEmailSignUp(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setAuthError(null);

    if (!acceptedTerms) {
      setAuthError("Please accept Terms and Privacy Policy.");
      return;
    }

    if (password !== confirmPassword) {
      setAuthError("Passwords do not match.");
      return;
    }

    if (password.length < 6) {
      setAuthError("Password should be at least 6 characters.");
      return;
    }

    setLoadingEmail(true);

    try {
      await registerWithEmailPassword(email.trim(), password, name.trim());
      router.push("/auth/onboarding");
    } catch {
      setAuthError("Email sign-up failed. Please try a different email.");
    } finally {
      setLoadingEmail(false);
    }
  }

  return (
    <div className="w-full max-w-md rounded-2xl border border-[#2a2b2e] bg-[#161719] p-6 shadow-2xl">
      <h1 className="text-2xl font-semibold text-[#f4f4f5]">Create your account</h1>
      <p className="mt-1 text-sm text-[#9ca3af]">Join 10,000+ users managing money smarter.</p>

      <button
        type="button"
        onClick={handleGoogleSignUp}
        disabled={loadingGoogle || loadingEmail}
        className="mt-5 w-full rounded-lg border border-[#2a2b2e] bg-[#121316] px-4 py-2 text-sm text-[#f4f4f5] disabled:opacity-60"
      >
        {loadingGoogle ? "Connecting..." : "Sign up with Google"}
      </button>

      {authError ? <p className="mt-2 text-xs text-[#f87171]">{authError}</p> : null}

      <div className="my-4 flex items-center gap-3 text-xs text-[#6b7280]">
        <span className="h-px flex-1 bg-[#2a2b2e]" />
        or create with email
        <span className="h-px flex-1 bg-[#2a2b2e]" />
      </div>

      <form className="space-y-3" onSubmit={handleEmailSignUp}>
        <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Full Name" value={name} onChange={(e) => setName(e.target.value)} required />
        <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
        <input type="password" className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} required />
        <div className="grid grid-cols-4 gap-1">
          <span className="h-1 rounded bg-[#ef4444]" />
          <span className="h-1 rounded bg-[#f59e0b]" />
          <span className="h-1 rounded bg-[#3b82f6]" />
          <span className="h-1 rounded bg-[#22c55e]" />
        </div>
        <input type="password" className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Confirm Password" value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} required />
        <label className="flex items-center gap-2 text-xs text-[#9ca3af]"><input type="checkbox" checked={acceptedTerms} onChange={(e) => setAcceptedTerms(e.target.checked)} /> I agree to Terms and Privacy Policy</label>
        <button type="submit" disabled={loadingGoogle || loadingEmail} className="w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:opacity-60">{loadingEmail ? "Creating..." : "Create Account"}</button>
      </form>

      <p className="mt-4 text-sm text-[#9ca3af]">
        Already have an account? <Link href="/auth/login" className="text-[#4ade80]">Sign in</Link>
      </p>
    </div>
  );
}
