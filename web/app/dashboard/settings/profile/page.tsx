import { Panel } from "@/components/ui/shell";

export default function SettingsProfilePage() {
  return (
    <Panel title="Profile Settings" subtitle="Update personal profile and financial preferences">
      <div className="grid gap-3 md:grid-cols-2">
        <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" defaultValue="Pushkar" />
        <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" defaultValue="pushkar@example.com" disabled />
        <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Phone Number" />
        <input type="date" className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" />
      </div>
      <button type="button" className="mt-4 rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Save Changes</button>
    </Panel>
  );
}
