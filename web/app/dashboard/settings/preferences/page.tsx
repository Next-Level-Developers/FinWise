import { Panel } from "@/components/ui/shell";

export default function SettingsPreferencesPage() {
  return (
    <Panel title="App Preferences" subtitle="Customize appearance, language, notifications, and AI behavior">
      <div className="space-y-3">
        <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-3 text-sm">Theme: Dark Mode</div>
        <div className="rounded-lg border border-[#2a2b2e] bg-[#111216] p-3 text-sm">Language: English</div>
        <label className="flex items-center justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm">Budget Alerts<input type="checkbox" defaultChecked /></label>
        <label className="flex items-center justify-between rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm">AI Insights<input type="checkbox" defaultChecked /></label>
      </div>
      <button type="button" className="mt-4 rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Save Preferences</button>
    </Panel>
  );
}
