import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

type Props = { params: Promise<{ id: string }> };

export default async function SchemeDetailPage({ params }: Props) {
  const { id } = await params;
  return (
    <div className="space-y-4">
      <Link href="/dashboard/schemes" className="text-sm text-[#9ca3af]">Back to schemes</Link>
      <Panel title={id.toUpperCase()} subtitle="Ministry of Finance" right={<Pill tone="green">Active</Pill>}>
        <p className="text-sm text-[#d1d5db]">This scheme supports eligible users with financial assistance and structured benefits.</p>
        <button type="button" className="mt-3 rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Apply on Official Site</button>
      </Panel>
      <Panel title="Eligibility"><ul className="space-y-1 text-sm text-[#9ca3af]"><li>Income criteria as per policy</li><li>Indian resident</li><li>Aadhaar-linked bank account</li></ul></Panel>
      <Panel title="How To Apply"><ol className="list-decimal space-y-1 pl-5 text-sm text-[#9ca3af]"><li>Check eligibility</li><li>Prepare documents</li><li>Apply online</li></ol></Panel>
    </div>
  );
}
