"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { Panel } from "@/components/ui/shell";
import { getLessons, type Lesson } from "@/lib/firebase/dashboard-data";

export default function LessonPage() {
  const params = useParams<{ moduleId: string; lessonId: string }>();
  const moduleId = params.moduleId || "";
  const lessonId = params.lessonId || "";
  const [lesson, setLesson] = useState<Lesson | null>(null);

  useEffect(() => {
    async function loadLesson() {
      if (!moduleId) return;
      const lessons = await getLessons(moduleId);
      setLesson(lessons.find((item) => item.id === lessonId) || lessons[0] || null);
    }

    void loadLesson();
  }, [lessonId, moduleId]);

  return (
    <div className="grid gap-4 lg:grid-cols-[0.7fr_0.3fr]">
      <div className="space-y-4">
        <p className="text-sm text-[#9ca3af]"><Link href={`/dashboard/learn/${moduleId}`}>Module</Link> / {lessonId || "lesson"}</p>
        <Panel title={(lesson?.title || lessonId || "lesson").replace(/-/g, " ")} subtitle={`${Math.max(1, Math.round((lesson?.readTimeSec || 60) / 60))} min read`}>
          <div className="space-y-3 text-sm text-[#d1d5db]">
            <p>{lesson?.content || "Lesson content not available yet."}</p>
            <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-3"><p className="font-medium">Key formula</p><p className="font-mono">Net Pay = Gross Pay - Deductions</p></div>
            <p>Track PF, professional tax, and TDS deductions monthly to avoid surprises at year end.</p>
          </div>
        </Panel>
        <div className="flex gap-2"><button type="button" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Previous</button><button type="button" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Next</button><button type="button" className="rounded-lg bg-[#4ade80] px-3 py-2 text-sm font-semibold text-[#0e0f11]">Mark Complete</button></div>
      </div>
      <aside className="space-y-3">
        <Panel title="Progress"><p className="text-sm text-[#9ca3af]">Lesson 2 of 4</p></Panel>
        <Panel title="Take Notes"><textarea className="h-28 w-full rounded border border-[#2a2b2e] bg-[#111216] px-2 py-1 text-sm" placeholder="Write notes" /></Panel>
      </aside>
    </div>
  );
}
