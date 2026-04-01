"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const nav = [
  ["/dashboard/overview", "Overview", "GP"],
  ["/dashboard/transactions", "Transactions", "TR"],
  ["/dashboard/budget", "Budget", "BG"],
  ["/dashboard/goals", "Goals", "GL"],
  ["/dashboard/ai", "AI Assistant", "AI"],
  ["/dashboard/learn", "Learn", "LR"],
  ["/dashboard/schemes", "Schemes", "SC"],
  ["/dashboard/experts", "Experts", "EX"],
  ["/dashboard/notifications", "Notifications", "NT"],
  ["/dashboard/settings/profile", "Settings", "ST"],
] as const;

export function DashboardSidebar() {
  const pathname = usePathname();

  return (
    <aside className="hidden h-screen w-[220px] shrink-0 border-r border-[#2a2b2e] bg-[#121316] p-4 lg:flex lg:flex-col">
      <p className="mb-4 px-2 text-lg font-semibold text-[#f4f4f5]">FinWise</p>
      <p className="mb-2 px-2 text-[10px] uppercase tracking-[0.22em] text-[#4b5563]">General</p>
      <nav className="space-y-1">
        {nav.map(([href, label, short]) => {
          const active = pathname.startsWith(href);
          return (
            <Link
              key={href}
              href={href}
              className={`flex items-center gap-2 rounded-lg border px-3 py-2 text-sm transition ${
                active
                  ? "border-[#2e4f3b] bg-[#15211a] text-[#86efac]"
                  : "border-transparent text-[#9ca3af] hover:border-[#2a2b2e] hover:bg-[#1a1c20] hover:text-[#f4f4f5]"
              }`}
            >
              <span className="inline-flex h-5 w-5 items-center justify-center rounded bg-[#1e2023] text-[10px]">{short}</span>
              {label}
            </Link>
          );
        })}
      </nav>

      <div className="mt-auto rounded-xl border border-[#2a2b2e] bg-[#17181b] p-3">
        <p className="text-sm font-medium">Pushkar</p>
        <p className="text-xs text-[#9ca3af]">Free Plan</p>
        <button type="button" className="mt-2 rounded-md border border-[#2a2b2e] px-2 py-1 text-xs text-[#f4f4f5]">
          Log out
        </button>
      </div>
    </aside>
  );
}
