import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

type Props = { params: Promise<{ id: string }> };

export default async function GoalDetailPage({ params }: Props) {
  const { id } = await params;
  return (
    <div className="space-y-4">
      <Link href="/dashboard/goals" className="text-sm text-[#9ca3af]">Back to goals</Link>
      <Panel title={id.replace(/-/g, " ")} subtitle="Target: Dec 2026" right={<Pill tone="green">On Track</Pill>}>
        <div className="grid gap-4 md:grid-cols-2">
          <div>
            <p className="font-mono text-3xl">₹1,52,000 / ₹3,00,000</p>
            <p className="mt-1 text-sm text-[#9ca3af]">₹1,48,000 to go</p>
            <div className="mt-3 h-2 rounded bg-[#2a2b2e]"><div className="h-2 w-[51%] rounded bg-[#4ade80]" /></div>
          </div>
          <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-4 text-sm text-[#9ca3af]">At your current pace, you can finish by Nov 2026. Add ₹12,500 per month to reach earlier.</div>
        </div>
      </Panel>
      <Panel title="Contribution History">
        <div className="space-y-2 text-sm">
          {[['Jul 20','₹12,000'],['Jun 20','₹9,000'],['May 20','₹8,000']].map(([date,amt]) => <div key={date} className="flex justify-between rounded border border-[#2a2b2e] bg-[#111216] px-3 py-2"><span>{date}</span><span className="font-mono">{amt}</span></div>)}
        </div>
      </Panel>
    </div>
  );
}
