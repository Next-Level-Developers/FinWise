import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

const experts = [
  ["Aarav Sharma", "Tax Planning", "4.8", "8 years", "₹499", "aarav-sharma"],
  ["Meera Iyer", "Investments", "4.7", "10 years", "₹699", "meera-iyer"],
  ["Karan Mehta", "Retirement", "4.6", "7 years", "₹549", "karan-mehta"],
];

export default function ExpertsPage() {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold">Book a Financial Expert</h1>
      <Panel title="Featured Consultant" subtitle="Verified certified consultants">
        <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-4">
          <p className="text-lg font-semibold">Aarav Sharma</p>
          <p className="text-sm text-[#9ca3af]">Tax Planning • Investments • Hindi, English</p>
        </div>
      </Panel>
      <section className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
        {experts.map(([name, specialty, rating, exp, fee, slug]) => (
          <Panel key={name as string} title={name as string} right={<Pill tone="green">Verified</Pill>}>
            <p className="text-sm text-[#9ca3af]">{specialty}</p>
            <p className="mt-2 text-sm">Rating {rating} • {exp}</p>
            <p className="mt-2 font-mono text-[#4ade80]">{fee} / 30 min</p>
            <Link href={`/dashboard/experts/${slug}`} className="mt-3 inline-block rounded-md bg-[#4ade80] px-3 py-1 text-xs font-semibold text-[#0e0f11]">View Profile</Link>
          </Panel>
        ))}
      </section>
    </div>
  );
}
