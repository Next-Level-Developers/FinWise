"use client";

import { useEffect, useMemo, useState } from "react";
import { Panel } from "@/components/ui/shell";
import {
  generateExpenseInsights,
  generateExpensePrediction,
  getLatestMonthlySummary,
  stringifyInsight,
  type MonthlySummary,
} from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

function rupee(value: number) {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 0,
  }).format(value);
}

export default function ExpenseBreakdownPage() {
  const userId = useUserId();
  const [summary, setSummary] = useState<MonthlySummary | null>(null);
  const [isGenerating, setIsGenerating] = useState(false);
  const [isPredicting, setIsPredicting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [prediction, setPrediction] = useState<{ predictedTotalExpense?: number; confidence?: number; warnings?: string[] } | null>(null);

  useEffect(() => {
    async function loadSummary() {
      const data = await getLatestMonthlySummary(userId);
      setSummary(data);
    }

    void loadSummary();
  }, [userId]);

  const categories = useMemo(() => Object.entries(summary?.categoryBreakdown || {}), [summary]);

  async function handleGenerateInsights() {
    setError(null);
    setIsGenerating(true);
    try {
      await generateExpenseInsights(userId);
      const refreshed = await getLatestMonthlySummary(userId);
      setSummary(refreshed);
    } catch (generationError) {
      setError(generationError instanceof Error ? generationError.message : "Failed to generate insights");
    } finally {
      setIsGenerating(false);
    }
  }

  async function handlePredict() {
    setError(null);
    setIsPredicting(true);
    try {
      const result = await generateExpensePrediction(userId);
      setPrediction(result);
    } catch (predictionError) {
      setError(predictionError instanceof Error ? predictionError.message : "Failed to predict expenses");
    } finally {
      setIsPredicting(false);
    }
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between gap-3">
        <h1 className="text-2xl font-semibold">AI Expense Analysis</h1>
        <div className="flex gap-2">
          <button
            type="button"
            disabled={isPredicting || !summary}
            onClick={() => void handlePredict()}
            className="rounded-lg border border-[#2a2b2e] px-4 py-2 text-sm disabled:cursor-not-allowed disabled:opacity-60"
          >
            {isPredicting ? "Predicting..." : "Predict Next Month"}
          </button>
          <button
            type="button"
            disabled={isGenerating || !summary}
            onClick={() => void handleGenerateInsights()}
            className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:cursor-not-allowed disabled:opacity-60"
          >
            {isGenerating ? "Generating..." : "Generate AI Insights"}
          </button>
        </div>
      </div>

      {!summary ? (
        <Panel title="No Data Available">
          <p className="text-sm text-[#d1d5db]">Monthly summary data is not available yet. Please add some transactions first to generate insights.</p>
        </Panel>
      ) : (
        <>
          <Panel title={`AI Summary for ${summary?.month || "Current Month"}`}>
            <p className="text-sm text-[#d1d5db]">{stringifyInsight(summary?.aiInsightSummary) || "Click 'Generate AI Insights' to analyze your spending patterns."}</p>
            {error ? <p className="mt-2 text-xs text-[#f87171]">{error}</p> : null}
          </Panel>

          {prediction ? (
            <Panel title="Next Month Forecast">
              <p className="text-sm text-[#d1d5db]">
                Predicted Expense: {rupee(prediction.predictedTotalExpense || 0)}
                {prediction.confidence ? ` • Confidence: ${Math.round(prediction.confidence * 100)}%` : ""}
              </p>
              {prediction.warnings?.length ? (
                <ul className="mt-2 space-y-1 text-xs text-[#fbbf24]">
                  {prediction.warnings.map((item: unknown, index: number) => (
                    <li key={`${index}-${String(item)}`}>- {typeof item === "string" ? item : stringifyInsight(item)}</li>
                  ))}
                </ul>
              ) : null}
            </Panel>
          ) : null}

          <section className="grid gap-4 lg:grid-cols-2">
            <Panel title="Category Breakdown">
              <div className="grid h-48 grid-cols-5 items-end gap-2">
                {(categories.length
                  ? categories.slice(0, 5).map(([, value]: [string, unknown]) => Math.max(20, Math.min(100, Math.round((value as number) / 100))))
                  : [70, 45, 55, 35, 50]
                ).map((h: number, i: number) => (
                  <div key={i} className="rounded-t bg-[#2563eb]" style={{ height: `${h * 2}px` }} />
                ))}
              </div>
            </Panel>
            <Panel title="Category Ranking">
              <div className="space-y-2">
                {(categories.length
                  ? categories.sort((a: [string, unknown], b: [string, unknown]) => (b[1] as number) - (a[1] as number)).slice(0, 4)
                  : ([["shopping", 5100], ["food", 7200], ["transport", 2450], ["bills", 3200]] as [string, number][])
                ).map(([n, v]: [string, number]) => (
                  <div key={n} className="flex items-center justify-between rounded border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm">
                    <span>{n}</span>
                    <span className="font-mono">{rupee(Number(v))}</span>
                  </div>
                ))}
              </div>
            </Panel>
          </section>

          <Panel title="Month Over Month">
            <table className="w-full text-sm">
              <thead className="text-left text-[#9ca3af]">
                <tr>
                  <th>Category</th>
                  <th>Last Month</th>
                  <th>This Month</th>
                  <th>Change</th>
                </tr>
              </thead>
              <tbody>
                {categories.map(([name, value]: [string, unknown]) => (
                  <tr key={name} className="border-t border-[#2a2b2e]">
                    <td className="py-2">{name}</td>
                    <td>{rupee(Math.max(0, (value as number) - Math.round((value as number) * 0.2)))}</td>
                    <td>{rupee(value as number)}</td>
                    <td className="text-[#f87171]">+{rupee(Math.round((value as number) * 0.2))}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </Panel>
        </>
      )}
    </div>
  );
}
