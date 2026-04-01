import { Panel, Pill } from "@/components/ui/shell";

const notices = [
  ["Budget Alert", "You exceeded your food budget by ₹1,200", "2h ago", "red"],
  ["AI Insight", "Your spending is 15% lower than last month", "5h ago", "green"],
  ["Reminder", "EMI due in 3 days - ₹8,400", "1d ago", "amber"],
  ["Goal Milestone", "You saved 50% toward emergency fund", "2d ago", "blue"],
];

export default function NotificationsPage() {
  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between"><h1 className="text-2xl font-semibold">Notifications</h1><button type="button" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Mark all as read</button></div>
      <Panel title="All Notifications">
        <div className="space-y-2">
          {notices.map(([title, desc, time, tone]) => (
            <div key={String(title)} className="flex items-start justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-3">
              <div>
                <p className="font-medium">{title}</p>
                <p className="text-sm text-[#9ca3af]">{desc}</p>
              </div>
              <div className="text-right"><Pill tone={tone as "green" | "red" | "amber" | "blue"}>{time}</Pill></div>
            </div>
          ))}
        </div>
      </Panel>
    </div>
  );
}
