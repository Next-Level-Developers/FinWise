import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

const modules = [
  ["Understanding Salary Slip", "6 lessons", "45 min", "In Progress", "beginner", "salary-slip"],
  ["Tax Basics for Salaried", "5 lessons", "35 min", "New", "beginner", "tax-basics"],
  ["Intro to Index Investing", "8 lessons", "60 min", "Completed", "intermediate", "index-investing"],
  ["Emergency Fund Strategy", "4 lessons", "25 min", "In Progress", "beginner", "emergency-fund"],
];

export default function LearnPage() {
  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between"><h1 className="text-2xl font-semibold">Financial Learning</h1><Pill tone="green">1240 XP</Pill></div>
      <Panel title="Your learning path: Salaried Employee" subtitle="35% of 12 modules completed" right={<Link href="/dashboard/learn/salary-slip" className="text-sm text-[#4ade80]">Continue Learning</Link>}>
        <div className="h-2 rounded bg-[#2a2b2e]"><div className="h-2 w-[35%] rounded bg-[#4ade80]" /></div>
      </Panel>
      <section className="grid gap-3 md:grid-cols-2">
        {modules.map(([title, lessons, mins, status, difficulty, slug]) => (
          <Panel key={title as string} title={title as string} right={<Pill tone={status === "Completed" ? "green" : status === "New" ? "blue" : "amber"}>{status}</Pill>}>
            <p className="text-sm text-[#9ca3af]">{lessons} • {mins}</p>
            <p className="mt-2 text-xs uppercase text-[#6b7280]">{difficulty}</p>
            <Link href={`/dashboard/learn/${slug}`} className="mt-3 inline-block rounded-md border border-[#2a2b2e] px-2 py-1 text-xs">Open Module</Link>
          </Panel>
        ))}
      </section>
    </div>
  );
}
