"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { Panel, Pill } from "@/components/ui/shell";
import { generateGoalAdvice, getGoalById, stringifyInsight, type Goal } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

function currency(value: number) {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 0,
  }).format(value);
}

export default function GoalDetailPage() {
  const params = useParams<{ id: string }>();
  const userId = useUserId();
  const [goal, setGoal] = useState<Goal | null>(null);
  const [isAdvising, setIsAdvising] = useState(false);
  const [adviceError, setAdviceError] = useState<string | null>(null);

  useEffect(() => {
    async function loadGoal() {
      const data = await getGoalById(userId, params.id);
      setGoal(data);
    }

    void loadGoal();
  }, [params.id, userId]);

  const remaining = Math.max(0, (goal?.targetAmount || 0) - (goal?.currentAmount || 0));

  async function handleGenerateAdvice() {
    if (!goal) return;
    setAdviceError(null);
    setIsAdvising(true);
    try {
      await generateGoalAdvice(userId, goal.id);
      const refreshed = await getGoalById(userId, goal.id);
      setGoal(refreshed);
    } catch (error) {
      setAdviceError(error instanceof Error ? error.message : "Failed to generate AI advice");
    } finally {
      setIsAdvising(false);
    }
  }

  return (
    <div className="space-y-4">
      <Link href="/dashboard/goals" className="text-sm text-[#9ca3af]">Back to goals</Link>
      <Panel title={goal?.title || params.id.replace(/-/g, " ")} subtitle={`Target: ${goal?.targetDate?.toLocaleDateString("en-IN", { month: "short", year: "numeric" }) || "TBD"}`} right={<Pill tone="green">{goal?.status || "active"}</Pill>}>
        <div className="grid gap-4 md:grid-cols-2">
          <div>
            <p className="font-mono text-3xl">{currency(goal?.currentAmount || 0)} / {currency(goal?.targetAmount || 0)}</p>
            <p className="mt-1 text-sm text-[#9ca3af]">{currency(remaining)} to go</p>
            <div className="mt-3 h-2 rounded bg-[#2a2b2e]"><div className="h-2 rounded bg-[#4ade80]" style={{ width: `${goal?.progressPercent || 0}%` }} /></div>
          </div>
          <div className="rounded-lg border border-[#3b82f6]/30 bg-linear-to-r from-[#1e3a8a]/20 to-[#0c4a6e]/20 p-4 text-sm leading-relaxed text-[#d1d5db] backdrop-blur-sm">
            <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-[#60a5fa]">💡 AI Insight</p>
            {stringifyInsight(goal?.aiSuggestion) || "Goal pace insight will appear after enough monthly updates."}
          </div>
        </div>
        <div className="mt-3 flex items-center gap-3">
          <button
            type="button"
            disabled={isAdvising}
            onClick={() => void handleGenerateAdvice()}
            className="rounded-md bg-[#4ade80] px-3 py-1 text-xs font-semibold text-[#0e0f11] disabled:cursor-not-allowed disabled:opacity-60"
          >
            {isAdvising ? "Generating..." : "Generate AI Advice"}
          </button>
          {adviceError ? <span className="text-xs text-[#f87171]">{adviceError}</span> : null}
        </div>
      </Panel>
      <Panel title="Contribution History">
        <div className="space-y-2 text-sm">
          <div className="flex justify-between rounded border border-[#2a2b2e] bg-[#111216] px-3 py-2"><span>Latest Saved Amount</span><span className="font-mono">{currency(goal?.currentAmount || 0)}</span></div>
          <div className="flex justify-between rounded border border-[#2a2b2e] bg-[#111216] px-3 py-2"><span>Monthly Target</span><span className="font-mono">{currency(Math.ceil(remaining / 6 || 0))}</span></div>
        </div>
      </Panel>
    </div>
  );
}
