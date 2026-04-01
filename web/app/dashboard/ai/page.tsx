"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";
import { getRecentAIChats, getRecentVideoInsights } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

const tools = [
  ["Chat with FinWise AI", "Ask budget questions and get actionable advice.", "/dashboard/ai/chat"],
  ["YouTube Finance Insights", "Paste a video and get summary, tips, and actions.", "/dashboard/ai/video-insights"],
  ["AI Expense Analysis", "Understand category trends with AI commentary.", "/dashboard/ai/expense-breakdown"],
];

export default function AIHubPage() {
  const userId = useUserId();
  const [chatCount, setChatCount] = useState(0);
  const [insightCount, setInsightCount] = useState(0);

  useEffect(() => {
    async function loadAIData() {
      const [chats, insights] = await Promise.all([getRecentAIChats(userId), getRecentVideoInsights(userId)]);
      setChatCount(chats.length);
      setInsightCount(insights.length);
    }

    void loadAIData();
  }, [userId]);

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2"><h1 className="text-2xl font-semibold">AI Assistant</h1><Pill tone="blue">Powered by Gemini</Pill></div>
      <Panel title="Your Personal Finance AI" subtitle={`Recent chats: ${chatCount} • Saved video insights: ${insightCount}`}>
        <div className="grid gap-3 md:grid-cols-3">
          {tools.map(([title, desc, href]) => (
            <div key={title} className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-4">
              <p className="font-medium">{title}</p>
              <p className="mt-1 text-sm text-[#9ca3af]">{desc}</p>
              <Link href={href} className="mt-3 inline-block text-sm text-[#4ade80]">Open</Link>
            </div>
          ))}
        </div>
      </Panel>
    </div>
  );
}
