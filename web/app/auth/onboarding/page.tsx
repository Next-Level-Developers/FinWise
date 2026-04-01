"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { doc, serverTimestamp, setDoc } from "firebase/firestore";
import { auth, db } from "@/lib/firebase/client";
import { resolveUserId } from "@/lib/firebase/dashboard-data";

const occupation = ["Salaried Employee", "Business Owner", "Student", "Freelancer"];
const income = ["Under 10K", "10K-25K", "25K-50K", "50K-1L", "1L-2L", "2L+"];
const goals = ["Buy a House", "Buy a Vehicle", "Emergency Fund", "Plan a Vacation", "Start Investing", "Education Fund"];
const languages = ["English", "Hindi", "Marathi", "Tamil", "Telugu", "Kannada", "Bengali", "Gujarati"];

export default function OnboardingPage() {
  const router = useRouter();
  const [step, setStep] = useState(1);
  const [selectedOccupation, setSelectedOccupation] = useState<string>(occupation[0]);
  const [selectedIncome, setSelectedIncome] = useState<string>(income[0]);
  const [monthlyIncome, setMonthlyIncome] = useState("");
  const [selectedGoals, setSelectedGoals] = useState<string[]>([]);
  const [selectedLanguage, setSelectedLanguage] = useState<string>(languages[0]);
  const [smartAlerts, setSmartAlerts] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

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

  async function handleCompleteSetup() {
    setSaving(true);
    setError(null);

    try {
      const userId = auth.currentUser?.uid || resolveUserId();
      await setDoc(
        doc(db, "users", userId),
        {
          uid: userId,
          email: auth.currentUser?.email || null,
          displayName: auth.currentUser?.displayName || "FinWise User",
          occupationType: selectedOccupation.toLowerCase().includes("business")
            ? "business"
            : selectedOccupation.toLowerCase().includes("student")
              ? "student"
              : selectedOccupation.toLowerCase().includes("freelancer")
                ? "freelancer"
                : "salaried",
          incomeRange: selectedIncome.toLowerCase().includes("under")
            ? "0-10k"
            : selectedIncome.toLowerCase().includes("10k-25k")
              ? "10k-25k"
              : selectedIncome.toLowerCase().includes("25k-50k")
                ? "25k-50k"
                : selectedIncome.toLowerCase().includes("50k-1l")
                  ? "50k-100k"
                  : "100k+",
          monthlyIncome: monthlyIncome ? Number(monthlyIncome) : null,
          preferredLanguage: selectedLanguage.toLowerCase().slice(0, 2),
          topGoals: selectedGoals,
          isOnboardingComplete: true,
          currency: "INR",
          notificationsEnabled: smartAlerts,
          biometricEnabled: false,
          theme: "system",
          updatedAt: serverTimestamp(),
          lastActiveAt: serverTimestamp(),
          createdAt: serverTimestamp(),
        },
        { merge: true },
      );

      router.push("/dashboard/overview");
    } catch {
      setError("Could not complete setup. Please try again.");
    } finally {
      setSaving(false);
    }
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
            <button key={item} type="button" onClick={() => setSelectedOccupation(item)} className={`rounded-xl border bg-[#111216] p-4 text-left hover:border-[#4ade80] ${selectedOccupation === item ? "border-[#4ade80]" : "border-[#2a2b2e]"}`}>
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
              <input type="radio" name="income" checked={selectedIncome === item} onChange={() => setSelectedIncome(item)} />
            </label>
          ))}
          <input className="w-full rounded-lg border border-[#2a2b2e] bg-[#101114] px-3 py-2 text-sm" placeholder="Optional exact amount" value={monthlyIncome} onChange={(e) => setMonthlyIncome(e.target.value.replace(/\D/g, ""))} />
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
              <button key={lang} type="button" onClick={() => setSelectedLanguage(lang)} className={`rounded-md border bg-[#111216] px-2 py-2 text-xs hover:border-[#4ade80] ${selectedLanguage === lang ? "border-[#4ade80]" : "border-[#2a2b2e]"}`}>{lang}</button>
            ))}
          </div>
          <label className="flex items-center justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm">
            Smart alerts
            <input type="checkbox" checked={smartAlerts} onChange={(e) => setSmartAlerts(e.target.checked)} />
          </label>
        </div>
      ) : null}

      <div className="flex gap-2">
        <button type="button" onClick={() => setStep((s) => Math.max(1, s - 1))} className="rounded-lg border border-[#2a2b2e] px-4 py-2 text-sm">Back</button>
        {step < 4 ? (
          <button type="button" onClick={() => setStep((s) => Math.min(4, s + 1))} className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Continue</button>
        ) : (
          <button type="button" onClick={handleCompleteSetup} disabled={saving} className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:opacity-60">{saving ? "Saving..." : "Complete Setup"}</button>
        )}
      </div>
      {error ? <p className="text-xs text-[#f87171]">{error}</p> : null}
    </div>
  );
}
