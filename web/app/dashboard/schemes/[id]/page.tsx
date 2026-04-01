"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { Panel, Pill } from "@/components/ui/shell";
import { getSchemeById, type Scheme } from "@/lib/firebase/dashboard-data";

export default function SchemeDetailPage() {
  const params = useParams<{ id: string }>();
  const [scheme, setScheme] = useState<Scheme | null>(null);

  useEffect(() => {
    async function loadScheme() {
      const data = await getSchemeById(params.id);
      setScheme(data);
    }

    void loadScheme();
  }, [params.id]);

  return (
    <div className="space-y-4">
      <Link href="/dashboard/schemes" className="text-sm text-[#9ca3af]">Back to schemes</Link>
      <Panel title={scheme?.name || params.id.toUpperCase()} subtitle={scheme?.ministry || "Government of India"} right={<Pill tone="green">{scheme?.isActive ? "Active" : "Inactive"}</Pill>}>
        <p className="text-sm text-[#d1d5db]">{scheme?.description || "This scheme supports eligible users with financial assistance and structured benefits."}</p>
        <a href={scheme?.officialURL || "#"} target="_blank" rel="noreferrer" className="mt-3 inline-block rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Apply on Official Site</a>
      </Panel>
      <Panel title="Eligibility"><ul className="space-y-1 text-sm text-[#9ca3af]">{(scheme?.eligibilityTags || ["Eligibility published in official circular"]).map((tag) => <li key={tag}>{tag}</li>)}</ul></Panel>
      <Panel title="How To Apply"><ol className="list-decimal space-y-1 pl-5 text-sm text-[#9ca3af]"><li>Check eligibility</li><li>Prepare documents</li><li>Apply online</li></ol></Panel>
    </div>
  );
}
