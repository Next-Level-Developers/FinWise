"use client";

import { useEffect, useState } from "react";
import { onAuthStateChanged } from "firebase/auth";
import { auth } from "@/lib/firebase/client";
import { resolveUserId } from "@/lib/firebase/dashboard-data";

export function useUserId() {
  const [userId, setUserId] = useState(resolveUserId());

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, (user) => {
      setUserId(user?.uid || resolveUserId());
    });

    return () => unsub();
  }, []);

  return userId;
}
