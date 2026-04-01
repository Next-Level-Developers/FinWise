import { Panel } from "@/components/ui/shell";

export default function SettingsSecurityPage() {
  return (
    <div className="space-y-4">
      <Panel title="Sign-in Method" subtitle="Connected with email and password">
        <button type="button" className="rounded-lg border border-[#2a2b2e] px-3 py-2 text-sm">Change Email</button>
      </Panel>
      <Panel title="Update Password">
        <div className="grid gap-2 sm:grid-cols-3">
          <input type="password" className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Current" />
          <input type="password" className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="New" />
          <input type="password" className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2 text-sm" placeholder="Confirm" />
        </div>
        <button type="button" className="mt-3 rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11]">Update Password</button>
      </Panel>
      <Panel title="Danger Zone" subtitle="Delete account and data export options">
        <button type="button" className="rounded-lg border border-[#7f1d1d] px-3 py-2 text-sm text-[#fca5a5]">Delete Account</button>
      </Panel>
    </div>
  );
}
