"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";
import { getGoals, type Goal } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

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

  useEffect(() => {
    async function loadGoals() {
      const data = await getGoals(userId);
      setGoals(data);
    }

    void loadGoals();
  }, [userId]);

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
            <div className="mt-3 flex gap-2"><button type="button" className="rounded-md border border-[#2a2b2e] px-2 py-1 text-xs">Add Money</button><Link href={`/dashboard/goals/${goal.id}`} className="rounded-md border border-[#2a2b2e] px-2 py-1 text-xs">View Details</Link></div>
          </Panel>
        ))}
      </section>
    </div>
  );
}
