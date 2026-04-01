import Link from "next/link";
import { Panel } from "@/components/ui/shell";

const categories = ["Food", "Transport", "Shopping", "Health", "Entertainment", "Bills", "Salary", "Investment"];

export default function AddTransactionPage() {
  return (
    <div className="mx-auto max-w-3xl space-y-4">
      <Link href="/dashboard/transactions" className="text-sm text-[#9ca3af]">Back to transactions</Link>
      <Panel title="Add Transaction" subtitle="Capture a new expense, income, or transfer">
        <div className="space-y-4">
          <div className="grid grid-cols-3 gap-2">
            {['EXPENSE', 'INCOME', 'TRANSFER'].map((type, i) => (
              <button key={type} type="button" className={`rounded-lg border px-3 py-2 text-sm ${i === 0 ? 'border-[#4ade80] bg-[#132217] text-[#86efac]' : 'border-[#2a2b2e] bg-[#111216]'}`}>{type}</button>
            ))}
          </div>

          <div>
            <label className="text-xs text-[#9ca3af]">Amount</label>
            <input className="mt-1 w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-3 font-mono text-3xl" placeholder="₹ 0.00" />
          </div>

          <div className="grid gap-2 sm:grid-cols-4">
            {categories.map((category) => (
              <button key={category} type="button" className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-2 py-2 text-sm hover:border-[#4ade80]">{category}</button>
            ))}
          </div>

          <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Merchant or description" />
          <div className="grid gap-2 sm:grid-cols-2">
            <input type="date" className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" />
            <select className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm"><option>UPI</option><option>Cash</option><option>Debit Card</option><option>Credit Card</option></select>
          </div>
          <textarea className="w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Add a note (optional)" rows={3} />
          <div className="rounded-lg border border-dashed border-[#2a2b2e] bg-[#111216] p-5 text-center text-sm text-[#9ca3af]">Scan receipt with OCR</div>
          <button type="button" className="w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Save Transaction</button>
        </div>
      </Panel>
    </div>
  );
}
