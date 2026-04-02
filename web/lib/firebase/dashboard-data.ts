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
  monthlyIncome?: number;
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
  budgetUtilizationPercent?: number;
  savingsRatePercent?: number;
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
  category?: string;
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
  category?: string;
  tags?: string[];
  targetOccupation?: string;
  targetIncomeRange?: string;
  hasQuiz?: boolean;
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
  videoId?: string;
  videoURL?: string;
  videoTitle?: string;
  summary?: string;
  keyTips?: string[];
  actionPoints?: string[];
};

export type AIChatMessage = {
  role: "user" | "assistant" | "system";
  content: string;
  createdAt?: Date;
};

export type ExpenseInsightsResult = {
  summary?: string;
  topCategories?: Array<{
    category: string;
    amount: number;
    percentOfTotal?: number;
    trend?: string;
  }>;
  savingsHealth?: string;
  savingsRateComment?: string;
  anomalies?: string[];
  recommendations?: string[];
  nextMonthForecast?: {
    estimatedExpense?: number;
    confidence?: number;
  };
};

export type BudgetDoc = {
  id: string;
  month?: string;
  title?: string;
  totalBudget?: number;
  categoryLimits?: Record<string, number>;
  generatedBy?: string;
  alertThreshold?: number;
  updatedAt?: Date;
};

export type GoalAdviceResult = {
  projectedCompletionDate?: string;
  isOnTrack?: boolean;
  shortfallAmount?: number;
  requiredMonthlySaving?: number;
  currentMonthlySaving?: number;
  advice?: string;
  strategies?: string[];
  milestoneMessage?: string;
  riskLevel?: string;
};

export type ExpensePredictionResult = {
  predictedTotalExpense?: number;
  confidence?: number;
  categoryForecasts?: Record<string, { predicted?: number; trend?: string; changePercent?: number }>;
  warnings?: string[];
  savingsProjection?: number;
  recommendedBudgetAdjustments?: string[];
};

export type LearningPathResult = {
  recommendedPath?: Array<{
    moduleId: string;
    title: string;
    reason?: string;
    priority?: number;
    estimatedMins?: number;
  }>;
  learnerLevel?: string;
  motivationNote?: string;
  nextBadgeHint?: string;
};

function toSafeNumber(value: unknown, fallback = 0): number {
  if (typeof value === "number" && Number.isFinite(value)) return value;
  if (typeof value === "string") {
    const parsed = Number(value);
    if (Number.isFinite(parsed)) return parsed;
  }
  return fallback;
}

function toSafeString(value: unknown, fallback = ""): string {
  if (typeof value === "string") return value;
  if (typeof value === "number" || typeof value === "boolean") return String(value);
  return fallback;
}

function normalizeCategoryBreakdown(value: unknown): Record<string, number> {
  if (!value || typeof value !== "object" || Array.isArray(value)) return {};
  const entries = Object.entries(value as Record<string, unknown>)
    .map(([key, raw]) => {
      if (typeof raw === "number") return [key, Math.max(0, raw)] as const;
      if (raw && typeof raw === "object") {
        const nested = raw as Record<string, unknown>;
        if (typeof nested.amount === "number") return [key, Math.max(0, nested.amount)] as const;
        if (typeof nested.total === "number") return [key, Math.max(0, nested.total)] as const;
      }
      return [key, toSafeNumber(raw, 0)] as const;
    })
    .filter(([, amount]) => Number.isFinite(amount) && amount >= 0);

  return Object.fromEntries(entries);
}

export function stringifyInsight(value: unknown): string {
  if (typeof value === "string") return value;
  if (!value || typeof value !== "object") return "";

  const data = value as Record<string, unknown>;
  if (typeof data.summary === "string") return data.summary;
  if (typeof data.advice === "string") return data.advice;
  if (typeof data.motivationNote === "string") return data.motivationNote;
  if (typeof data.reasoning === "string") return data.reasoning;

  // Check if this looks like financial data (MonthlySummary object) instead of AI insight
  if (typeof data.totalIncome === "number" && typeof data.totalExpense === "number") {
    return "";
  }

  try {
    const str = JSON.stringify(value);
    // If JSON is suspiciously financial-looking, return empty
    if (str.includes("totalIncome") || str.includes("categoryBreakdown")) {
      return "";
    }
    return str;
  } catch {
    return "";
  }
}

function sanitizeErrorMessage(error: unknown): string {
  if (error instanceof Error) return error.message;
  return "Unknown error";
}

async function postAI<T>(path: string, payload: unknown): Promise<T> {
  const response = await fetch(path, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  const data = await response.json();
  if (!response.ok) {
    const details = Array.isArray(data?.details) ? ` (${data.details.join("; ")})` : "";
    throw new Error((data?.message || data?.error || `AI request failed: ${response.status}`) + details);
  }

  return data as T;
}

async function getCurrentBudget(userId: string) {
  const budgetsRef = collection(db, "users", userId, "budgets");
  const budgetSnap = await getDocs(query(budgetsRef, where("isActive", "==", true), orderBy("updatedAt", "desc"), limit(1)));
  if (budgetSnap.empty) return null;
  const raw = budgetSnap.docs[0].data() as Record<string, unknown>;
  return {
    totalBudget: toSafeNumber(raw.totalBudget),
    categoryLimits: normalizeCategoryBreakdown(raw.categoryLimits),
  };
}

export async function getLatestBudget(userId: string): Promise<BudgetDoc | null> {
  const budgetsRef = collection(db, "users", userId, "budgets");
  const budgetSnap = await getDocs(query(budgetsRef, orderBy("updatedAt", "desc"), limit(1)));
  if (budgetSnap.empty) return null;

  const raw = budgetSnap.docs[0].data() as Record<string, unknown>;
  return {
    id: budgetSnap.docs[0].id,
    month: toSafeString(raw.month),
    title: toSafeString(raw.title),
    totalBudget: toSafeNumber(raw.totalBudget, 0),
    categoryLimits: normalizeCategoryBreakdown(raw.categoryLimits),
    generatedBy: toSafeString(raw.generatedBy),
    alertThreshold: toSafeNumber(raw.alertThreshold, 0.8),
    updatedAt: parseDate(raw.updatedAt as FirestoreDateLike),
  };
}

function extractVideoId(videoURL: string): string | null {
  try {
    const url = new URL(videoURL);
    if (url.hostname.includes("youtu.be")) {
      return url.pathname.replace("/", "") || null;
    }
    if (url.hostname.includes("youtube.com")) {
      return url.searchParams.get("v");
    }
    return null;
  } catch {
    return null;
  }
}

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

  const snap = monthlySnap.docs[0];
  const raw = snap.data() as Record<string, unknown>;
  return {
    id: snap.id,
    month: toSafeString(raw.month, snap.id),
    totalIncome: toSafeNumber(raw.totalIncome),
    totalExpense: toSafeNumber(raw.totalExpense),
    totalSavings: toSafeNumber(raw.totalSavings),
    budgetAmount: raw.budgetAmount == null ? null : toSafeNumber(raw.budgetAmount),
    budgetUtilizationPercent: toSafeNumber(raw.budgetUtilizationPercent),
    savingsRatePercent: toSafeNumber(raw.savingsRatePercent),
    aiInsightSummary: stringifyInsight(raw.aiInsightSummary) || null,
    categoryBreakdown: normalizeCategoryBreakdown(raw.categoryBreakdown),
  };
}

export async function getRecentTransactions(userId: string, take = 20): Promise<Transaction[]> {
  const txRef = collection(db, "users", userId, "transactions");
  const txSnap = await getDocs(query(txRef, orderBy("date", "desc"), limit(take)));
  return txSnap.docs.map((snap) => {
    const tx = mapDoc<Transaction>(snap);
    return {
      ...tx,
      amount: toSafeNumber((snap.data() as { amount?: unknown }).amount),
      type: ((snap.data() as { type?: unknown }).type as Transaction["type"]) || "expense",
      category: toSafeString((snap.data() as { category?: unknown }).category),
      paymentMethod: toSafeString((snap.data() as { paymentMethod?: unknown }).paymentMethod),
      title: toSafeString((snap.data() as { title?: unknown }).title),
      merchantName: toSafeString((snap.data() as { merchantName?: unknown }).merchantName) || null,
      note: toSafeString((snap.data() as { note?: unknown }).note) || null,
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

export async function updateGoalAmount(userId: string, goalId: string, amountToAdd: number): Promise<void> {
  const goal = await getGoalById(userId, goalId);
  if (!goal) {
    throw new Error("Goal not found");
  }

  const newAmount = (goal.currentAmount || 0) + amountToAdd;
  const targetAmount = goal.targetAmount || 0;
  const progressPercent = targetAmount > 0 ? Math.round((newAmount / targetAmount) * 100) : 0;
  const status = newAmount >= targetAmount ? "completed" : goal.status || "active";

  await updateDoc(doc(db, "users", userId, "goals", goalId), {
    currentAmount: newAmount,
    progressPercent: Math.min(100, progressPercent),
    status,
    updatedAt: serverTimestamp(),
  });
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
  let modulesSnap = await getDocs(query(modulesRef, where("isPublished", "==", true), orderBy("sortOrder", "asc")));
  if (modulesSnap.empty) {
    modulesSnap = await getDocs(query(modulesRef, orderBy("sortOrder", "asc"), limit(50)));
  }

  return modulesSnap.docs.map((snap) => {
    const raw = snap.data() as Record<string, unknown>;
    return {
      id: snap.id,
      title: toSafeString(raw.title, "Untitled Module"),
      lessonCount: toSafeNumber(raw.lessonCount, 0),
      estimatedMins: toSafeNumber(raw.estimatedMins, 10),
      difficulty: toSafeString(raw.difficulty, "beginner"),
      category: toSafeString(raw.category),
      tags: Array.isArray(raw.tags) ? raw.tags.filter((t): t is string => typeof t === "string") : [],
      targetOccupation: toSafeString(raw.targetOccupation),
      targetIncomeRange: toSafeString(raw.targetIncomeRange),
      hasQuiz: Boolean(raw.hasQuiz),
      totalEnrollments: toSafeNumber(raw.totalEnrollments),
    };
  });
}

export async function getLearningProgress(userId: string): Promise<LearningProgress[]> {
  const progressRef = collection(db, "users", userId, "learning_progress");
  const progressSnap = await getDocs(progressRef);
  return progressSnap.docs.map((snap) => mapDoc<LearningProgress>(snap));
}

export async function getLessons(moduleId: string): Promise<Lesson[]> {
  const lessonsRef = collection(db, "learning_modules", moduleId, "lessons");
  const lessonsSnap = await getDocs(query(lessonsRef, orderBy("sortOrder", "asc")));
  return lessonsSnap.docs.map((snap) => {
    const raw = snap.data() as Record<string, unknown>;
    return {
      id: snap.id,
      title: toSafeString(raw.title, "Lesson"),
      content: toSafeString(raw.content, "Content not available yet."),
      sortOrder: toSafeNumber(raw.sortOrder, 0),
      readTimeSec: toSafeNumber(raw.readTimeSec, 60),
    };
  });
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

export async function generateExpenseInsights(userId: string): Promise<ExpenseInsightsResult> {
  const [user, monthlySummary, recentTransactions] = await Promise.all([
    getUserProfile(userId),
    getLatestMonthlySummary(userId),
    getRecentTransactions(userId, 30),
  ]);

  if (!user) {
    throw new Error("User profile not found");
  }

  if (!monthlySummary) {
    throw new Error("No monthly summary data available. Please add some transactions first.");
  }

  const payload = {
    user: {
      occupationType: user.occupationType,
      incomeRange: user.incomeRange,
      monthlyIncome: user.monthlyIncome ?? undefined,
      currentMonthBudget: user.currentMonthBudget ?? undefined,
      currentMonthSpent: user.currentMonthSpent ?? monthlySummary.totalExpense,
    },
    monthlySummary: {
      month: monthlySummary.month,
      totalIncome: monthlySummary.totalIncome,
      totalExpense: monthlySummary.totalExpense,
      totalSavings: monthlySummary.totalSavings,
      savingsRate: monthlySummary.savingsRatePercent ? monthlySummary.savingsRatePercent / 100 : undefined,
      categoryBreakdown: monthlySummary.categoryBreakdown ?? {},
      budgetAmount: monthlySummary.budgetAmount ?? undefined,
    },
    recentTransactions: recentTransactions.map((tx) => ({
      type: tx.type,
      amount: tx.amount,
      category: tx.category,
      paymentMethod: tx.paymentMethod,
      date: tx.date?.toISOString(),
    })),
  };

  try {
    const response = await postAI<{ result: ExpenseInsightsResult }>("/api/ai/expense-insights", payload);
    const result = response.result || {};

    if (!result.summary) {
      console.warn("[generateExpenseInsights] API returned result without summary", { result });
    }

    // Save the summary to Firestore
    await updateDoc(doc(db, "users", userId, "monthly_summaries", monthlySummary.id), {
      aiInsightSummary: result.summary || "Insights generated but summary unavailable",
      aiInsightGeneratedAt: serverTimestamp(),
      aiInsightVersion: 1,
      updatedAt: serverTimestamp(),
    });

    return result;
  } catch (error) {
    console.error("[generateExpenseInsights] Error:", error);
    throw new Error(`Expense insights failed: ${sanitizeErrorMessage(error)}`);
  }
}

export async function generateExpensePrediction(userId: string): Promise<ExpensePredictionResult> {
  const [user, budget, txns] = await Promise.all([
    getUserProfile(userId),
    getLatestBudget(userId),
    getRecentTransactions(userId, 60),
  ]);

  const summarySnap = await getDocs(query(collection(db, "users", userId, "monthly_summaries"), orderBy(documentId(), "desc"), limit(6)));
  const monthlySummaries = summarySnap.docs.map((snap) => {
    const raw = snap.data() as Record<string, unknown>;
    return {
      month: toSafeString(raw.month, snap.id),
      totalIncome: toSafeNumber(raw.totalIncome),
      totalExpense: toSafeNumber(raw.totalExpense),
      totalSavings: toSafeNumber(raw.totalSavings),
      savingsRate: toSafeNumber(raw.savingsRatePercent) / 100,
      categoryBreakdown: normalizeCategoryBreakdown(raw.categoryBreakdown),
    };
  });

  if (!user || monthlySummaries.length === 0) {
    throw new Error("Insufficient data to predict expenses");
  }

  const payload = {
    user: {
      occupationType: user.occupationType,
      incomeRange: user.incomeRange,
      monthlyIncome: toSafeNumber(user.monthlyIncome),
    },
    monthlySummaries,
    recurringTransactions: txns
      .filter((tx) => Boolean((tx as Transaction & { isRecurring?: boolean }).isRecurring))
      .map((tx) => ({ amount: toSafeNumber(tx.amount), category: toSafeString(tx.category), paymentMethod: toSafeString(tx.paymentMethod) })),
    nextMonthBudget: budget
      ? {
          totalBudget: toSafeNumber(budget.totalBudget),
          categoryLimits: budget.categoryLimits || {},
        }
      : undefined,
  };

  const response = await postAI<{ result: ExpensePredictionResult }>("/api/ai/predict-expenses", payload);
  return response.result || {};
}

export async function sendAIChatMessage(userId: string, message: string, sessionId?: string, mode = "general") {
  const chatSessionId = sessionId || `session_${Date.now()}`;
  const [user, summary, goals, budget, chatDoc] = await Promise.all([
    getUserProfile(userId),
    getLatestMonthlySummary(userId),
    getGoals(userId),
    getCurrentBudget(userId),
    getDoc(doc(db, "users", userId, "ai_chats", chatSessionId)),
  ]);

  if (!user) {
    throw new Error("Missing user profile");
  }

  const existingMessages = (chatDoc.data()?.messages as Array<{ role: "user" | "assistant" | "system"; content: string; createdAt?: FirestoreDateLike }> | undefined) || [];
  const recentMessages = existingMessages
    .slice(-20)
    .filter((m) => m.role === "user" || m.role === "assistant" || m.role === "system")
    .map((m) => ({
      role: m.role,
      content: toSafeString(m.content),
      createdAt: parseDate(m.createdAt)?.toISOString(),
    }));

  const payload = {
    sessionId: chatSessionId,
    mode,
    message,
    userContext: {
      occupationType: user.occupationType,
      incomeRange: user.incomeRange,
      monthlyIncome: user.monthlyIncome ?? undefined,
      currentMonthBudget: user.currentMonthBudget ?? undefined,
      currentMonthSpent: user.currentMonthSpent ?? summary?.totalExpense,
      topGoals: goals.slice(0, 5).map((goal) => goal.category).filter((category): category is string => Boolean(category)),
    },
    financialSnapshot: summary
      ? {
          totalExpense: toSafeNumber(summary.totalExpense),
          totalIncome: toSafeNumber(summary.totalIncome),
          totalSavings: toSafeNumber(summary.totalSavings),
          categoryBreakdown: summary.categoryBreakdown ?? {},
        }
      : undefined,
    activeGoals: goals
      .filter((goal) => goal.status === "active")
      .slice(0, 5)
      .map((goal) => ({
        category: goal.category || "other",
        targetAmount: Math.max(0, toSafeNumber(goal.targetAmount)),
        currentAmount: Math.max(0, toSafeNumber(goal.currentAmount)),
        targetDate: goal.targetDate?.toISOString(),
        status: goal.status,
      })),
    currentBudget: budget
      ? {
          totalBudget: budget.totalBudget,
          categoryLimits: budget.categoryLimits,
        }
      : undefined,
    recentMessages,
  };

  try {
    const response = await postAI<{ result: { reply?: string; suggestedActions?: string[]; followUpSuggestions?: string[] } }>("/api/ai/chat", payload);
    const reply = response.result?.reply || "I could not generate a response right now. Please try again.";

    const updatedMessages = [
      ...existingMessages,
      { role: "user", content: message, createdAt: new Date() },
      { role: "assistant", content: reply, createdAt: new Date() },
    ];

    await setDoc(
      doc(db, "users", userId, "ai_chats", chatSessionId),
      {
        title: (message || "AI Chat").slice(0, 60),
        mode,
        isArchived: false,
        messages: updatedMessages,
        lastMessageAt: serverTimestamp(),
        updatedAt: serverTimestamp(),
        createdAt: chatDoc.exists() ? chatDoc.data()?.createdAt || serverTimestamp() : serverTimestamp(),
      },
      { merge: true },
    );

    return {
      sessionId: chatSessionId,
      reply,
      suggestedActions: response.result?.suggestedActions || [],
      followUpSuggestions: response.result?.followUpSuggestions || [],
    };
  } catch (error) {
    throw new Error(`AI chat failed: ${sanitizeErrorMessage(error)}`);
  }
}

export async function analyzeVideoInsightFromUrl(userId: string, videoURL: string): Promise<VideoInsight> {
  const videoId = extractVideoId(videoURL);
  const title = videoId ? `YouTube Video (${videoId})` : "YouTube Finance Video";

  if (videoId) {
    const existingSnap = await getDocs(
      query(collection(db, "users", userId, "video_insights"), where("videoId", "==", videoId), limit(1)),
    );
    if (!existingSnap.empty) {
      return mapDoc<VideoInsight>(existingSnap.docs[0]);
    }
  }

  const user = await getUserProfile(userId);
  const payload = {
    videoId: videoId || undefined,
    videoTitle: title,
    transcript: `Transcript unavailable for URL: ${videoURL}. Generate insights from the video context and general personal finance principles for Indian users.`,
    userContext: {
      occupationType: user?.occupationType,
      incomeRange: user?.incomeRange,
      topGoals: [],
      preferredLanguage: "en",
    },
  };

  try {
    const response = await postAI<{ result: { summary?: string; keyTips?: string[]; actionPoints?: string[] } }>("/api/ai/video-insights", payload);
    const result = response.result || {};

    const created = await addDoc(collection(db, "users", userId, "video_insights"), {
      videoId: videoId || null,
      videoURL,
      videoTitle: title,
      summary: result.summary || "",
      keyTips: result.keyTips || [],
      actionPoints: result.actionPoints || [],
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    });

    return {
      id: created.id,
      videoId: videoId || undefined,
      videoURL,
      videoTitle: title,
      summary: result.summary,
      keyTips: result.keyTips,
      actionPoints: result.actionPoints,
    };
  } catch (error) {
    throw new Error(`Video insights failed: ${sanitizeErrorMessage(error)}`);
  }
}

export async function generateAIBudget(userId: string, monthlyIncome: number) {
  const [user, goals, lastBudget] = await Promise.all([
    getUserProfile(userId),
    getGoals(userId),
    getLatestBudget(userId),
  ]);

  const summarySnap = await getDocs(query(collection(db, "users", userId, "monthly_summaries"), orderBy(documentId(), "desc"), limit(3)));
  const monthlySummaries = summarySnap.docs.map((snap) => {
    const raw = snap.data() as Record<string, unknown>;
    return {
      month: toSafeString(raw.month, snap.id),
      totalIncome: toSafeNumber(raw.totalIncome),
      totalExpense: toSafeNumber(raw.totalExpense),
      categoryBreakdown: normalizeCategoryBreakdown(raw.categoryBreakdown),
      savingsRate: toSafeNumber(raw.savingsRatePercent) / 100,
    };
  });

  const payload = {
    user: {
      occupationType: user?.occupationType,
      incomeRange: user?.incomeRange,
      monthlyIncome: toSafeNumber(monthlyIncome),
      topGoals: goals.map((goal) => goal.category).filter((category): category is string => Boolean(category)).slice(0, 5),
      currentMonthSpent: toSafeNumber(user?.currentMonthSpent),
    },
    monthlySummaries,
    activeGoals: goals
      .filter((goal) => goal.status === "active")
      .map((goal) => ({
        category: goal.category || "other",
        targetAmount: toSafeNumber(goal.targetAmount),
        currentAmount: toSafeNumber(goal.currentAmount),
        targetDate: goal.targetDate?.toISOString(),
      })),
    lastBudget: lastBudget
      ? {
          totalBudget: toSafeNumber(lastBudget.totalBudget),
          categoryLimits: lastBudget.categoryLimits || {},
        }
      : undefined,
  };

  const response = await postAI<{ result: { totalBudget?: number; categoryLimits?: Record<string, number>; alertThreshold?: number; reasoning?: string } }>("/api/ai/generate-budget", payload);
  return response.result || {};
}

export async function generateGoalAdvice(userId: string, goalId: string): Promise<GoalAdviceResult> {
  const [user, goal, budget] = await Promise.all([getUserProfile(userId), getGoalById(userId, goalId), getLatestBudget(userId)]);
  const summarySnap = await getDocs(query(collection(db, "users", userId, "monthly_summaries"), orderBy(documentId(), "desc"), limit(3)));
  const recentSummaries = summarySnap.docs.map((snap) => {
    const raw = snap.data() as Record<string, unknown>;
    return {
      month: toSafeString(raw.month, snap.id),
      totalIncome: toSafeNumber(raw.totalIncome),
      totalExpense: toSafeNumber(raw.totalExpense),
      totalSavings: toSafeNumber(raw.totalSavings),
      savingsRate: toSafeNumber(raw.savingsRatePercent) / 100,
    };
  });

  if (!user || !goal) {
    throw new Error("Goal data not found");
  }

  const payload = {
    user: {
      occupationType: user.occupationType,
      incomeRange: user.incomeRange,
      monthlyIncome: toSafeNumber(user.monthlyIncome),
    },
    goal: {
      category: goal.category || "other",
      targetAmount: toSafeNumber(goal.targetAmount),
      currentAmount: toSafeNumber(goal.currentAmount),
      progressPercent: toSafeNumber(goal.progressPercent),
      targetDate: goal.targetDate?.toISOString(),
      status: goal.status,
    },
    recentSummaries,
    currentBudget: budget
      ? {
          totalBudget: toSafeNumber(budget.totalBudget),
          categoryLimits: budget.categoryLimits || {},
        }
      : undefined,
  };

  const response = await postAI<{ result: GoalAdviceResult }>("/api/ai/goal-advice", payload);
  const result = response.result || {};

  await updateDoc(doc(db, "users", userId, "goals", goalId), {
    aiSuggestion: stringifyInsight(result.advice || result),
    aiSuggestionAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  return result;
}

export async function generateLearningPath(userId: string): Promise<LearningPathResult> {
  const [user, progress, modules] = await Promise.all([getUserProfile(userId), getLearningProgress(userId), getLearningModules()]);

  const badgesSnap = await getDocs(query(collection(db, "users", userId, "badges"), limit(20)));
  const badges = badgesSnap.docs.map((snap) => {
    const raw = snap.data() as Record<string, unknown>;
    return { badgeId: snap.id, category: toSafeString(raw.category) };
  });

  const payload = {
    user: {
      occupationType: user?.occupationType,
      incomeRange: user?.incomeRange,
      topGoals: [],
      preferredLanguage: "en",
    },
    learningProgress: progress.map((item) => ({
      moduleId: item.moduleId,
      status: toSafeString(item.status),
      progressPercent: toSafeNumber(item.progressPercent),
    })),
    badges,
    learningModules: modules.map((module) => ({
      id: module.id,
      title: module.title,
      targetOccupation: module.targetOccupation,
      targetIncomeRange: module.targetIncomeRange,
      difficulty: module.difficulty,
      tags: module.tags || [],
      category: module.category,
      estimatedMins: toSafeNumber(module.estimatedMins),
      hasQuiz: Boolean(module.hasQuiz),
    })),
  };

  const response = await postAI<{ result: LearningPathResult }>("/api/ai/learning-path", payload);
  return response.result || {};
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
