import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

type Props = { params: Promise<{ moduleId: string }> };

const lessons = [
  ["01", "Income Components", "5 min", "completed"],
  ["02", "Deductions Explained", "8 min", "current"],
  ["03", "Net Take Home", "6 min", "locked"],
  ["04", "Common Mistakes", "5 min", "locked"],
];

export default async function ModulePage({ params }: Props) {
  const { moduleId } = await params;
  return (
    <div className="space-y-4">
      <Link href="/dashboard/learn" className="text-sm text-[#9ca3af]">Back to learning</Link>
      <Panel title={moduleId.replace(/-/g, " ")} subtitle="4 lessons • 24 min total • 2,180 enrolled" right={<Pill tone="amber">42% Complete</Pill>}>
        <div className="h-2 rounded bg-[#2a2b2e]"><div className="h-2 w-[42%] rounded bg-[#4ade80]" /></div>
        <div className="mt-4 space-y-2">
          {lessons.map(([num, title, duration, state]) => (
            <div key={String(num)} className={`flex items-center justify-between rounded border px-3 py-2 text-sm ${state === "current" ? "border-[#4ade80] bg-[#132217]" : "border-[#2a2b2e] bg-[#111216]"}`}>
              <span>{num} • {title}</span>
              <span className="text-[#9ca3af]">{duration}</span>
            </div>
          ))}
        </div>
      </Panel>
      <div className="flex gap-2"><Link href={`/dashboard/learn/${moduleId}/lesson-2`} className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Continue</Link><Link href={`/dashboard/learn/quiz/${moduleId}`} className="rounded-lg border border-[#2a2b2e] px-4 py-2 text-sm">Take Quiz</Link></div>
    </div>
  );
}
