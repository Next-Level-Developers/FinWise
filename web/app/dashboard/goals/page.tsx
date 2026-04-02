"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";
import { getGoals, updateGoalAmount, type Goal } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";
import { X } from "lucide-react";

function currency(value: number) {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 0,
  }).format(value);
}

export default function GoalsPage() {
  const userId = useUserId();
  const [goals, setGoals] = useState<Goal[]>([]);
  const [editingGoalId, setEditingGoalId] = useState<string | null>(null);
  const [addAmount, setAddAmount] = useState<string>("");
  const [isAdding, setIsAdding] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadGoals() {
      const data = await getGoals(userId);
      setGoals(data);
    }

    void loadGoals();
  }, [userId]);

  async function handleAddMoney() {
    if (!editingGoalId || !addAmount.trim()) return;
    
    setIsAdding(true);
    setError(null);
    try {
      const amount = Number(addAmount);
      if (isNaN(amount) || amount <= 0) {
        setError("Please enter a valid amount");
        setIsAdding(false);
        return;
      }

      await updateGoalAmount(userId, editingGoalId, amount);
      const updated = await getGoals(userId);
      setGoals(updated);
      setEditingGoalId(null);
      setAddAmount("");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to add money");
    } finally {
      setIsAdding(false);
    }
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">My Financial Goals</h1>
        <Link href="/dashboard/goals/create" className="rounded-lg bg-[#4ade80] px-3 py-2 text-sm font-semibold text-[#0e0f11]">New Goal</Link>
      </div>

      <section className="grid gap-3 md:grid-cols-2">
        {goals.map((goal) => (
          <Panel key={goal.id} title={goal.title} right={<Pill tone={goal.status === "completed" ? "green" : goal.status === "active" ? "amber" : "neutral"}>{goal.status}</Pill>}>
            <p className="text-sm text-[#9ca3af]">Target: <span className="font-mono text-[#f4f4f5]">{currency(goal.targetAmount || 0)}</span></p>
            <p className="text-sm text-[#9ca3af]">Saved: <span className="font-mono text-[#f4f4f5]">{currency(goal.currentAmount || 0)}</span></p>
            <div className="mt-2 h-2 rounded bg-[#2a2b2e]"><div className="h-2 rounded bg-[#4ade80]" style={{ width: `${goal.progressPercent || 0}%` }} /></div>
            <div className="mt-3 flex gap-2"><button type="button" onClick={() => setEditingGoalId(goal.id)} className="rounded-md border border-[#2a2b2e] px-2 py-1 text-xs hover:bg-[#1e2022]">Add Money</button><Link href={`/dashboard/goals/${goal.id}`} className="rounded-md border border-[#2a2b2e] px-2 py-1 text-xs hover:bg-[#1e2022]">View Details</Link></div>
          </Panel>
        ))}
      </section>

      {editingGoalId ? (
        <div className="fixed inset-0 flex items-center justify-center bg-black/50 backdrop-blur-sm z-50">
          <div className="rounded-lg border border-[#2a2b2e] bg-[#161719] p-6 w-96">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-semibold">Add Money to Goal</h2>
              <button onClick={() => setEditingGoalId(null)} className="p-1 text-[#9ca3af] hover:text-[#ffffff]">
                <X size={20} />
              </button>
            </div>
            <div className="space-y-3">
              <input
                type="number"
                placeholder="Amount to add (₹)"
                value={addAmount}
                onChange={(e) => setAddAmount(e.target.value)}
                className="w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm"
              />
              {error && <p className="text-xs text-[#f87171]">{error}</p>}
              <div className="flex gap-2">
                <button
                  onClick={() => setEditingGoalId(null)}
                  className="flex-1 rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm font-semibold hover:bg-[#1e2022]"
                >
                  Cancel
                </button>
                <button
                  onClick={() => void handleAddMoney()}
                  disabled={isAdding || !addAmount.trim()}
                  className="flex-1 rounded-lg bg-[#4ade80] px-3 py-2 text-sm font-semibold text-[#0e0f11] disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  {isAdding ? "Adding..." : "Add"}
                </button>
              </div>
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
}
