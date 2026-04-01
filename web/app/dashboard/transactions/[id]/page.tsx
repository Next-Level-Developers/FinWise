import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";

type Props = { params: Promise<{ id: string }> };

export default async function TransactionDetailPage({ params }: Props) {
  const { id } = await params;

  return (
    <div className="mx-auto max-w-2xl space-y-4">
      <Link href="/dashboard/transactions" className="text-sm text-[#9ca3af]">Back to transactions</Link>

      <Panel title="Amazon Purchase" subtitle={`Transaction ID: ${id}`} right={<Pill tone="red">Expense</Pill>}>
        <p className="font-mono text-4xl text-[#f87171]">-₹2,399</p>
        <p className="mt-2 text-sm text-[#9ca3af]">20 Jul, 6:22 PM • Credit Card</p>
      </Panel>

      <Panel title="Details">
        <div className="space-y-2 text-sm">
          <div className="flex justify-between border-b border-[#2a2b2e] pb-2"><span className="text-[#9ca3af]">Category</span><span>Shopping</span></div>
          <div className="flex justify-between border-b border-[#2a2b2e] pb-2"><span className="text-[#9ca3af]">Payment Method</span><span>Credit Card</span></div>
          <div className="flex justify-between border-b border-[#2a2b2e] pb-2"><span className="text-[#9ca3af]">Note</span><span>Prime Day order</span></div>
        </div>
      </Panel>

      <Panel title="AI Insight">
        <p className="text-sm text-[#d1d5db]">You have spent ₹5,200 in shopping this month. Consider setting a weekly limit to stay within budget.</p>
      </Panel>

      <div className="flex gap-2"><button type="button" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Edit</button><button type="button" className="rounded-lg border border-[#7f1d1d] px-3 py-2 text-sm text-[#fca5a5]">Delete</button></div>
    </div>
  );
}
