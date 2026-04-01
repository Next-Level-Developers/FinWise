"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Panel } from "@/components/ui/shell";
import { createTransaction } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

const categories = ["Food", "Transport", "Shopping", "Health", "Entertainment", "Bills", "Salary", "Investment"];

export default function AddTransactionPage() {
  const userId = useUserId();
  const router = useRouter();
  const [type, setType] = useState<"expense" | "income" | "transfer">("expense");
  const [amount, setAmount] = useState("");
  const [category, setCategory] = useState("Food");
  const [title, setTitle] = useState("");
  const [date, setDate] = useState(new Date().toISOString().slice(0, 10));
  const [paymentMethod, setPaymentMethod] = useState("upi");
  const [note, setNote] = useState("");
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  async function handleSave() {
    if (!amount || !title) {
      setMessage("Amount and description are required.");
      return;
    }
    setSaving(true);
    setMessage(null);
    try {
      const txId = await createTransaction(userId, {
        type,
        amount: Number(amount),
        category,
        title,
        note,
        paymentMethod,
        date,
      });
      setMessage("Transaction saved.");
      router.push(`/dashboard/transactions/${txId}`);
    } catch {
      setMessage("Failed to save transaction. Please try again.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="mx-auto max-w-3xl space-y-4">
      <Link href="/dashboard/transactions" className="text-sm text-[#9ca3af]">Back to transactions</Link>
      <Panel title="Add Transaction" subtitle="Capture a new expense, income, or transfer">
        <div className="space-y-4">
          <div className="grid grid-cols-3 gap-2">
            {(["expense", "income", "transfer"] as const).map((item) => (
              <button key={item} type="button" onClick={() => setType(item)} className={`rounded-lg border px-3 py-2 text-sm ${type === item ? "border-[#4ade80] bg-[#132217] text-[#86efac]" : "border-[#2a2b2e] bg-[#111216]"}`}>{item.toUpperCase()}</button>
            ))}
          </div>

          <div>
            <label className="text-xs text-[#9ca3af]">Amount</label>
            <input className="mt-1 w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-3 font-mono text-3xl" placeholder="₹ 0.00" value={amount} onChange={(e) => setAmount(e.target.value.replace(/[^0-9.]/g, ""))} />
          </div>

          <div className="grid gap-2 sm:grid-cols-4">
            {categories.map((item) => (
              <button
                key={item}
                type="button"
                onClick={() => setCategory(item)}
                className={`rounded-lg border bg-[#111216] px-2 py-2 text-sm hover:border-[#4ade80] ${category === item ? "border-[#4ade80]" : "border-[#2a2b2e]"}`}
              >
                {item}
              </button>
            ))}
          </div>

          <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Merchant or description" value={title} onChange={(e) => setTitle(e.target.value)} />
          <div className="grid gap-2 sm:grid-cols-2">
            <input type="date" className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" value={date} onChange={(e) => setDate(e.target.value)} />
            <select className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" value={paymentMethod} onChange={(e) => setPaymentMethod(e.target.value)}><option value="upi">UPI</option><option value="cash">Cash</option><option value="card_debit">Debit Card</option><option value="card_credit">Credit Card</option><option value="netbanking">Netbanking</option></select>
          </div>
          <textarea className="w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Add a note (optional)" rows={3} value={note} onChange={(e) => setNote(e.target.value)} />
          <div className="rounded-lg border border-dashed border-[#2a2b2e] bg-[#111216] p-5 text-center text-sm text-[#9ca3af]">Scan receipt with OCR</div>
          <button type="button" onClick={handleSave} disabled={saving} className="w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:opacity-60">{saving ? "Saving..." : "Save Transaction"}</button>
          {message ? <p className="text-sm text-[#9ca3af]">{message}</p> : null}
        </div>
      </Panel>
    </div>
  );
}
