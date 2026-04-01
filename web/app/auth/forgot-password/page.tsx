import Link from "next/link";

export default function ForgotPasswordPage() {
  return (
    <div className="w-full max-w-md rounded-2xl border border-[#2a2b2e] bg-[#161719] p-6">
      <Link href="/auth/login" className="text-sm text-[#9ca3af]">Back to login</Link>
      <h1 className="mt-4 text-2xl font-semibold text-[#f4f4f5]">Reset your password</h1>
      <p className="mt-1 text-sm text-[#9ca3af]">Enter your email and we will send you a reset link.</p>
      <input className="mt-5 w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Email" />
      <button type="button" className="mt-3 w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Send Reset Link</button>
    </div>
  );
}
