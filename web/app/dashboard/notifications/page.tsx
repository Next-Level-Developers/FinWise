"use client";

import { useEffect, useState } from "react";
import { Panel, Pill } from "@/components/ui/shell";
import { getNotifications, type AppNotification } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

function formatAgo(date?: Date) {
  if (!date) {
    return "recent";
  }
  const diffMins = Math.max(1, Math.floor((Date.now() - date.getTime()) / 60000));
  if (diffMins < 60) {
    return `${diffMins}m ago`;
  }
  const diffHours = Math.floor(diffMins / 60);
  if (diffHours < 24) {
    return `${diffHours}h ago`;
  }
  return `${Math.floor(diffHours / 24)}d ago`;
}

function toneFromType(type: string) {
  if (type.includes("warning") || type.includes("alert")) {
    return "red" as const;
  }
  if (type.includes("badge") || type.includes("milestone")) {
    return "green" as const;
  }
  if (type.includes("daily") || type.includes("reminder")) {
    return "amber" as const;
  }
  return "blue" as const;
}

export default function NotificationsPage() {
  const userId = useUserId();
  const [notices, setNotices] = useState<AppNotification[]>([]);

  useEffect(() => {
    async function loadNotices() {
      const data = await getNotifications(userId);
      setNotices(data);
    }

    void loadNotices();
  }, [userId]);

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between"><h1 className="text-2xl font-semibold">Notifications</h1><button type="button" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Mark all as read</button></div>
      <Panel title="All Notifications">
        <div className="space-y-2">
          {notices.map((notice) => (
            <div key={notice.id} className="flex items-start justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-3">
              <div>
                <p className="font-medium">{notice.title}</p>
                <p className="text-sm text-[#9ca3af]">{notice.body}</p>
              </div>
              <div className="text-right"><Pill tone={toneFromType(notice.type)}>{formatAgo(notice.createdAt)}</Pill></div>
            </div>
          ))}
        </div>
      </Panel>
    </div>
  );
}
