import type { ReactNode } from "react";

export default function AuthLayout({ children }: { children: ReactNode }) {
  return (
    <div className="finwise-shell grid min-h-screen lg:grid-cols-2">
      <section className="hidden flex-col justify-between border-r border-[#2a2b2e] bg-[#111216] p-10 lg:flex">
        <div>
          <p className="text-xl font-semibold text-[#f4f4f5]">FinWise</p>
          <p className="mt-2 max-w-sm text-sm text-[#9ca3af]">
            AI-powered financial clarity for Indian households.
          </p>
        </div>
        <div className="rounded-2xl border border-[#2a2b2e] bg-[#161719] p-6">
          <p className="text-sm text-[#9ca3af]">Track. Analyze. Grow.</p>
          <p className="mt-2 text-lg font-semibold text-[#f4f4f5]">Your money journey starts with one login.</p>
        </div>
      </section>
      <section className="flex items-center justify-center px-4 py-10 sm:px-6">{children}</section>
    </div>
  );
}
