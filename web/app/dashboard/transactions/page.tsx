"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";
import { getRecentTransactions, type Transaction } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

function currency(value: number) {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 0,
  }).format(value);
}

export default function TransactionsPage() {
  const userId = useUserId();
  const [rows, setRows] = useState<Transaction[]>([]);

  useEffect(() => {
    async function loadRows() {
      const data = await getRecentTransactions(userId, 100);
      setRows(data);
    }

    void loadRows();
  }, [userId]);

  const totals = useMemo(() => {
    return rows.reduce(
      (acc, row) => {
        if (row.type === "income") {
          acc.income += row.amount;
        } else {
          acc.expense += row.amount;
        }
        return acc;
      },
      { income: 0, expense: 0 },
    );
  }, [rows]);

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
        <Panel title="Total Income"><p className="font-mono text-2xl text-[#4ade80]">{currency(totals.income)}</p></Panel>
        <Panel title="Total Expense"><p className="font-mono text-2xl text-[#f87171]">{currency(totals.expense)}</p></Panel>
        <Panel title="Net Balance"><p className="font-mono text-2xl text-[#4ade80]">{currency(totals.income - totals.expense)}</p></Panel>
      </section>

      <Panel title="Transaction Table" subtitle={`Showing ${Math.min(rows.length, 20)} of ${rows.length}`}>
        <div className="overflow-x-auto">
          <table className="w-full min-w-[760px] text-sm">
            <thead className="text-left text-[#9ca3af]"><tr><th className="pb-3">Merchant</th><th className="pb-3">Category</th><th className="pb-3">Date</th><th className="pb-3">Payment</th><th className="pb-3 text-right">Amount</th></tr></thead>
            <tbody>
              {rows.map((row) => {
                const label = row.merchantName || row.title || row.id;
                const initial = (label[0] || "T").toUpperCase();
                const amount = `${row.type === "expense" ? "-" : "+"}${currency(row.amount)}`;
                const date = row.date
                  ? row.date.toLocaleString("en-IN", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" })
                  : "Date N/A";

                return (
                <tr key={row.id} className="border-t border-[#2a2b2e]">
                  <td className="py-3"><Link href={`/dashboard/transactions/${row.id}`} className="flex items-center gap-2"><span className="inline-flex h-7 w-7 items-center justify-center rounded-full bg-[#1e2023] text-xs">{initial}</span><span>{label}</span></Link></td>
                  <td className="py-3"><Pill tone="blue">{row.category || row.type}</Pill></td>
                  <td className="py-3 text-[#9ca3af]">{date}</td>
                  <td className="py-3 text-[#9ca3af]">{row.paymentMethod || "N/A"}</td>
                  <td className={`py-3 text-right font-mono ${amount.startsWith("+") ? "text-[#4ade80]" : "text-[#f87171]"}`}>{amount}</td>
                </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </Panel>
    </div>
  );
}
