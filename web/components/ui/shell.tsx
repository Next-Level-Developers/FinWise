import type { ReactNode } from "react";

export function Panel({ title, subtitle, right, children }: { title: string; subtitle?: string; right?: ReactNode; children: ReactNode }) {
  return (
    <section className="rounded-xl border border-[#2a2b2e] bg-[#161719] p-5">
      <header className="mb-4 flex items-center justify-between gap-3">
        <div>
          <h2 className="text-lg font-semibold text-[#f4f4f5]">{title}</h2>
          {subtitle ? <p className="text-xs text-[#9ca3af]">{subtitle}</p> : null}
        </div>
        {right}
      </header>
      {children}
    </section>
  );
}

export function Pill({ children, tone = "neutral" }: { children: ReactNode; tone?: "neutral" | "green" | "red" | "amber" | "blue" }) {
  const toneClass: Record<string, string> = {
    neutral: "border-[#2a2b2e] text-[#9ca3af] bg-[#111216]",
    green: "border-[#22432f] text-[#86efac] bg-[#132217]",
    red: "border-[#4b2525] text-[#fca5a5] bg-[#231314]",
    amber: "border-[#4a3b1c] text-[#fcd34d] bg-[#241f13]",
    blue: "border-[#1f3552] text-[#93c5fd] bg-[#101b29]",
  };

  return <span className={`inline-flex rounded-md border px-2 py-1 text-xs ${toneClass[tone]}`}>{children}</span>;
}
