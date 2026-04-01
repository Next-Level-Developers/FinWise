"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { Panel, Pill } from "@/components/ui/shell";
import {
  getLearningModules,
  getLearningProgress,
  type LearningModule,
  type LearningProgress,
} from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

export default function LearnPage() {
  const userId = useUserId();
  const [modules, setModules] = useState<LearningModule[]>([]);
  const [progress, setProgress] = useState<LearningProgress[]>([]);

  useEffect(() => {
    async function loadLearning() {
      const [moduleData, progressData] = await Promise.all([getLearningModules(), getLearningProgress(userId)]);
      setModules(moduleData);
      setProgress(progressData);
    }

    void loadLearning();
  }, [userId]);

  const progressMap = useMemo(() => {
    return new Map(progress.map((item) => [item.moduleId, item]));
  }, [progress]);

  const completedCount = progress.filter((item) => item.status === "completed").length;

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between"><h1 className="text-2xl font-semibold">Financial Learning</h1><Pill tone="green">1240 XP</Pill></div>
      <Panel title="Your learning path: Salaried Employee" subtitle={`${completedCount} of ${Math.max(modules.length, 1)} modules completed`} right={<Link href="/dashboard/learn" className="text-sm text-[#4ade80]">Continue Learning</Link>}>
        <div className="h-2 rounded bg-[#2a2b2e]"><div className="h-2 rounded bg-[#4ade80]" style={{ width: `${modules.length ? Math.round((completedCount / modules.length) * 100) : 0}%` }} /></div>
      </Panel>
      <section className="grid gap-3 md:grid-cols-2">
        {modules.map((module) => {
          const state = progressMap.get(module.id);
          const status = state?.status || "new";

          return (
          <Panel key={module.id} title={module.title} right={<Pill tone={status === "completed" ? "green" : status === "new" ? "blue" : "amber"}>{status.replace("_", " ")}</Pill>}>
            <p className="text-sm text-[#9ca3af]">{module.lessonCount} lessons • {module.estimatedMins} min</p>
            <p className="mt-2 text-xs uppercase text-[#6b7280]">{module.difficulty}</p>
            <Link href={`/dashboard/learn/${module.id}`} className="mt-3 inline-block rounded-md border border-[#2a2b2e] px-2 py-1 text-xs">Open Module</Link>
          </Panel>
          );
        })}
      </section>
    </div>
  );
}
