import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

type Props = { params: Promise<{ id: string }> };

export default async function ExpertProfilePage({ params }: Props) {
  const { id } = await params;
  return (
    <div className="space-y-4">
      <Link href="/dashboard/experts" className="text-sm text-[#9ca3af]">Back to experts</Link>
      <Panel title={id.replace(/-/g, " ")} subtitle="Tax Planning • Investments" right={<Pill tone="green">Verified</Pill>}>
        <p className="text-sm text-[#9ca3af]">Rating 4.8 • 8 years experience • English, Hindi</p>
        <p className="mt-2 font-mono text-[#4ade80]">₹499 / 30 min</p>
        <Link href={`/dashboard/experts/${id}/book`} className="mt-3 inline-block rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Book a Session</Link>
      </Panel>
      <Panel title="About">Certified financial advisor focused on taxation, debt reduction, and practical monthly planning for young professionals.</Panel>
      <Panel title="Client Reviews"><div className="space-y-2 text-sm"><div className="rounded border border-[#2a2b2e] bg-[#111216] p-3">Very practical advice and clear tax planning roadmap.</div><div className="rounded border border-[#2a2b2e] bg-[#111216] p-3">Helped optimize SIPs and emergency fund strategy.</div></div></Panel>
    </div>
  );
}
