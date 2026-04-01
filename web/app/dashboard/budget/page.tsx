import Link from "next/link";
import { Panel } from "@/components/ui/shell";

const categories: Array<{ name: string; spent: number; total: number }> = [
  { name: "Food", spent: 4200, total: 6000 },
  { name: "Transport", spent: 2100, total: 3000 },
  { name: "Shopping", spent: 6500, total: 5000 },
  { name: "Health", spent: 1300, total: 2500 },
  { name: "Entertainment", spent: 1800, total: 2500 },
  { name: "Subscriptions", spent: 1450, total: 2000 },
  { name: "Utilities", spent: 2600, total: 3500 },
  { name: "Savings", spent: 4500, total: 6000 },
];

export default function BudgetPage() {
  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Budget</h1>
        <Link href="/dashboard/budget/create" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Edit Budget</Link>
      </div>

      <Panel title="Overall Budget" subtitle="This Month: July 2025">
        <div className="grid gap-4 md:grid-cols-3">
          <div><p className="font-mono text-3xl">₹35,000</p><p className="text-sm text-[#9ca3af]">₹22,450 spent</p></div>
          <div className="mx-auto h-32 w-32 rounded-full border-[10px] border-[#4ade80] border-t-[#fbbf24] border-r-[#f87171]" />
          <div className="text-right"><p className="font-mono text-2xl text-[#4ade80]">₹12,550</p><p className="text-sm text-[#9ca3af]">remaining</p></div>
        </div>
      </Panel>

      <section className="grid gap-3 md:grid-cols-2">
        {categories.map(({ name, spent, total }) => {
          const percent = Math.round((spent / total) * 100);
          const tone = percent > 90 ? "bg-[#f87171]" : percent > 70 ? "bg-[#fbbf24]" : "bg-[#4ade80]";
          return (
            <Panel key={name} title={name as string}>
              <div className="h-2 rounded bg-[#2a2b2e]"><div className={`h-2 rounded ${tone}`} style={{ width: `${Math.min(percent, 100)}%` }} /></div>
              <p className="mt-2 text-sm text-[#9ca3af]">₹{spent.toLocaleString("en-IN")} / ₹{total.toLocaleString("en-IN")} • {percent}% used</p>
            </Panel>
          );
        })}
      </section>
    </div>
  );
}
