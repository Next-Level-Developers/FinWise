"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { Panel, Pill } from "@/components/ui/shell";
import { getTransactionById, type Transaction } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

function currency(value: number) {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 0,
  }).format(value);
}

export default function TransactionDetailPage() {
  const params = useParams<{ id: string }>();
  const userId = useUserId();
  const [tx, setTx] = useState<Transaction | null>(null);

  useEffect(() => {
    async function loadTx() {
      const data = await getTransactionById(userId, params.id);
      setTx(data);
    }

    void loadTx();
  }, [params.id, userId]);

  const isPositive = tx?.type !== "expense";
  const amountText = `${isPositive ? "+" : "-"}${currency(tx?.amount || 0)}`;

  return (
    <div className="mx-auto max-w-2xl space-y-4">
      <Link href="/dashboard/transactions" className="text-sm text-[#9ca3af]">Back to transactions</Link>

      <Panel title={tx?.title || tx?.merchantName || "Transaction"} subtitle={`Transaction ID: ${params.id}`} right={<Pill tone={isPositive ? "green" : "red"}>{tx?.type || "expense"}</Pill>}>
        <p className={`font-mono text-4xl ${isPositive ? "text-[#4ade80]" : "text-[#f87171]"}`}>{amountText}</p>
        <p className="mt-2 text-sm text-[#9ca3af]">{tx?.date?.toLocaleString("en-IN") || "Date N/A"} • {tx?.paymentMethod || "N/A"}</p>
      </Panel>

      <Panel title="Details">
        <div className="space-y-2 text-sm">
          <div className="flex justify-between border-b border-[#2a2b2e] pb-2"><span className="text-[#9ca3af]">Category</span><span>{tx?.category || "N/A"}</span></div>
          <div className="flex justify-between border-b border-[#2a2b2e] pb-2"><span className="text-[#9ca3af]">Payment Method</span><span>{tx?.paymentMethod || "N/A"}</span></div>
          <div className="flex justify-between border-b border-[#2a2b2e] pb-2"><span className="text-[#9ca3af]">Note</span><span>{tx?.note || "No note"}</span></div>
        </div>
      </Panel>

      <Panel title="AI Insight">
        <p className="text-sm text-[#d1d5db]">You have spent ₹5,200 in shopping this month. Consider setting a weekly limit to stay within budget.</p>
      </Panel>

      <div className="flex gap-2"><button type="button" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Edit</button><button type="button" className="rounded-lg border border-[#7f1d1d] px-3 py-2 text-sm text-[#fca5a5]">Delete</button></div>
    </div>
  );
}
