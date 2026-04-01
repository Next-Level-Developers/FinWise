import { Panel } from "@/components/ui/shell";

const rows = [
  ["Food", "₹5,600", "₹7,200", "+₹1,600"],
  ["Transport", "₹2,200", "₹2,450", "+₹250"],
  ["Shopping", "₹3,400", "₹5,100", "+₹1,700"],
  ["Subscriptions", "₹1,200", "₹1,650", "+₹450"],
];

export default function ExpenseBreakdownPage() {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold">AI Expense Analysis</h1>
      <Panel title="AI Summary for July">
        <p className="text-sm text-[#d1d5db]">Your total spend rose mainly due to shopping and dining. Essentials are stable, while discretionary spend is above your historical average.</p>
      </Panel>
      <section className="grid gap-4 lg:grid-cols-2">
        <Panel title="Category Breakdown"><div className="grid h-48 grid-cols-5 items-end gap-2">{[70,45,55,35,50].map((h,i)=><div key={i} className="rounded-t bg-[#2563eb]" style={{height:`${h*2}px`}} />)}</div></Panel>
        <Panel title="Category Ranking"><div className="space-y-2">{[['Shopping','₹5,100'],['Food','₹7,200'],['Transport','₹2,450'],['Bills','₹3,200']].map(([n,v])=><div key={n} className="flex items-center justify-between rounded border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm"><span>{n}</span><span className="font-mono">{v}</span></div>)}</div></Panel>
      </section>
      <Panel title="Month Over Month">
        <table className="w-full text-sm"><thead className="text-left text-[#9ca3af]"><tr><th>Category</th><th>Last Month</th><th>This Month</th><th>Change</th></tr></thead><tbody>{rows.map((r)=><tr key={r[0]} className="border-t border-[#2a2b2e]"><td className="py-2">{r[0]}</td><td>{r[1]}</td><td>{r[2]}</td><td className="text-[#f87171]">{r[3]}</td></tr>)}</tbody></table>
      </Panel>
    </div>
  );
}
