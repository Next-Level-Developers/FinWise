import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

export default function ImportTransactionsPage() {
  return (
    <div className="mx-auto max-w-5xl space-y-4">
      <Link href="/dashboard/transactions" className="text-sm text-[#9ca3af]">Back to transactions</Link>
      <Panel title="Import Transactions" subtitle="Upload, map columns, and review before importing">
        <div className="grid gap-4 lg:grid-cols-3">
          <div className="rounded-lg border border-dashed border-[#2a2b2e] bg-[#111216] p-6 lg:col-span-2">
            <p className="font-medium">Drag and drop CSV, XLS, XLSX</p>
            <p className="mt-1 text-sm text-[#9ca3af]">or browse files from your device</p>
            <button type="button" className="mt-4 rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Browse files</button>
            <div className="mt-4 flex gap-2 text-xs"><Pill>CSV</Pill><Pill>XLS</Pill><Pill>XLSX</Pill></div>
          </div>
          <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-4">
            <p className="text-sm font-medium">Bank templates</p>
            <div className="mt-3 grid grid-cols-2 gap-2 text-xs">
              {['SBI','HDFC','ICICI','Axis','Kotak'].map((b) => <button key={b} className="rounded border border-[#2a2b2e] px-2 py-1">{b}</button>)}
            </div>
          </div>
        </div>
      </Panel>

      <Panel title="Map Columns" subtitle="Detected fields and destination mapping">
        <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-4">
          {['Date', 'Amount', 'Merchant', 'Type'].map((field) => (
            <div key={field} className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-3 text-sm">
              <p className="text-[#9ca3af]">CSV: {field}</p>
              <select className="mt-2 w-full rounded border border-[#2a2b2e] bg-[#15161a] px-2 py-1 text-xs"><option>{field}</option></select>
            </div>
          ))}
        </div>
      </Panel>

      <Panel title="Review and Import" subtitle="10 rows previewed, 2 duplicates will be skipped" right={<button type="button" className="rounded-md bg-[#4ade80] px-3 py-1 text-xs font-semibold text-[#0e0f11]">Import All</button>}>
        <div className="overflow-x-auto"><table className="w-full min-w-[560px] text-sm"><thead className="text-left text-[#9ca3af]"><tr><th>Date</th><th>Merchant</th><th>Amount</th><th>Type</th></tr></thead><tbody><tr className="border-t border-[#2a2b2e]"><td className="py-2">20 Jul</td><td>Amazon</td><td>-₹1,299</td><td>Expense</td></tr><tr className="border-t border-[#2a2b2e]"><td className="py-2">20 Jul</td><td>Salary</td><td>+₹42,000</td><td>Income</td></tr></tbody></table></div>
      </Panel>
    </div>
  );
}
