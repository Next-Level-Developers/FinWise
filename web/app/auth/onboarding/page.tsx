"use client";

import { useMemo, useState } from "react";
import Link from "next/link";

const occupation = ["Salaried Employee", "Business Owner", "Student", "Freelancer"];
const income = ["Under 10K", "10K-25K", "25K-50K", "50K-1L", "1L-2L", "2L+"];
const goals = ["Buy a House", "Buy a Vehicle", "Emergency Fund", "Plan a Vacation", "Start Investing", "Education Fund"];
const languages = ["English", "Hindi", "Marathi", "Tamil", "Telugu", "Kannada", "Bengali", "Gujarati"];

export default function OnboardingPage() {
  const [step, setStep] = useState(1);
  const [selectedGoals, setSelectedGoals] = useState<string[]>([]);

  const stepTitle = useMemo(() => {
    if (step === 1) return "What best describes you?";
    if (step === 2) return "What is your monthly income?";
    if (step === 3) return "Pick your top 3 financial goals";
    return "Customize your FinWise experience";
  }, [step]);

  function toggleGoal(goal: string) {
    setSelectedGoals((prev) => {
      if (prev.includes(goal)) return prev.filter((g) => g !== goal);
      if (prev.length >= 3) return prev;
      return [...prev, goal];
    });
  }

  return (
    <div className="w-full max-w-2xl space-y-6 rounded-2xl border border-[#2a2b2e] bg-[#161719] p-6">
      <Link href="/auth/login" className="text-sm text-[#9ca3af] hover:text-[#f4f4f5]">Back</Link>
      <div className="grid grid-cols-4 gap-2">
        {[1, 2, 3, 4].map((index) => (
          <div key={index} className={`h-2 rounded-full ${step >= index ? "bg-[#4ade80]" : "bg-[#2a2b2e]"}`} />
        ))}
      </div>
      <h1 className="text-2xl font-semibold">{stepTitle}</h1>

      {step === 1 ? (
        <div className="grid gap-3 sm:grid-cols-2">
          {occupation.map((item) => (
            <button key={item} type="button" className="rounded-xl border border-[#2a2b2e] bg-[#111216] p-4 text-left hover:border-[#4ade80]">
              <p className="font-medium text-[#f4f4f5]">{item}</p>
            </button>
          ))}
        </div>
      ) : null}

      {step === 2 ? (
        <div className="space-y-2">
          {income.map((item) => (
            <label key={item} className="flex items-center justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm">
              {item}
              <input type="radio" name="income" />
            </label>
          ))}
          <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Optional exact amount" />
        </div>
      ) : null}

      {step === 3 ? (
        <div className="grid gap-3 sm:grid-cols-2">
          {goals.map((goal) => {
            const active = selectedGoals.includes(goal);
            const disabled = selectedGoals.length >= 3 && !active;
            return (
              <button
                key={goal}
                type="button"
                disabled={disabled}
                onClick={() => toggleGoal(goal)}
                className={`rounded-xl border p-4 text-left ${active ? "border-[#4ade80] bg-[#132217]" : "border-[#2a2b2e] bg-[#111216]"} ${disabled ? "opacity-40" : ""}`}
              >
                {goal}
              </button>
            );
          })}
        </div>
      ) : null}

      {step === 4 ? (
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-2 sm:grid-cols-4">
            {languages.map((lang) => (
              <button key={lang} type="button" className="rounded-md border border-[#2a2b2e] bg-[#111216] px-2 py-2 text-xs hover:border-[#4ade80]">{lang}</button>
            ))}
          </div>
          <label className="flex items-center justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm">
            Smart alerts
            <input type="checkbox" defaultChecked />
          </label>
        </div>
      ) : null}

      <div className="flex gap-2">
        <button type="button" onClick={() => setStep((s) => Math.max(1, s - 1))} className="rounded-lg border border-[#2a2b2e] px-4 py-2 text-sm">Back</button>
        {step < 4 ? (
          <button type="button" onClick={() => setStep((s) => Math.min(4, s + 1))} className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Continue</button>
        ) : (
          <button type="button" className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Complete Setup</button>
        )}
      </div>
    </div>
  );
}
