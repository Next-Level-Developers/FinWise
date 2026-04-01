import { auth, db } from "@/lib/firebase/client";
import {
  addDoc,
  collection,
  doc,
  documentId,
  getDoc,
  getDocs,
  limit,
  orderBy,
  query,
  serverTimestamp,
  setDoc,
  Timestamp,
  updateDoc,
  where,
  type QueryDocumentSnapshot,
} from "firebase/firestore";

const FALLBACK_USER_ID = process.env.NEXT_PUBLIC_SEED_USER_ID || "vyoLjyxGixbUz4BILtabL8O4bDD3";

type FirestoreDateLike = { toDate: () => Date } | Date | null | undefined;

export type UserProfile = {
  uid: string;
  displayName?: string;
  email?: string;
  phoneNumber?: string | null;
  occupationType?: string;
  incomeRange?: string;
  currentMonthBudget?: number | null;
  currentMonthSpent?: number;
  totalSavings?: number;
  eligibilityTags?: string[];
};

export type MonthlySummary = {
  id: string;
  month: string;
  totalIncome: number;
  totalExpense: number;
  totalSavings: number;
  budgetAmount?: number | null;
  aiInsightSummary?: string | null;
  categoryBreakdown?: Record<string, number>;
};

export type Transaction = {
  id: string;
  type: "expense" | "income" | "transfer";
  amount: number;
  category?: string;
  title?: string;
  merchantName?: string | null;
  paymentMethod?: string;
  note?: string | null;
  date?: Date;
};

export type Goal = {
  id: string;
  title: string;
  targetAmount: number;
  currentAmount: number;
  progressPercent: number;
  status: string;
  targetDate?: Date;
  aiSuggestion?: string | null;
};

export type AppNotification = {
  id: string;
  type: string;
  title: string;
  body: string;
  isRead: boolean;
  createdAt?: Date;
};

export type LearningModule = {
  id: string;
  title: string;
  lessonCount: number;
  estimatedMins: number;
  difficulty: string;
  totalEnrollments?: number;
};

export type LearningProgress = {
  moduleId: string;
  progressPercent: number;
  status: string;
};

export type Lesson = {
  id: string;
  title: string;
  content: string;
  sortOrder: number;
  readTimeSec?: number;
};

export type Quiz = {
  id: string;
  questions: Array<{
    id: string;
    questionText: string;
    options: string[];
    correctIndex: number;
    explanation?: string;
  }>;
};

export type Scheme = {
  id: string;
  name: string;
  ministry?: string;
  benefitType?: string;
  maxBenefit?: string;
  eligibilityTags?: string[];
  isActive?: boolean;
  description?: string;
  officialURL?: string;
};

export type Expert = {
  id: string;
  name: string;
  designation?: string;
  specializations?: string[];
  languages?: string[];
  bio?: string;
  experience?: number;
  sessionFeeINR?: number;
  sessionDurMins?: number;
  avgRating?: number;
  isActive?: boolean;
};

export type AIChat = {
  id: string;
  title: string;
  mode?: string;
  lastMessageAt?: Date;
};

export type VideoInsight = {
  id: string;
  videoURL?: string;
  videoTitle?: string;
  summary?: string;
  keyTips?: string[];
  actionPoints?: string[];
};

export type NewTransactionInput = {
  type: "expense" | "income" | "transfer";
  amount: number;
  category: string;
  title: string;
  note?: string;
  paymentMethod: string;
  date: string;
};

export type NewBudgetInput = {
  month: string;
  totalBudget: number;
  categoryLimits: Record<string, number>;
};

export type NewGoalInput = {
  title: string;
  category: string;
  targetAmount: number;
  currentAmount: number;
  targetDate: string;
};

export type ProfileUpdateInput = {
  displayName?: string;
  phoneNumber?: string;
};

function parseDate(value: FirestoreDateLike): Date | undefined {
  if (!value) {
    return undefined;
  }
  if (value instanceof Date) {
    return value;
  }
  if (typeof value === "object" && "toDate" in value && typeof value.toDate === "function") {
    return value.toDate();
  }
  return undefined;
}

function mapDoc<T>(snap: QueryDocumentSnapshot): T {
  return { id: snap.id, ...snap.data() } as T;
}

function monthKey(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  return `${year}-${month}`;
}

export function resolveUserId(): string {
  return auth.currentUser?.uid || FALLBACK_USER_ID;
}

export async function getUserProfile(userId: string): Promise<UserProfile | null> {
  const userSnap = await getDoc(doc(db, "users", userId));
  if (!userSnap.exists()) {
    return null;
  }
  return userSnap.data() as UserProfile;
}

export async function getLatestMonthlySummary(userId: string): Promise<MonthlySummary | null> {
  const monthlyRef = collection(db, "users", userId, "monthly_summaries");
  const monthlySnap = await getDocs(query(monthlyRef, orderBy(documentId(), "desc"), limit(1)));
  if (monthlySnap.empty) {
    return null;
  }
  return mapDoc<MonthlySummary>(monthlySnap.docs[0]);
}

export async function getRecentTransactions(userId: string, take = 20): Promise<Transaction[]> {
  const txRef = collection(db, "users", userId, "transactions");
  const txSnap = await getDocs(query(txRef, orderBy("date", "desc"), limit(take)));
  return txSnap.docs.map((snap) => {
    const tx = mapDoc<Transaction>(snap);
    return {
      ...tx,
      date: parseDate((snap.data() as { date?: FirestoreDateLike }).date),
    };
  });
}

export async function getTransactionById(userId: string, id: string): Promise<Transaction | null> {
  const txSnap = await getDoc(doc(db, "users", userId, "transactions", id));
  if (!txSnap.exists()) {
    return null;
  }
  const tx = txSnap.data() as Transaction;
  return {
    ...tx,
    id: txSnap.id,
    date: parseDate((txSnap.data() as { date?: FirestoreDateLike }).date),
  };
}

export async function getGoals(userId: string): Promise<Goal[]> {
  const goalsRef = collection(db, "users", userId, "goals");
  const goalsSnap = await getDocs(query(goalsRef, orderBy("updatedAt", "desc")));
  return goalsSnap.docs.map((snap) => {
    const goal = mapDoc<Goal>(snap);
    return {
      ...goal,
      targetDate: parseDate((snap.data() as { targetDate?: FirestoreDateLike }).targetDate),
    };
  });
}

export async function getGoalById(userId: string, id: string): Promise<Goal | null> {
  const snap = await getDoc(doc(db, "users", userId, "goals", id));
  if (!snap.exists()) {
    return null;
  }
  const goal = snap.data() as Goal;
  return {
    ...goal,
    id: snap.id,
    targetDate: parseDate((snap.data() as { targetDate?: FirestoreDateLike }).targetDate),
  };
}

export async function getNotifications(userId: string, take = 25): Promise<AppNotification[]> {
  const notifRef = collection(db, "users", userId, "notifications");
  const notifSnap = await getDocs(query(notifRef, orderBy("createdAt", "desc"), limit(take)));
  return notifSnap.docs.map((snap) => {
    const item = mapDoc<AppNotification>(snap);
    return {
      ...item,
      createdAt: parseDate((snap.data() as { createdAt?: FirestoreDateLike }).createdAt),
    };
  });
}

export async function getLearningModules(): Promise<LearningModule[]> {
  const modulesRef = collection(db, "learning_modules");
  const modulesSnap = await getDocs(query(modulesRef, where("isPublished", "==", true), orderBy("sortOrder", "asc")));
  return modulesSnap.docs.map((snap) => mapDoc<LearningModule>(snap));
}

export async function getLearningProgress(userId: string): Promise<LearningProgress[]> {
  const progressRef = collection(db, "users", userId, "learning_progress");
  const progressSnap = await getDocs(progressRef);
  return progressSnap.docs.map((snap) => mapDoc<LearningProgress>(snap));
}

export async function getLessons(moduleId: string): Promise<Lesson[]> {
  const lessonsRef = collection(db, "learning_modules", moduleId, "lessons");
  const lessonsSnap = await getDocs(query(lessonsRef, orderBy("sortOrder", "asc")));
  return lessonsSnap.docs.map((snap) => mapDoc<Lesson>(snap));
}

export async function getModuleQuiz(moduleId: string): Promise<Quiz | null> {
  const quizRef = collection(db, "learning_modules", moduleId, "quizzes");
  const quizSnap = await getDocs(query(quizRef, limit(1)));
  if (quizSnap.empty) {
    return null;
  }
  return mapDoc<Quiz>(quizSnap.docs[0]);
}

export async function getSchemeList(): Promise<Scheme[]> {
  const schemesRef = collection(db, "government_schemes");
  const schemesSnap = await getDocs(query(schemesRef, where("isActive", "==", true), limit(20)));
  return schemesSnap.docs.map((snap) => mapDoc<Scheme>(snap));
}

export async function getSchemeById(id: string): Promise<Scheme | null> {
  const snap = await getDoc(doc(db, "government_schemes", id));
  if (!snap.exists()) {
    return null;
  }
  return { id: snap.id, ...(snap.data() as Omit<Scheme, "id">) };
}

export async function getExperts(): Promise<Expert[]> {
  const expertsRef = collection(db, "expert_consultants");
  const expertsSnap = await getDocs(query(expertsRef, where("isActive", "==", true), limit(20)));
  return expertsSnap.docs.map((snap) => mapDoc<Expert>(snap));
}

export async function getExpertById(id: string): Promise<Expert | null> {
  const snap = await getDoc(doc(db, "expert_consultants", id));
  if (!snap.exists()) {
    return null;
  }
  return { id: snap.id, ...(snap.data() as Omit<Expert, "id">) };
}

export async function getRecentAIChats(userId: string): Promise<AIChat[]> {
  const chatsRef = collection(db, "users", userId, "ai_chats");
  const chatsSnap = await getDocs(query(chatsRef, where("isArchived", "==", false), orderBy("lastMessageAt", "desc"), limit(12)));
  return chatsSnap.docs.map((snap) => {
    const chat = mapDoc<AIChat>(snap);
    return {
      ...chat,
      lastMessageAt: parseDate((snap.data() as { lastMessageAt?: FirestoreDateLike }).lastMessageAt),
    };
  });
}

export async function getRecentVideoInsights(userId: string): Promise<VideoInsight[]> {
  const insightsRef = collection(db, "users", userId, "video_insights");
  const insightSnap = await getDocs(query(insightsRef, orderBy("createdAt", "desc"), limit(6)));
  return insightSnap.docs.map((snap) => mapDoc<VideoInsight>(snap));
}

export async function createTransaction(userId: string, input: NewTransactionInput): Promise<string> {
  const when = input.date ? new Date(input.date) : new Date();
  const txRef = await addDoc(collection(db, "users", userId, "transactions"), {
    type: input.type,
    amount: input.amount,
    currency: "INR",
    category: input.category.toLowerCase(),
    subCategory: null,
    tags: [],
    title: input.title,
    note: input.note || null,
    merchantName: input.title,
    source: "manual",
    receiptURL: null,
    ocrRawText: null,
    paymentMethod: input.paymentMethod.toLowerCase(),
    accountLabel: null,
    date: Timestamp.fromDate(when),
    month: monthKey(when),
    aiCategorized: false,
    isRecurring: false,
    recurringId: null,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  await updateDoc(doc(db, "users", userId), {
    lastActiveAt: serverTimestamp(),
  });

  return txRef.id;
}

export async function createBudget(userId: string, input: NewBudgetInput): Promise<string> {
  const budgetRef = await addDoc(collection(db, "users", userId, "budgets"), {
    month: input.month,
    title: `${input.month} Budget`,
    totalBudget: input.totalBudget,
    categoryLimits: input.categoryLimits,
    generatedBy: "manual",
    aiPromptContext: null,
    isActive: true,
    alertThreshold: 0.8,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  await updateDoc(doc(db, "users", userId), {
    currentMonthBudget: input.totalBudget,
    updatedAt: serverTimestamp(),
  });

  return budgetRef.id;
}

export async function createGoal(userId: string, input: NewGoalInput): Promise<string> {
  const safeTarget = Math.max(0, input.targetAmount);
  const safeCurrent = Math.max(0, input.currentAmount);
  const progressPercent = safeTarget > 0 ? Math.min(100, Math.round((safeCurrent / safeTarget) * 100)) : 0;

  const goalRef = await addDoc(collection(db, "users", userId, "goals"), {
    title: input.title,
    emoji: "🎯",
    category: input.category,
    targetAmount: safeTarget,
    currentAmount: safeCurrent,
    progressPercent,
    startDate: serverTimestamp(),
    targetDate: Timestamp.fromDate(new Date(input.targetDate)),
    completedDate: null,
    monthlyContribution: null,
    autoDeductFromBudget: false,
    status: "active",
    priority: "medium",
    aiSuggestion: null,
    aiSuggestionAt: null,
    milestones: [
      { percent: 25, reached: progressPercent >= 25, reachedAt: null, celebrated: false },
      { percent: 50, reached: progressPercent >= 50, reachedAt: null, celebrated: false },
      { percent: 75, reached: progressPercent >= 75, reachedAt: null, celebrated: false },
      { percent: 100, reached: progressPercent >= 100, reachedAt: null, celebrated: false },
    ],
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  return goalRef.id;
}

export async function updateProfile(userId: string, input: ProfileUpdateInput): Promise<void> {
  const patch = {
    ...(input.displayName ? { displayName: input.displayName } : {}),
    ...(input.phoneNumber ? { phoneNumber: input.phoneNumber } : {}),
    updatedAt: serverTimestamp(),
    lastActiveAt: serverTimestamp(),
  };

  await setDoc(doc(db, "users", userId), patch, { merge: true });
}
