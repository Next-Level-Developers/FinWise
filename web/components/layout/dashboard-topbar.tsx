"use client";

import { useMemo } from "react";
import { usePathname } from "next/navigation";

function formatTitle(pathname: string): string {
  const leaf = pathname.split("/").filter(Boolean).pop() ?? "overview";
  if (leaf.startsWith("[")) return "Detail";
  return leaf
    .replace(/-/g, " ")
    .replace(/\b\w/g, (c) => c.toUpperCase());
}

export function DashboardTopbar() {
  const pathname = usePathname();
  const title = useMemo(() => formatTitle(pathname), [pathname]);

  return (
    <header className="sticky top-0 z-30 flex h-16 items-center justify-between border-b border-[#2a2b2e] bg-[#0e0f11cc] px-4 backdrop-blur-xl sm:px-6">
      <div>
        <p className="text-lg font-semibold text-[#f4f4f5]">{title}</p>
        <p className="text-xs text-[#6b7280]">Dashboard</p>
      </div>
      <div className="flex items-center gap-3">
        <input
          placeholder="Search transactions, goals..."
          className="hidden w-72 rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm text-[#f4f4f5] md:block"
        />
        <span className="inline-flex h-8 w-8 items-center justify-center rounded-full border border-[#2a2b2e] bg-[#1d1f23] text-xs">EN</span>
        <div className="h-8 w-8 rounded-full bg-[#1d1f23]" />
      </div>
    </header>
  );
}
