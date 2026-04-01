"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Panel } from "@/components/ui/shell";
import { createBudget } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

const rows = ["Food", "Transport", "Shopping", "Health", "Entertainment", "Subscriptions", "Utilities", "Savings"];

export default function CreateBudgetPage() {
  const userId = useUserId();
  const router = useRouter();
  const [monthlyIncome, setMonthlyIncome] = useState("60000");
  const [limits, setLimits] = useState<Record<string, string>>(
    Object.fromEntries(rows.map((row) => [row, "3000"])),
  );
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  const totalBudget = useMemo(() => {
    return Object.values(limits).reduce((sum, value) => sum + Number(value || 0), 0);
  }, [limits]);

  async function handleSaveBudget() {
    setSaving(true);
    setMessage(null);
    try {
      const now = new Date();
      const month = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
      const categoryLimits = Object.fromEntries(rows.map((row) => [row.toLowerCase(), Number(limits[row] || 0)]));

      await createBudget(userId, {
        month,
        totalBudget,
        categoryLimits,
      });

      setMessage("Budget saved successfully.");
      router.push("/dashboard/budget");
    } catch {
      setMessage("Failed to save budget. Please try again.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="mx-auto max-w-4xl space-y-4">
      <Link href="/dashboard/budget" className="text-sm text-[#9ca3af]">Back to budget</Link>
      <Panel title="Create Monthly Budget" subtitle="Based on your previous spending trends">
        <div className="grid gap-2 sm:grid-cols-[1fr_auto]">
          <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Monthly Income" value={monthlyIncome} onChange={(e) => setMonthlyIncome(e.target.value.replace(/\D/g, ""))} />
          <button type="button" className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">AI Suggest Budget</button>
        </div>

        <div className="mt-4 space-y-2">
          {rows.map((row) => (
            <div key={row} className="grid gap-2 rounded-lg border border-[#2a2b2e] bg-[#111216] p-3 sm:grid-cols-[120px_1fr_120px] sm:items-center">
              <p className="text-sm">{row}</p>
              <input type="range" defaultValue={50} className="w-full" />
              <input className="rounded border border-[#2a2b2e] bg-[#161719] px-2 py-1 text-sm" value={limits[row] || "0"} onChange={(e) => setLimits((prev) => ({ ...prev, [row]: e.target.value.replace(/\D/g, "") }))} />
            </div>
          ))}
        </div>

        <p className="mt-3 text-sm text-[#9ca3af]">Total Budget: ₹{totalBudget.toLocaleString("en-IN")} | Income: ₹{Number(monthlyIncome || 0).toLocaleString("en-IN")}</p>
        <button type="button" onClick={handleSaveBudget} disabled={saving} className="mt-4 w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:opacity-60">{saving ? "Saving..." : "Save Budget"}</button>
        {message ? <p className="mt-2 text-sm text-[#9ca3af]">{message}</p> : null}
      </Panel>
    </div>
  );
}
