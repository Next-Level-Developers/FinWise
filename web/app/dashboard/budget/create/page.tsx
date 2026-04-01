import Link from "next/link";
import { Panel } from "@/components/ui/shell";

const rows = ["Food", "Transport", "Shopping", "Health", "Entertainment", "Subscriptions", "Utilities", "Savings"];

export default function CreateBudgetPage() {
  return (
    <div className="mx-auto max-w-4xl space-y-4">
      <Link href="/dashboard/budget" className="text-sm text-[#9ca3af]">Back to budget</Link>
      <Panel title="Create Monthly Budget" subtitle="Based on your previous spending trends">
        <div className="grid gap-2 sm:grid-cols-[1fr_auto]">
          <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Monthly Income" defaultValue="₹60,000" />
          <button type="button" className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">AI Suggest Budget</button>
        </div>

        <div className="mt-4 space-y-2">
          {rows.map((row) => (
            <div key={row} className="grid gap-2 rounded-lg border border-[#2a2b2e] bg-[#111216] p-3 sm:grid-cols-[120px_1fr_120px] sm:items-center">
              <p className="text-sm">{row}</p>
              <input type="range" defaultValue={50} className="w-full" />
              <input className="rounded border border-[#2a2b2e] bg-[#161719] px-2 py-1 text-sm" defaultValue="₹3,000" />
            </div>
          ))}
        </div>

        <button type="button" className="mt-4 w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Save Budget</button>
      </Panel>
    </div>
  );
}
