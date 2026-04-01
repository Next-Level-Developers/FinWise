import Link from "next/link";
import { Panel } from "@/components/ui/shell";

type Props = { params: Promise<{ id: string }> };

export default async function ExpertBookingPage({ params }: Props) {
  const { id } = await params;
  return (
    <div className="mx-auto max-w-3xl space-y-4">
      <Link href={`/dashboard/experts/${id}`} className="text-sm text-[#9ca3af]">Back to profile</Link>
      <Panel title="Book Session" subtitle="Select date, time, and confirm payment">
        <div className="grid gap-2 sm:grid-cols-3">
          {['10:00 AM','11:30 AM','2:00 PM','4:30 PM'].map((slot) => <button key={slot} className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm hover:border-[#4ade80]">{slot}</button>)}
        </div>
        <textarea className="mt-3 h-24 w-full rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Topic you need help with" />
        <button type="button" className="mt-3 w-full rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Confirm and Pay ₹499</button>
      </Panel>
    </div>
  );
}
