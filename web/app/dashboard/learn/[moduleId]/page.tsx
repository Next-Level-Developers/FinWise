"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { Panel, Pill } from "@/components/ui/shell";
import {
  getLearningProgress,
  getLessons,
  type LearningProgress,
  type Lesson,
} from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

export default function ModulePage() {
  const params = useParams<{ moduleId: string }>();
  const moduleId = params.moduleId;
  const userId = useUserId();
  const [lessons, setLessons] = useState<Lesson[]>([]);
  const [moduleProgress, setModuleProgress] = useState<LearningProgress | null>(null);

  useEffect(() => {
    async function loadModule() {
      const [lessonData, progressData] = await Promise.all([getLessons(moduleId), getLearningProgress(userId)]);
      setLessons(lessonData);
      setModuleProgress(progressData.find((item) => item.moduleId === moduleId) || null);
    }

    void loadModule();
  }, [moduleId, userId]);

  const completedLessons = useMemo(() => {
    return moduleProgress?.status === "completed" ? lessons.length : Math.floor(((moduleProgress?.progressPercent || 0) / 100) * lessons.length);
  }, [lessons.length, moduleProgress]);

  return (
    <div className="space-y-4">
      <Link href="/dashboard/learn" className="text-sm text-[#9ca3af]">Back to learning</Link>
      <Panel title={moduleId.replace(/-/g, " ")} subtitle={`${lessons.length} lessons • ${Math.round(lessons.reduce((sum, item) => sum + (item.readTimeSec || 0), 0) / 60)} min total`} right={<Pill tone="amber">{moduleProgress?.progressPercent || 0}% Complete</Pill>}>
        <div className="h-2 rounded bg-[#2a2b2e]"><div className="h-2 rounded bg-[#4ade80]" style={{ width: `${moduleProgress?.progressPercent || 0}%` }} /></div>
        <div className="mt-4 space-y-2">
          {lessons.map((lesson, index) => (
            <div key={lesson.id} className={`flex items-center justify-between rounded border px-3 py-2 text-sm ${index === completedLessons ? "border-[#4ade80] bg-[#132217]" : "border-[#2a2b2e] bg-[#111216]"}`}>
              <span>{String(index + 1).padStart(2, "0")} • {lesson.title}</span>
              <span className="text-[#9ca3af]">{Math.max(1, Math.round((lesson.readTimeSec || 60) / 60))} min</span>
            </div>
          ))}
        </div>
      </Panel>
      <div className="flex gap-2"><Link href={`/dashboard/learn/${moduleId}/${lessons[completedLessons]?.id || lessons[0]?.id || "lesson"}`} className="rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Continue</Link><Link href={`/dashboard/learn/quiz/${moduleId}`} className="rounded-lg border border-[#2a2b2e] px-4 py-2 text-sm">Take Quiz</Link></div>
    </div>
  );
}
