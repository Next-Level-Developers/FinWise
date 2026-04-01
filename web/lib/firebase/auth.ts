import { signInWithPopup, signOut, UserCredential } from "firebase/auth";
import { auth, googleProvider } from "@/lib/firebase/client";

export function signInWithGoogle(): Promise<UserCredential> {
  return signInWithPopup(auth, googleProvider);
}

export function signOutFirebase(): Promise<void> {
  return signOut(auth);
}
