import Link from "next/link";
import { Panel } from "@/components/ui/shell";

const goalTypes = ["House", "Vehicle", "Vacation", "Emergency Fund", "Investment", "Education", "Wedding", "Custom"];

export default function CreateGoalPage() {
  return (
    <div className="mx-auto max-w-3xl space-y-4">
      <Link href="/dashboard/goals" className="text-sm text-[#9ca3af]">Back to goals</Link>
      <Panel title="Create New Goal" subtitle="Plan and track your target with milestones">
        <div className="grid gap-2 sm:grid-cols-4">
          {goalTypes.map((type) => (
            <button key={type} type="button" className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-2 py-2 text-xs hover:border-[#4ade80]">{type}</button>
          ))}
        </div>
        <div className="mt-4 space-y-3">
          <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Goal Name" />
          <div className="grid gap-2 sm:grid-cols-2">
            <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Target Amount" defaultValue="₹2,00,000" />
            <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Already Saved" defaultValue="₹40,000" />
          </div>
          <input type="date" className="w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" />
          <button type="button" className="w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Create Goal</button>
        </div>
      </Panel>
    </div>
  );
}
