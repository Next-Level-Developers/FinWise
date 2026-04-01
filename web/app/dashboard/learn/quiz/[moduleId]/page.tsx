"use client";

import { useState } from "react";

export default function QuizPage() {
  const [selected, setSelected] = useState<string | null>(null);
  const [checked, setChecked] = useState(false);
  const answer = "B";

  return (
    <div className="mx-auto max-w-2xl space-y-4">
      <h1 className="text-2xl font-semibold">Quiz</h1>
      <div className="h-2 rounded bg-[#2a2b2e]"><div className="h-2 w-[30%] rounded bg-[#4ade80]" /></div>
      <div className="rounded-xl border border-[#2a2b2e] bg-[#161719] p-6">
        <p className="mb-4 text-lg">What does net pay represent?</p>
        {[
          ["A", "Total income before deductions"],
          ["B", "Final salary after deductions"],
          ["C", "Annual tax amount"],
          ["D", "Bonus amount"],
        ].map(([id, label]) => {
          const isCorrect = checked && id === answer;
          const isWrong = checked && selected === id && id !== answer;
          return (
            <button key={id} type="button" onClick={() => setSelected(id)} className={`mb-2 flex w-full items-center gap-3 rounded-lg border px-3 py-2 text-left ${isCorrect ? "border-[#4ade80] bg-[#132217]" : isWrong ? "border-[#f87171] bg-[#231314]" : selected === id ? "border-[#4ade80]" : "border-[#2a2b2e] bg-[#111216]"}`}>
              <span className="inline-flex h-6 w-6 items-center justify-center rounded-full bg-[#1d1f23] text-xs">{id}</span>
              <span>{label}</span>
            </button>
          );
        })}
        <button type="button" onClick={() => setChecked(true)} className="mt-2 rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Check Answer</button>
      </div>
    </div>
  );
}
