import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

const schemes = [
  ["PMEGP", "Loan", "Up to ₹10 Lakhs", "pmegp"],
  ["PMJJBY", "Insurance", "₹2 Lakhs cover", "pmjjby"],
  ["Atal Pension Yojana", "Pension", "Monthly pension", "apy"],
  ["PM Kisan", "Subsidy", "₹6,000 yearly", "pm-kisan"],
];

export default function SchemesPage() {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold">Government Schemes</h1>
      <Panel title="Recommended for You" subtitle="Based on: Salaried • ₹25K-50K • Maharashtra">
        <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
          {schemes.map(([name, type, benefit, slug]) => (
            <div key={name} className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-4">
              <p className="font-medium">{name}</p>
              <div className="mt-2 flex items-center gap-2"><Pill tone="blue">{type}</Pill><Pill tone="green">Eligible</Pill></div>
              <p className="mt-2 text-sm text-[#9ca3af]">{benefit}</p>
              <Link href={`/dashboard/schemes/${slug}`} className="mt-3 inline-block text-sm text-[#4ade80]">View Details</Link>
            </div>
          ))}
        </div>
      </Panel>
    </div>
  );
}
