"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Panel } from "@/components/ui/shell";
import { createBudget, generateAIBudget, getLatestBudget } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";
import { X } from "lucide-react";

const rows = ["Food", "Transport", "Shopping", "Health", "Entertainment", "Subscriptions", "Utilities", "Savings"];

export default function CreateBudgetPage() {
  const userId = useUserId();
  const router = useRouter();
  const [monthlyIncome, setMonthlyIncome] = useState("60000");
  const [limits, setLimits] = useState<Record<string, string>>(
    Object.fromEntries(rows.map((row) => [row, "3000"])),
  );
  const [saving, setSaving] = useState(false);
  const [suggesting, setSuggesting] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [showMessage, setShowMessage] = useState(true);

  useEffect(() => {
    async function preload() {
      const latest = await getLatestBudget(userId);
      if (!latest?.categoryLimits) return;

      const next = { ...limits };
      for (const row of rows) {
        const key = row.toLowerCase();
        if (latest.categoryLimits[key] != null) {
          next[row] = String(Math.round(latest.categoryLimits[key]));
        }
      }
      setLimits(next);
      if (latest.totalBudget) {
        setMonthlyIncome(String(Math.max(latest.totalBudget, Number(monthlyIncome || 0))));
      }
    }

    void preload();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [userId]);

  const totalBudget = useMemo(() => {
    return Object.values(limits).reduce((sum: number, value) => sum + Number(value || 0), 0);
  }, [limits]);

  async function handleSaveBudget() {
    setSaving(true);
    setMessage(null);
    setShowMessage(true);
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

  async function handleAISuggestBudget() {
    setSuggesting(true);
    setMessage(null);
    setShowMessage(true);
    try {
      const ai = await generateAIBudget(userId, Number(monthlyIncome || 0));
      const aiLimits = ai.categoryLimits || {};

      setLimits((prev: Record<string, string>) => {
        const next = { ...prev };
        for (const row of rows) {
          const key = row.toLowerCase();
          if (typeof aiLimits[key] === "number") {
            next[row] = String(Math.round(aiLimits[key]));
          }
        }
        return next;
      });

      if (ai.totalBudget) {
        setMonthlyIncome(String(Math.round(ai.totalBudget)));
      }

      setMessage(ai.reasoning || "AI budget suggestion generated.");
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Failed to generate AI budget suggestion.");
    } finally {
      setSuggesting(false);
    }
  }

  return (
    <div className="mx-auto max-w-4xl space-y-4">
      <Link href="/dashboard/budget" className="text-sm text-[#9ca3af]">Back to budget</Link>
      <Panel title="Create Monthly Budget" subtitle="Based on your previous spending trends">
        <div className="grid gap-2 sm:grid-cols-[1fr_auto]">
          <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Monthly Income" value={monthlyIncome} onChange={(e) => setMonthlyIncome(e.target.value.replace(/\D/g, ""))} />
          <button
            type="button"
            disabled={suggesting || !Number(monthlyIncome || 0)}
            onClick={() => void handleAISuggestBudget()}
            className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:cursor-not-allowed disabled:opacity-60"
          >
            {suggesting ? "Generating..." : "AI Suggest Budget"}
          </button>
        </div>

        <div className="mt-4 space-y-2">
          {rows.map((row) => (
            <div key={row} className="grid gap-2 rounded-lg border border-[#2a2b2e] bg-[#111216] p-3 sm:grid-cols-[120px_1fr_120px] sm:items-center">
              <p className="text-sm">{row}</p>
              <input 
                type="range" 
                min="0" 
                max={Math.max(10000, Number(monthlyIncome || 0))} 
                value={Number(limits[row] || 0)} 
                onChange={(e) => setLimits((prev: Record<string, string>) => ({ ...prev, [row]: e.target.value }))}
                className="w-full" 
              />
              <input className="rounded border border-[#2a2b2e] bg-[#161719] px-2 py-1 text-sm" value={limits[row] || "0"} onChange={(e) => setLimits((prev: Record<string, string>) => ({ ...prev, [row]: e.target.value.replace(/\D/g, "") }))} />
            </div>
          ))}
        </div>

        <p className="mt-3 text-sm text-[#9ca3af]">Total Budget: ₹{totalBudget.toLocaleString("en-IN")} | Income: ₹{Number(monthlyIncome || 0).toLocaleString("en-IN")}</p>
        <button type="button" onClick={handleSaveBudget} disabled={saving} className="mt-4 w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:opacity-60">{saving ? "Saving..." : "Save Budget"}</button>
        
        {message && showMessage ? (
          <div className="mt-4 rounded-lg border border-[#3b82f6]/30 bg-linear-to-r from-[#1e3a8a]/20 to-[#0c4a6e]/20 p-4 backdrop-blur-sm">
            <div className="flex items-start justify-between gap-3">
              <div>
                <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-[#60a5fa]">✨ AI Insight</p>
                <p className="text-sm leading-relaxed text-[#d1d5db]">{message}</p>
              </div>
              <button
                onClick={() => setShowMessage(false)}
                className="shrink-0 p-1 text-[#9ca3af] hover:text-[#ffffff] transition-colors"
              >
                <X size={18} />
              </button>
            </div>
          </div>
        ) : null}
      </Panel>
    </div>
  );
}
