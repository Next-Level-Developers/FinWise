"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";
import { getExperts, type Expert } from "@/lib/firebase/dashboard-data";

function feeLabel(expert: Expert) {
  return `₹${expert.sessionFeeINR || 0} / ${expert.sessionDurMins || 30} min`;
}

export default function ExpertsPage() {
  const [experts, setExperts] = useState<Expert[]>([]);

  useEffect(() => {
    async function loadExperts() {
      const data = await getExperts();
      setExperts(data);
    }

    void loadExperts();
  }, []);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold">Book a Financial Expert</h1>
      <Panel title="Featured Consultant" subtitle="Verified certified consultants">
        <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-4">
          <p className="text-lg font-semibold">{experts[0]?.name || "Top Consultant"}</p>
          <p className="text-sm text-[#9ca3af]">{(experts[0]?.specializations || []).join(" • ") || "Tax Planning • Investments"} • {(experts[0]?.languages || []).join(", ") || "Hindi, English"}</p>
        </div>
      </Panel>
      <section className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
        {experts.map((expert) => (
          <Panel key={expert.id} title={expert.name} right={<Pill tone="green">Verified</Pill>}>
            <p className="text-sm text-[#9ca3af]">{(expert.specializations || []).join(" • ") || "General Financial Advice"}</p>
            <p className="mt-2 text-sm">Rating {expert.avgRating || "N/A"} • {expert.experience || 0} years</p>
            <p className="mt-2 font-mono text-[#4ade80]">{feeLabel(expert)}</p>
            <Link href={`/dashboard/experts/${expert.id}`} className="mt-3 inline-block rounded-md bg-[#4ade80] px-3 py-1 text-xs font-semibold text-[#0e0f11]">View Profile</Link>
          </Panel>
        ))}
      </section>
    </div>
  );
}
