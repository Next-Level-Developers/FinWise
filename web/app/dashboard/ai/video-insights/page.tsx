"use client";

import { useEffect, useState } from "react";
import { Panel, Pill } from "@/components/ui/shell";
import { analyzeVideoInsightFromUrl, getRecentVideoInsights, type VideoInsight } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

export default function VideoInsightsPage() {
  const userId = useUserId();
  const [insights, setInsights] = useState<VideoInsight[]>([]);
  const [videoURL, setVideoURL] = useState("");
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadInsights() {
      const data = await getRecentVideoInsights(userId);
      setInsights(data);
    }

    void loadInsights();
  }, [userId]);

  const latest = insights[0];

  async function handleAnalyze() {
    const trimmed = videoURL.trim();
    if (!trimmed || isAnalyzing) return;

    setError(null);
    setIsAnalyzing(true);

    try {
      const created = await analyzeVideoInsightFromUrl(userId, trimmed);
      setInsights((prev) => [created, ...prev.filter((item) => item.id !== created.id)].slice(0, 6));
      setVideoURL("");
    } catch (analyzeError) {
      setError(analyzeError instanceof Error ? analyzeError.message : "Failed to analyze video");
    } finally {
      setIsAnalyzing(false);
    }
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2"><h1 className="text-2xl font-semibold">YouTube Finance Insights</h1><Pill tone="blue">Powered by Groq AI</Pill></div>
      <Panel title="Analyze Video" subtitle="Paste a finance video URL and get instant summary">
        <div className="flex gap-2">
          <input
            value={videoURL}
            onChange={(event) => setVideoURL(event.target.value)}
            className="flex-1 rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm"
            placeholder="https://youtube.com/watch?v=..."
          />
          <button
            type="button"
            disabled={isAnalyzing || !videoURL.trim()}
            onClick={() => void handleAnalyze()}
            className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:cursor-not-allowed disabled:opacity-60"
          >
            {isAnalyzing ? "Analyzing..." : "Analyze"}
          </button>
        </div>
        {error ? <p className="mt-2 text-xs text-[#f87171]">{error}</p> : null}
      </Panel>
      <Panel title="Result" subtitle="Summary, key tips, and action points">
        <p className="text-sm text-[#d1d5db]">{latest?.summary || "Analyze a YouTube video to view summary, tips, and actions."}</p>
        <div className="mt-3 grid gap-3 md:grid-cols-2">
          <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-3"><p className="mb-2 font-medium">Key Financial Tips</p><ul className="space-y-1 text-sm text-[#9ca3af]">{(latest?.keyTips || ["Build emergency savings", "Stay consistent with SIP", "Track spending weekly"]).map((tip) => <li key={tip}>{tip}</li>)}</ul></div>
          <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-3"><p className="mb-2 font-medium">Action Points</p><ul className="space-y-1 text-sm text-[#9ca3af]">{(latest?.actionPoints || ["Review this month's expenses", "Set auto-invest date", "Define one saving target"]).map((point) => <li key={point}>{point}</li>)}</ul></div>
        </div>
      </Panel>
    </div>
  );
}
