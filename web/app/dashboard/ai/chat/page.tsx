"use client";

import { useState } from "react";

export default function AIChatPage() {
  const [input, setInput] = useState("");

  return (
    <div className="grid h-[calc(100vh-130px)] gap-3 lg:grid-cols-[0.3fr_0.7fr]">
      <aside className="rounded-xl border border-[#2a2b2e] bg-[#161719] p-3">
        <div className="mb-3 flex items-center justify-between"><p className="font-semibold">AI Chat</p><button type="button" className="rounded border border-[#2a2b2e] px-2 py-1 text-xs">New</button></div>
        <input className="mb-2 w-full rounded border border-[#2a2b2e] bg-[#111216] px-2 py-1 text-sm" placeholder="Search chats" />
        {['Can I afford vacation?','How to save more?','Tax saving tips'].map((item) => <button key={item} className="mb-1 block w-full rounded border border-[#2a2b2e] bg-[#111216] px-2 py-2 text-left text-xs text-[#9ca3af]">{item}</button>)}
      </aside>

      <section className="flex flex-col rounded-xl border border-[#2a2b2e] bg-[#161719] p-3">
        <p className="mb-2 text-xs text-[#9ca3af]">Context: Salaried • ₹45K/month • 2 goals active</p>
        <div className="flex-1 space-y-2 overflow-auto">
          <div className="mr-auto max-w-[80%] rounded-xl border-l-2 border-[#4ade80] bg-[#1e2022] px-3 py-2 text-sm">You can reduce your dining spend by 15% to save around ₹1,800 this month.</div>
          <div className="ml-auto max-w-[80%] rounded-xl bg-[#1a3a2a] px-3 py-2 text-sm">How much should I save for an emergency fund?</div>
          <div className="mr-auto max-w-[80%] rounded-xl border-l-2 border-[#4ade80] bg-[#1e2022] px-3 py-2 text-sm">Aim for 4-6 months of expenses. Start with ₹50,000 as your first milestone.</div>
        </div>
        <div className="mt-3 flex gap-2">
          <textarea value={input} onChange={(e) => setInput(e.target.value)} placeholder="Ask me about your finances..." className="h-20 flex-1 rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" />
          <button type="button" className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Send</button>
        </div>
      </section>
    </div>
  );
}
