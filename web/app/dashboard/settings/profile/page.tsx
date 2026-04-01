"use client";

import { useEffect, useState } from "react";
import { Panel } from "@/components/ui/shell";
import { getUserProfile, updateProfile } from "@/lib/firebase/dashboard-data";
import { useUserId } from "@/lib/firebase/use-user-id";

export default function SettingsProfilePage() {
  const userId = useUserId();
  const [displayName, setDisplayName] = useState("");
  const [email, setEmail] = useState("");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  useEffect(() => {
    async function loadProfile() {
      const profile = await getUserProfile(userId);
      setDisplayName(profile?.displayName || "");
      setEmail(profile?.email || "");
      setPhoneNumber(profile?.phoneNumber || "");
    }

    void loadProfile();
  }, [userId]);

  async function handleSave() {
    setSaving(true);
    setMessage(null);
    try {
      await updateProfile(userId, { displayName, phoneNumber });
      setMessage("Profile updated successfully.");
    } catch {
      setMessage("Failed to update profile. Please try again.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <Panel title="Profile Settings" subtitle="Update personal profile and financial preferences">
      <div className="grid gap-3 md:grid-cols-2">
        <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" value={displayName} onChange={(e) => setDisplayName(e.target.value)} />
        <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" value={email} disabled />
        <input className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" placeholder="Phone Number" value={phoneNumber} onChange={(e) => setPhoneNumber(e.target.value)} />
        <input type="date" className="rounded-lg border border-[#2a2b2e] bg-[#111216] px-3 py-2" />
      </div>
      <button type="button" onClick={handleSave} disabled={saving} className="mt-4 rounded-lg bg-[#4ade80] px-4 py-2 text-sm font-semibold text-[#0e0f11] disabled:opacity-60">{saving ? "Saving..." : "Save Changes"}</button>
      {message ? <p className="mt-2 text-sm text-[#9ca3af]">{message}</p> : null}
    </Panel>
  );
}
