import Link from "next/link";
import { Panel } from "@/components/ui/shell";

type Props = { params: Promise<{ moduleId: string; lessonId: string }> };

export default async function LessonPage({ params }: Props) {
  const { moduleId, lessonId } = await params;
  return (
    <div className="grid gap-4 lg:grid-cols-[0.7fr_0.3fr]">
      <div className="space-y-4">
        <p className="text-sm text-[#9ca3af]"><Link href={`/dashboard/learn/${moduleId}`}>Module</Link> / {lessonId}</p>
        <Panel title={lessonId.replace(/-/g, " ")} subtitle="8 min read">
          <div className="space-y-3 text-sm text-[#d1d5db]">
            <p>Salary slips include gross pay, deductions, and net pay. Understanding each section helps plan taxes and savings better.</p>
            <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-3"><p className="font-medium">Key formula</p><p className="font-mono">Net Pay = Gross Pay - Deductions</p></div>
            <p>Track PF, professional tax, and TDS deductions monthly to avoid surprises at year end.</p>
          </div>
        </Panel>
        <div className="flex gap-2"><button type="button" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Previous</button><button type="button" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Next</button><button type="button" className="rounded-lg bg-[#4ade80] px-3 py-2 text-sm font-semibold text-[#0e0f11]">Mark Complete</button></div>
      </div>
      <aside className="space-y-3">
        <Panel title="Progress"><p className="text-sm text-[#9ca3af]">Lesson 2 of 4</p></Panel>
        <Panel title="Take Notes"><textarea className="h-28 w-full rounded border border-[#2a2b2e] bg-[#111216] px-2 py-1 text-sm" placeholder="Write notes" /></Panel>
      </aside>
    </div>
  );
}
