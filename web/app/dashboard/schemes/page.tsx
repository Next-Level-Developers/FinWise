"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";
import { getSchemeList, getUserProfile, type Scheme } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

export default function SchemesPage() {
  const userId = useUserId();
  const [schemes, setSchemes] = useState<Scheme[]>([]);
  const [eligibilityTags, setEligibilityTags] = useState<string[]>([]);

  useEffect(() => {
    async function loadSchemes() {
      const [schemeData, profile] = await Promise.all([getSchemeList(), getUserProfile(userId)]);
      setSchemes(schemeData);
      setEligibilityTags(profile?.eligibilityTags || []);
    }

    void loadSchemes();
  }, [userId]);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold">Government Schemes</h1>
      <Panel title="Recommended for You" subtitle={`Based on eligibility tags: ${eligibilityTags.join(" • ") || "Not set"}`}>
        <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
          {schemes.map((scheme) => (
            <div key={scheme.id} className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-4">
              <p className="font-medium">{scheme.name}</p>
              <div className="mt-2 flex items-center gap-2"><Pill tone="blue">{scheme.benefitType || "scheme"}</Pill><Pill tone="green">Eligible</Pill></div>
              <p className="mt-2 text-sm text-[#9ca3af]">{scheme.maxBenefit || "Benefits available as per official guidelines"}</p>
              <Link href={`/dashboard/schemes/${scheme.id}`} className="mt-3 inline-block text-sm text-[#4ade80]">View Details</Link>
            </div>
          ))}
        </div>
      </Panel>
    </div>
  );
}
