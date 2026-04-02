"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";
import {
  getLatestMonthlySummary,
  getRecentTransactions,
  getUserProfile,
  stringifyInsight,
  type MonthlySummary,
  type Transaction,
  type UserProfile,
} from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

function toCurrency(value: number) {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 0,
  }).format(value);
}

function txnLabel(tx: Transaction) {
  return tx.merchantName || tx.title || "Transaction";
}

export default function DashboardOverviewPage() {
  const userId = useUserId();
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [summary, setSummary] = useState<MonthlySummary | null>(null);
  const [transactions, setTransactions] = useState<Transaction[]>([]);

  useEffect(() => {
    async function loadOverview() {
      const [profileData, summaryData, txData] = await Promise.all([
        getUserProfile(userId),
        getLatestMonthlySummary(userId),
        getRecentTransactions(userId, 6),
      ]);

      setProfile(profileData);
      setSummary(summaryData);
      setTransactions(txData);
    }

    void loadOverview();
  }, [userId]);

  const stats = useMemo(
    () => [
      {
        label: "TOTAL SPENDINGS",
        value: toCurrency(summary?.totalExpense ?? profile?.currentMonthSpent ?? 0),
        delta: "Live",
        tone: "red" as const,
      },
      {
        label: "SAVINGS",
        value: toCurrency(summary?.totalSavings ?? profile?.totalSavings ?? 0),
        delta: "Live",
        tone: "amber" as const,
      },
      {
        label: "BUDGET",
        value: toCurrency(summary?.budgetAmount ?? profile?.currentMonthBudget ?? 0),
        delta: "This Month",
        tone: "green" as const,
      },
    ],
    [profile, summary],
  );

  const breakdown = summary?.categoryBreakdown ? Object.entries(summary.categoryBreakdown) : [];

  return (
    <div className="space-y-6">
      <section className="grid gap-4 md:grid-cols-3">
        {stats.map((stat) => (
          <Panel key={stat.label} title={stat.label} right={<Pill tone={stat.tone}>{stat.delta}</Pill>}>
            <p className="font-mono text-3xl font-semibold">{stat.value}</p>
            <div className="mt-4 grid h-16 grid-cols-7 items-end gap-1">
              {[35, 28, 45, 22, 31, 41, 26].map((h, i) => (
                <span key={i} className="rounded-sm bg-[#2a2b2e]" style={{ height: `${h}px` }} />
              ))}
            </div>
          </Panel>
        ))}
      </section>

      <section className="grid gap-4 lg:grid-cols-[0.4fr_0.6fr]">
        <Panel title="Transactions" subtitle="Recent activity" right={<Link href="/dashboard/transactions" className="text-xs text-[#4ade80]">View all</Link>}>
          <div className="space-y-2">
            {transactions.map((item) => {
              const amount = `${item.type === "expense" ? "-" : "+"}${toCurrency(item.amount)}`;
              const day = item.date
                ? item.date.toLocaleDateString("en-IN", { day: "2-digit", month: "short" }).toUpperCase()
                : "DATE N/A";

              return (
                <div key={item.id} className="flex items-center justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2">
                <div>
                  <p className="text-sm font-medium">{txnLabel(item)}</p>
                  <p className="text-xs text-[#6b7280]">{day} • {(item.category || item.type).toUpperCase()}</p>
                </div>
                <span className={`font-mono text-sm ${amount.startsWith("+") ? "text-[#4ade80]" : "text-[#f87171]"}`}>{amount}</span>
              </div>
              );
            })}
          </div>
        </Panel>

        <Panel title={`${toCurrency(summary?.totalExpense ?? 0)} Spent`} subtitle={summary?.month ? `${summary.month} view` : "Current month"}>
          <div className="grid h-56 grid-cols-7 items-end gap-2">
            {(breakdown.length > 0 ? breakdown.slice(0, 7).map(([, value]) => Math.max(24, Math.min(180, Math.round(value / 120)))) : [120, 90, 150, 130, 110, 160, 140]).map((h, i) => (
              <div key={i} className="rounded-t-md bg-linear-to-t from-[#2563eb] via-[#7c3aed] to-[#db2777]" style={{ height: `${h}px` }} />
            ))}
          </div>
          <p className="mt-3 text-xs text-[#9ca3af]">
            {breakdown.length > 0
              ? breakdown
                  .slice(0, 5)
                  .map(([name]) => name)
                  .join(" • ")
              : "Expenses • Transfers • Subscriptions • Grocery • Shopping"}
          </p>
        </Panel>
      </section>

      <Panel title="Your spending insight">
        <p className="text-sm text-[#d1d5db]">{stringifyInsight(summary?.aiInsightSummary) || "AI insight will appear here after enough transaction activity in this month."}</p>
      </Panel>
    </div>
  );
}
