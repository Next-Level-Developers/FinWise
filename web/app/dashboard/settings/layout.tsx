"use client";

import type { ReactNode } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";

const tabs = [
  ["/dashboard/settings/profile", "Profile"],
  ["/dashboard/settings/preferences", "Preferences"],
  ["/dashboard/settings/security", "Security"],
] as const;

export default function SettingsLayout({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  return (
    <div className="space-y-4">
      <div className="flex gap-2">
        {tabs.map(([href, label]) => (
          <Link key={href} href={href} className={`rounded-lg border px-3 py-2 text-sm ${pathname === href ? "border-[#4ade80] bg-[#132217] text-[#86efac]" : "border-[#2a2b2e] text-[#9ca3af]"}`}>
            {label}
          </Link>
        ))}
      </div>
      {children}
    </div>
  );
}
