import { Panel, Pill } from "@/components/ui/shell";

export default function VideoInsightsPage() {
  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2"><h1 className="text-2xl font-semibold">YouTube Finance Insights</h1><Pill tone="blue">Powered by Gemini AI</Pill></div>
      <Panel title="Analyze Video" subtitle="Paste a finance video URL and get instant summary">
        <div className="flex gap-2"><input className="flex-1 rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="https://youtube.com/watch?v=..." /><button type="button" className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Analyze</button></div>
      </Panel>
      <Panel title="Result" subtitle="Summary, key tips, and action points">
        <p className="text-sm text-[#d1d5db]">This video explains the importance of emergency funds, reducing impulsive purchases, and automating investments for long-term wealth growth.</p>
        <div className="mt-3 grid gap-3 md:grid-cols-2">
          <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-3"><p className="mb-2 font-medium">Key Financial Tips</p><ul className="space-y-1 text-sm text-[#9ca3af]"><li>Build 6-month emergency buffer</li><li>Use 50/30/20 monthly split</li><li>Increase SIP yearly by 10%</li></ul></div>
          <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-3"><p className="mb-2 font-medium">Action Points</p><ul className="space-y-1 text-sm text-[#9ca3af]"><li>Review fixed expenses this week</li><li>Set auto-invest date</li><li>Create debt payoff tracker</li></ul></div>
        </div>
      </Panel>
    </div>
  );
}
