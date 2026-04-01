import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

const goals = [
  ["Emergency Fund", "₹3,00,000", "₹1,52,000", 51, "On Track"],
  ["Vacation", "₹1,20,000", "₹45,000", 37, "At Risk"],
  ["Bike", "₹1,80,000", "₹1,65,000", 92, "On Track"],
];

export default function GoalsPage() {
  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">My Financial Goals</h1>
        <Link href="/dashboard/goals/create" className="rounded-lg bg-[#4ade80] px-3 py-2 text-sm font-semibold text-[#0e0f11]">New Goal</Link>
      </div>

      <section className="grid gap-3 md:grid-cols-2">
        {goals.map(([name, target, saved, progress, status]) => (
          <Panel key={name as string} title={name as string} right={<Pill tone={(status === "At Risk" ? "amber" : "green")}>{status}</Pill>}>
            <p className="text-sm text-[#9ca3af]">Target: <span className="font-mono text-[#f4f4f5]">{target}</span></p>
            <p className="text-sm text-[#9ca3af]">Saved: <span className="font-mono text-[#f4f4f5]">{saved}</span></p>
            <div className="mt-2 h-2 rounded bg-[#2a2b2e]"><div className="h-2 rounded bg-[#4ade80]" style={{ width: `${progress}%` }} /></div>
            <div className="mt-3 flex gap-2"><button type="button" className="rounded-md border border-[#2a2b2e] px-2 py-1 text-xs">Add Money</button><Link href={`/dashboard/goals/${String(name).toLowerCase().replace(/\s+/g, "-")}`} className="rounded-md border border-[#2a2b2e] px-2 py-1 text-xs">View Details</Link></div>
          </Panel>
        ))}
      </section>
    </div>
  );
}
