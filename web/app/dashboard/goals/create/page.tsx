"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Panel } from "@/components/ui/shell";
import { createGoal } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

const goalTypes = ["House", "Vehicle", "Vacation", "Emergency Fund", "Investment", "Education", "Wedding", "Custom"];

export default function CreateGoalPage() {
  const userId = useUserId();
  const router = useRouter();
  const [goalType, setGoalType] = useState("House");
  const [title, setTitle] = useState("");
  const [targetAmount, setTargetAmount] = useState("");
  const [currentAmount, setCurrentAmount] = useState("");
  const [targetDate, setTargetDate] = useState("");
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  async function handleCreateGoal() {
    if (!title || !targetAmount || !targetDate) {
      setMessage("Goal name, target amount and date are required.");
      return;
    }

    setSaving(true);
    setMessage(null);
    try {
      const goalId = await createGoal(userId, {
        title,
        category: goalType.toLowerCase().replace(/\s+/g, "_"),
        targetAmount: Number(targetAmount),
        currentAmount: Number(currentAmount || 0),
        targetDate,
      });
      setMessage("Goal created.");
      router.push(`/dashboard/goals/${goalId}`);
    } catch {
      setMessage("Failed to create goal. Please try again.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="mx-auto max-w-3xl space-y-4">
      <Link href="/dashboard/goals" className="text-sm text-[#9ca3af]">Back to goals</Link>
      <Panel title="Create New Goal" subtitle="Plan and track your target with milestones">
        <div className="grid gap-2 sm:grid-cols-4">
          {goalTypes.map((type) => (
            <button key={type} type="button" onClick={() => setGoalType(type)} className={`rounded-lg border bg-[#111216] px-2 py-2 text-xs hover:border-[#4ade80] ${goalType === type ? "border-[#4ade80]" : "border-[#2a2b2e]"}`}>{type}</button>
          ))}
        </div>
        <div className="mt-4 space-y-3">
          <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Goal Name" value={title} onChange={(e) => setTitle(e.target.value)} />
          <div className="grid gap-2 sm:grid-cols-2">
            <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Target Amount" value={targetAmount} onChange={(e) => setTargetAmount(e.target.value.replace(/\D/g, ""))} />
            <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Already Saved" value={currentAmount} onChange={(e) => setCurrentAmount(e.target.value.replace(/\D/g, ""))} />
          </div>
          <input type="date" className="w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" value={targetDate} onChange={(e) => setTargetDate(e.target.value)} />
          <button type="button" onClick={handleCreateGoal} disabled={saving} className="w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:opacity-60">{saving ? "Creating..." : "Create Goal"}</button>
          {message ? <p className="text-sm text-[#9ca3af]">{message}</p> : null}
        </div>
      </Panel>
    </div>
  );
}
