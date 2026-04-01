import type { ReactNode } from "react";
import { MarketingFooter } from "@/components/layout/marketing-footer";
import { MarketingNavbar } from "@/components/layout/marketing-navbar";

export default function MarketingLayout({ children }: { children: ReactNode }) {
  return (
    <div className="finwise-shell">
      <MarketingNavbar />
      <main className="mx-auto w-full max-w-6xl px-4 pt-8 sm:px-6">{children}</main>
      <MarketingFooter />
    </div>
  );
}
