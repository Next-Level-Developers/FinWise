"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { Panel, Pill } from "@/components/ui/shell";
import { getExpertById, type Expert } from "@/lib/firebase/dashboard-data";

export default function ExpertProfilePage() {
  const params = useParams<{ id: string }>();
  const [expert, setExpert] = useState<Expert | null>(null);

  useEffect(() => {
    async function loadExpert() {
      const data = await getExpertById(params.id);
      setExpert(data);
    }

    void loadExpert();
  }, [params.id]);

  return (
    <div className="space-y-4">
      <Link href="/dashboard/experts" className="text-sm text-[#9ca3af]">Back to experts</Link>
      <Panel title={expert?.name || params.id.replace(/-/g, " ")} subtitle={(expert?.specializations || ["Tax Planning", "Investments"]).join(" • ")} right={<Pill tone="green">Verified</Pill>}>
        <p className="text-sm text-[#9ca3af]">Rating {expert?.avgRating || "N/A"} • {expert?.experience || 0} years experience • {(expert?.languages || ["English", "Hindi"]).join(", ")}</p>
        <p className="mt-2 font-mono text-[#4ade80]">₹{expert?.sessionFeeINR || 0} / {expert?.sessionDurMins || 30} min</p>
        <Link href={`/dashboard/experts/${params.id}/book`} className="mt-3 inline-block rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Book a Session</Link>
      </Panel>
      <Panel title="About">{expert?.bio || "Certified financial advisor focused on taxation, debt reduction, and practical monthly planning for young professionals."}</Panel>
      <Panel title="Client Reviews"><div className="space-y-2 text-sm"><div className="rounded border border-[#2a2b2e] bg-[#111216] p-3">Very practical advice and clear tax planning roadmap.</div><div className="rounded border border-[#2a2b2e] bg-[#111216] p-3">Helped optimize SIPs and emergency fund strategy.</div></div></Panel>
    </div>
  );
}
