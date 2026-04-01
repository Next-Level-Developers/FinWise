import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

const stats = [
  { label: "TOTAL SPENDINGS", value: "₹28,450", delta: "-12%", tone: "red" as const },
  { label: "SAVINGS", value: "₹2,512.40", delta: "-2%", tone: "amber" as const },
  { label: "INVESTMENTS", value: "₹1,215.25", delta: "+6%", tone: "green" as const },
];

const tx = [
  ["TODAY", "Swiggy", "Food", "-₹420"],
  ["TODAY", "Salary", "Income", "+₹42,000"],
  ["YESTERDAY", "Uber", "Transport", "-₹280"],
  ["JUL 18", "Amazon", "Shopping", "-₹1,140"],
];

export default function DashboardOverviewPage() {
  return (
    <div className="space-y-6">
      <section className="grid gap-4 md:grid-cols-3">
        {stats.map((stat) => (
          <Panel key={stat.label} title={stat.label} right={<Pill tone={stat.tone}>{stat.delta}</Pill>}>
            <p className="font-mono text-3xl font-semibold">{stat.value}</p>
            <div className="mt-4 grid h-16 grid-cols-7 items-end gap-1">
              {[35, 28, 45, 22, 31, 41, 26].map((h, i) => (
                <span key={i} className="rounded-sm bg-[#2a2b2e]" style={{ height: `${h}px` }} />
              ))}
            </div>
          </Panel>
        ))}
      </section>

      <section className="grid gap-4 lg:grid-cols-[0.4fr_0.6fr]">
        <Panel title="Transactions" subtitle="Recent activity" right={<Link href="/dashboard/transactions" className="text-xs text-[#4ade80]">View all</Link>}>
          <div className="space-y-2">
            {tx.map(([day, merchant, cat, amount], idx) => (
              <div key={idx} className="flex items-center justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2">
                <div>
                  <p className="text-sm font-medium">{merchant}</p>
                  <p className="text-xs text-[#6b7280]">{day} • {cat}</p>
                </div>
                <span className={`font-mono text-sm ${amount.startsWith("+") ? "text-[#4ade80]" : "text-[#f87171]"}`}>{amount}</span>
              </div>
            ))}
          </div>
        </Panel>

        <Panel title="₹9,340.80 Spent" subtitle="Year view">
          <div className="grid h-56 grid-cols-7 items-end gap-2">
            {[120, 90, 150, 130, 110, 160, 140].map((h, i) => (
              <div key={i} className="rounded-t-md bg-gradient-to-t from-[#2563eb] via-[#7c3aed] to-[#db2777]" style={{ height: `${h}px` }} />
            ))}
          </div>
          <p className="mt-3 text-xs text-[#9ca3af]">Expenses • Transfers • Subscriptions • Grocery • Shopping</p>
        </Panel>
      </section>

      <Panel title="Your spending insight">
        <p className="text-sm text-[#d1d5db]">You spent 23% more on dining this month. Cooking at home two more days weekly can save about ₹1,800.</p>
      </Panel>
    </div>
  );
}
