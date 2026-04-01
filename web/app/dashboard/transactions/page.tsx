import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

const rows = [
  ["A", "Amazon", "Shopping", "20 Jul, 6:22 PM", "Card", "-₹2,399"],
  ["S", "Salary", "Income", "20 Jul, 8:00 AM", "Bank", "+₹42,000"],
  ["U", "Uber", "Transport", "19 Jul, 11:10 PM", "UPI", "-₹280"],
  ["N", "Netflix", "Subscriptions", "19 Jul, 8:00 PM", "Card", "-₹649"],
];

export default function TransactionsPage() {
  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div>
          <h1 className="text-2xl font-semibold">Transactions</h1>
          <p className="text-sm text-[#9ca3af]">Track, filter, and review all money movement.</p>
        </div>
        <div className="flex gap-2">
          <Link href="/dashboard/transactions/import" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Import CSV</Link>
          <Link href="/dashboard/transactions/add" className="rounded-lg bg-[#4ade80] px-3 py-2 text-sm font-semibold text-[#0e0f11]">Add Transaction</Link>
        </div>
      </div>

      <Panel title="Filters">
        <div className="grid gap-2 md:grid-cols-4">
          <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" defaultValue="This Month" />
          <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Category" />
          <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Type" />
          <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Search" />
        </div>
      </Panel>

      <section className="grid gap-3 md:grid-cols-3">
        <Panel title="Total Income"><p className="font-mono text-2xl text-[#4ade80]">₹1,22,000</p></Panel>
        <Panel title="Total Expense"><p className="font-mono text-2xl text-[#f87171]">₹63,220</p></Panel>
        <Panel title="Net Balance"><p className="font-mono text-2xl text-[#4ade80]">₹58,780</p></Panel>
      </section>

      <Panel title="Transaction Table" subtitle="Showing 1-20 of 143">
        <div className="overflow-x-auto">
          <table className="w-full min-w-[760px] text-sm">
            <thead className="text-left text-[#9ca3af]"><tr><th className="pb-3">Merchant</th><th className="pb-3">Category</th><th className="pb-3">Date</th><th className="pb-3">Payment</th><th className="pb-3 text-right">Amount</th></tr></thead>
            <tbody>
              {rows.map(([initial, merchant, category, date, payment, amount]) => (
                <tr key={`${merchant}-${date}`} className="border-t border-[#2a2b2e]">
                  <td className="py-3"><Link href={`/dashboard/transactions/${merchant.toLowerCase()}`} className="flex items-center gap-2"><span className="inline-flex h-7 w-7 items-center justify-center rounded-full bg-[#1e2023] text-xs">{initial}</span><span>{merchant}</span></Link></td>
                  <td className="py-3"><Pill tone="blue">{category}</Pill></td>
                  <td className="py-3 text-[#9ca3af]">{date}</td>
                  <td className="py-3 text-[#9ca3af]">{payment}</td>
                  <td className={`py-3 text-right font-mono ${amount.startsWith("+") ? "text-[#4ade80]" : "text-[#f87171]"}`}>{amount}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Panel>
    </div>
  );
}
