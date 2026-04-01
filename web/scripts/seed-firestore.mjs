import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import admin from "firebase-admin";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.resolve(__dirname, "..");

function loadEnvFileIfPresent(fileName) {
  const filePath = path.join(projectRoot, fileName);
  if (!fs.existsSync(filePath)) {
    return;
  }

  const text = fs.readFileSync(filePath, "utf8");
  for (const rawLine of text.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#") || !line.includes("=")) {
      continue;
    }

    const splitAt = line.indexOf("=");
    const key = line.slice(0, splitAt).trim();
    const value = line.slice(splitAt + 1).trim();

    if (key && process.env[key] === undefined) {
      process.env[key] = value;
    }
  }
}

function initializeFirebaseAdmin() {
  loadEnvFileIfPresent(".env.local");

  if (admin.apps.length > 0) {
    return admin.app();
  }

  const projectId =
    process.env.FIREBASE_PROJECT_ID || process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID;

  const defaultServiceAccountCandidates = [
    path.join(projectRoot, "service-account.json"),
    path.join(projectRoot, "firebase-service-account.json"),
    path.join(projectRoot, "serviceAccountKey.json"),
  ];

  if (process.env.FIREBASE_SERVICE_ACCOUNT_KEY) {
    const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);
    return admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      projectId,
    });
  }

  if (process.env.FIREBASE_SERVICE_ACCOUNT_PATH) {
    const servicePath = path.isAbsolute(process.env.FIREBASE_SERVICE_ACCOUNT_PATH)
      ? process.env.FIREBASE_SERVICE_ACCOUNT_PATH
      : path.join(projectRoot, process.env.FIREBASE_SERVICE_ACCOUNT_PATH);
    const serviceAccount = JSON.parse(fs.readFileSync(servicePath, "utf8"));

    return admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      projectId,
    });
  }

  for (const candidate of defaultServiceAccountCandidates) {
    if (fs.existsSync(candidate)) {
      const serviceAccount = JSON.parse(fs.readFileSync(candidate, "utf8"));
      return admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        projectId,
      });
    }
  }

  return admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    projectId,
  });
}

function monthKey(date) {
  const year = date.getUTCFullYear();
  const month = String(date.getUTCMonth() + 1).padStart(2, "0");
  return `${year}-${month}`;
}

function timestampFromDate(date) {
  return admin.firestore.Timestamp.fromDate(date);
}

function buildData(userId) {
  const now = new Date();
  const prevMonthDate = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 1, 1));
  const currentMonth = monthKey(now);
  const previousMonth = monthKey(prevMonthDate);

  const currentMonthDates = [
    new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 2, 6, 10)),
    new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 4, 13, 45)),
    new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 6, 19, 20)),
    new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 8, 8, 50)),
    new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 10, 15, 30)),
    new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 12, 11, 5)),
  ];

  const transactions = [
    {
      id: "txn-001",
      type: "income",
      amount: 85000,
      category: "salary",
      subCategory: null,
      tags: ["monthly", "primary_income"],
      title: "Salary Credit - April",
      note: "Net salary credited",
      merchantName: "Infosys Ltd",
      source: "manual",
      receiptURL: null,
      ocrRawText: null,
      paymentMethod: "netbanking",
      accountLabel: "HDFC Savings",
      date: currentMonthDates[0],
      month: currentMonth,
      aiCategorized: false,
      isRecurring: true,
      recurringId: "rec-salary",
    },
    {
      id: "txn-002",
      type: "expense",
      amount: 4200,
      category: "food",
      subCategory: "grocery",
      tags: ["essential", "family"],
      title: "Monthly Grocery",
      note: "BigBasket monthly stock-up",
      merchantName: "BigBasket",
      source: "manual",
      receiptURL: null,
      ocrRawText: null,
      paymentMethod: "upi",
      accountLabel: "GPay",
      date: currentMonthDates[1],
      month: currentMonth,
      aiCategorized: true,
      isRecurring: true,
      recurringId: "rec-groceries",
    },
    {
      id: "txn-003",
      type: "expense",
      amount: 1600,
      category: "transport",
      subCategory: "fuel",
      tags: ["commute"],
      title: "Petrol Refill",
      note: null,
      merchantName: "IndianOil",
      source: "manual",
      receiptURL: null,
      ocrRawText: null,
      paymentMethod: "card_debit",
      accountLabel: "HDFC Debit",
      date: currentMonthDates[2],
      month: currentMonth,
      aiCategorized: true,
      isRecurring: false,
      recurringId: null,
    },
    {
      id: "txn-004",
      type: "expense",
      amount: 999,
      category: "entertainment",
      subCategory: "ott",
      tags: ["subscription"],
      title: "OTT Subscription",
      note: "Annual renewal split monthly",
      merchantName: "JioHotstar",
      source: "manual",
      receiptURL: null,
      ocrRawText: null,
      paymentMethod: "upi",
      accountLabel: "PhonePe",
      date: currentMonthDates[3],
      month: currentMonth,
      aiCategorized: true,
      isRecurring: true,
      recurringId: "rec-ott",
    },
    {
      id: "txn-005",
      type: "expense",
      amount: 3200,
      category: "bills",
      subCategory: "electricity",
      tags: ["essential", "utilities"],
      title: "Electricity Bill",
      note: "MSEDCL payment",
      merchantName: "MSEDCL",
      source: "manual",
      receiptURL: null,
      ocrRawText: null,
      paymentMethod: "upi",
      accountLabel: "BHIM UPI",
      date: currentMonthDates[4],
      month: currentMonth,
      aiCategorized: true,
      isRecurring: true,
      recurringId: "rec-electricity",
    },
    {
      id: "txn-006",
      type: "transfer",
      amount: 10000,
      category: "investment",
      subCategory: "sip",
      tags: ["wealth", "discipline"],
      title: "Mutual Fund SIP",
      note: "Nifty index fund",
      merchantName: "Groww",
      source: "manual",
      receiptURL: null,
      ocrRawText: null,
      paymentMethod: "netbanking",
      accountLabel: "HDFC Savings",
      date: currentMonthDates[5],
      month: currentMonth,
      aiCategorized: true,
      isRecurring: true,
      recurringId: "rec-sip",
    },
    {
      id: "txn-007",
      type: "expense",
      amount: 2700,
      category: "food",
      subCategory: "dining",
      tags: ["weekend"],
      title: "Dinner with Family",
      note: null,
      merchantName: "Barbeque Nation",
      source: "manual",
      receiptURL: null,
      ocrRawText: null,
      paymentMethod: "card_credit",
      accountLabel: "SBI Credit Card",
      date: new Date(Date.UTC(prevMonthDate.getUTCFullYear(), prevMonthDate.getUTCMonth(), 7, 14, 15)),
      month: previousMonth,
      aiCategorized: true,
      isRecurring: false,
      recurringId: null,
    },
    {
      id: "txn-008",
      type: "expense",
      amount: 1200,
      category: "transport",
      subCategory: "metro",
      tags: ["commute"],
      title: "Metro Recharge",
      note: "Pune Metro card recharge",
      merchantName: "Pune Metro",
      source: "manual",
      receiptURL: null,
      ocrRawText: null,
      paymentMethod: "upi",
      accountLabel: "GPay",
      date: new Date(Date.UTC(prevMonthDate.getUTCFullYear(), prevMonthDate.getUTCMonth(), 11, 9, 30)),
      month: previousMonth,
      aiCategorized: true,
      isRecurring: false,
      recurringId: null,
    },
  ];

  const currentMonthExpense = transactions
    .filter((txn) => txn.month === currentMonth && txn.type === "expense")
    .reduce((sum, txn) => sum + txn.amount, 0);

  const currentMonthIncome = transactions
    .filter((txn) => txn.month === currentMonth && txn.type === "income")
    .reduce((sum, txn) => sum + txn.amount, 0);

  const currentSavings = currentMonthIncome - currentMonthExpense;

  const userProfile = {
    uid: userId,
    email: "pushkar.shinde@finwise.in",
    displayName: "Pushkar Shinde",
    photoURL: null,
    phoneNumber: "+919876543210",
    isEmailVerified: true,
    occupationType: "salaried",
    incomeRange: "50k-100k",
    monthlyIncome: 85000,
    preferredLanguage: "en",
    topGoals: ["emergency_fund", "house", "vacation"],
    isOnboardingComplete: true,
    currency: "INR",
    notificationsEnabled: true,
    biometricEnabled: true,
    theme: "system",
    currentMonthBudget: 50000,
    currentMonthSpent: currentMonthExpense,
    totalSavings: 290000,
    streakDays: 11,
    eligibilityTags: ["pm_mudra", "atal_pension", "startup_india"],
    createdAt: timestampFromDate(new Date(Date.UTC(2025, 10, 12, 8, 30))),
    updatedAt: timestampFromDate(now),
    lastActiveAt: timestampFromDate(now),
  };

  const monthlySummaries = {
    [currentMonth]: {
      month: currentMonth,
      year: now.getUTCFullYear(),
      totalIncome: currentMonthIncome,
      totalExpense: currentMonthExpense,
      totalSavings: currentSavings,
      savingsRate: currentMonthIncome === 0 ? 0 : Number((currentSavings / currentMonthIncome).toFixed(2)),
      txnCount: transactions.filter((txn) => txn.month === currentMonth).length,
      categoryBreakdown: {
        food: 4200,
        transport: 1600,
        shopping: 0,
        health: 0,
        entertainment: 999,
        bills: 3200,
        investment: 10000,
        other: 0,
      },
      budgetId: "budget-2026-main",
      budgetAmount: 50000,
      budgetVariance: 50000 - currentMonthExpense,
      aiInsightSummary:
        "Food and utility spends are in control. Continue SIP contributions and avoid extra dining spends this month.",
      aiInsightGeneratedAt: timestampFromDate(now),
      aiInsightVersion: 1,
      createdAt: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1, 0, 5))),
      updatedAt: timestampFromDate(now),
    },
    [previousMonth]: {
      month: previousMonth,
      year: prevMonthDate.getUTCFullYear(),
      totalIncome: 82000,
      totalExpense: 43100,
      totalSavings: 38900,
      savingsRate: 0.47,
      txnCount: 14,
      categoryBreakdown: {
        food: 11200,
        transport: 5400,
        shopping: 7200,
        health: 3000,
        entertainment: 1900,
        bills: 8400,
        investment: 6000,
        other: 0,
      },
      budgetId: "budget-2026-prev",
      budgetAmount: 48000,
      budgetVariance: 4900,
      aiInsightSummary:
        "Strong savings performance last month. Consider shifting part of the surplus to emergency fund growth.",
      aiInsightGeneratedAt: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 1, 28, 17, 45))),
      aiInsightVersion: 1,
      createdAt: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 1, 1, 0, 5))),
      updatedAt: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 1, 28, 17, 45))),
    },
  };

  const budgets = [
    {
      id: "budget-2026-main",
      month: currentMonth,
      title: "Current Month Budget",
      totalBudget: 50000,
      categoryLimits: {
        food: 9000,
        transport: 5000,
        shopping: 7000,
        health: 3000,
        entertainment: 3500,
        bills: 12000,
        investment: 9000,
        other: 1500,
      },
      generatedBy: "manual",
      aiPromptContext: null,
      isActive: true,
      alertThreshold: 0.8,
      createdAt: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1, 5, 0))),
      updatedAt: timestampFromDate(now),
    },
  ];

  const goals = [
    {
      id: "goal-emergency-fund",
      title: "Emergency Fund",
      emoji: "INR",
      category: "emergency_fund",
      targetAmount: 300000,
      currentAmount: 120000,
      progressPercent: 40,
      startDate: timestampFromDate(new Date(Date.UTC(2025, 11, 1, 0, 0))),
      targetDate: timestampFromDate(new Date(Date.UTC(2026, 11, 31, 0, 0))),
      completedDate: null,
      monthlyContribution: 15000,
      autoDeductFromBudget: true,
      status: "active",
      priority: "high",
      aiSuggestion: "Increase monthly contribution to INR 18000 to reach this goal 2 months early.",
      aiSuggestionAt: timestampFromDate(now),
      milestones: [
        { percent: 25, reached: true, reachedAt: timestampFromDate(new Date(Date.UTC(2026, 1, 12, 10, 0))), celebrated: true },
        { percent: 50, reached: false, reachedAt: null, celebrated: false },
        { percent: 75, reached: false, reachedAt: null, celebrated: false },
        { percent: 100, reached: false, reachedAt: null, celebrated: false },
      ],
      createdAt: timestampFromDate(new Date(Date.UTC(2025, 11, 1, 0, 0))),
      updatedAt: timestampFromDate(now),
    },
    {
      id: "goal-goa-trip",
      title: "Goa Vacation",
      emoji: "Palm",
      category: "vacation",
      targetAmount: 80000,
      currentAmount: 30000,
      progressPercent: 38,
      startDate: timestampFromDate(new Date(Date.UTC(2026, 0, 10, 0, 0))),
      targetDate: timestampFromDate(new Date(Date.UTC(2026, 8, 15, 0, 0))),
      completedDate: null,
      monthlyContribution: 7000,
      autoDeductFromBudget: false,
      status: "active",
      priority: "medium",
      aiSuggestion: "Trim dining out expenses by INR 1500 monthly to keep this goal on track.",
      aiSuggestionAt: timestampFromDate(now),
      milestones: [
        { percent: 25, reached: true, reachedAt: timestampFromDate(new Date(Date.UTC(2026, 2, 10, 12, 15))), celebrated: true },
        { percent: 50, reached: false, reachedAt: null, celebrated: false },
        { percent: 75, reached: false, reachedAt: null, celebrated: false },
        { percent: 100, reached: false, reachedAt: null, celebrated: false },
      ],
      createdAt: timestampFromDate(new Date(Date.UTC(2026, 0, 10, 0, 0))),
      updatedAt: timestampFromDate(now),
    },
  ];

  const aiChats = [
    {
      id: "chat-budget-april",
      title: "April Budget Planning",
      mode: "budget",
      isArchived: false,
      contextSnapshot: {
        occupationType: "salaried",
        incomeRange: "50k-100k",
        monthlyIncome: 85000,
        currentMonthSpent: currentMonthExpense,
        currentMonthBudget: 50000,
        topGoals: ["emergency_fund", "house", "vacation"],
      },
      messages: [
        {
          id: "msg-001",
          role: "user",
          content: "Help me optimize April spending while keeping SIP active.",
          timestamp: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 3, 9, 20))),
          tokensUsed: 44,
        },
        {
          id: "msg-002",
          role: "model",
          content:
            "Keep SIP unchanged and cap dining and shopping. Shift INR 3000 from discretionary spend to emergency fund contribution.",
          timestamp: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 3, 9, 21))),
          tokensUsed: 118,
        },
      ],
      messageCount: 2,
      lastMessageAt: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 3, 9, 21))),
      createdAt: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 3, 9, 18))),
    },
  ];

  const videoInsights = [
    {
      id: "insight-etmoney-sip",
      videoId: "yt-etmoney-sip-101",
      videoURL: "https://www.youtube.com/watch?v=yt-etmoney-sip-101",
      videoTitle: "SIP Investing for Beginners in India",
      channelName: "ET Money",
      thumbnailURL: null,
      videoDurationSec: 820,
      summary: "Simple breakdown of SIP discipline, rupee cost averaging, and long-term compounding for Indian investors.",
      keyTips: [
        "Start with a fixed SIP date each month",
        "Increase SIP by 10 percent annually",
        "Prefer goals over market timing",
      ],
      actionPoints: [
        "Increase existing SIP from INR 10000 to INR 11000 from next quarter",
        "Link SIP to emergency fund target timeline",
      ],
      relevanceScore: 0.91,
      relatedGoals: ["goal-emergency-fund"],
      relatedCategory: "investment",
      analyzedAt: timestampFromDate(now),
      geminiModel: "gemini-1.5-flash",
      transcriptLength: 6320,
      createdAt: timestampFromDate(now),
    },
  ];

  const learningProgress = [
    {
      moduleId: "salary-management-basics-en",
      userId,
      status: "in_progress",
      completedLessons: ["lesson-01", "lesson-02"],
      totalLessons: 4,
      progressPercent: 50,
      quizAttempts: 1,
      bestQuizScore: 80,
      lastQuizScore: 80,
      quizPassed: true,
      totalTimeSpentSec: 2300,
      lastAccessedAt: timestampFromDate(now),
      completedAt: null,
      createdAt: timestampFromDate(new Date(Date.UTC(2026, 2, 2, 7, 0))),
      updatedAt: timestampFromDate(now),
    },
  ];

  const badges = [
    {
      badgeId: "first_transaction",
      title: "First Expense Logged",
      description: "Logged your first transaction in FinWise",
      emoji: "check",
      category: "savings",
      earnedAt: timestampFromDate(new Date(Date.UTC(2026, 1, 14, 11, 0))),
      isNew: false,
    },
    {
      badgeId: "streak_7",
      title: "7-Day Streak",
      description: "Tracked spending for 7 consecutive days",
      emoji: "fire",
      category: "streak",
      earnedAt: timestampFromDate(new Date(Date.UTC(2026, 2, 20, 19, 5))),
      isNew: true,
    },
  ];

  const notifications = [
    {
      id: "notif-budget-80",
      type: "budget_alert",
      title: "You are nearing your food budget",
      body: "Food spending has crossed 70 percent of this month limit.",
      emoji: null,
      deepLink: "/dashboard/budget",
      refType: "budget",
      refId: "budget-2026-main",
      isRead: false,
      readAt: null,
      createdAt: timestampFromDate(now),
    },
    {
      id: "notif-goal-milestone",
      type: "goal_milestone",
      title: "Goa goal reached 25 percent",
      body: "Great progress. Keep your monthly contribution consistent.",
      emoji: null,
      deepLink: "/dashboard/goals/goal-goa-trip",
      refType: "goal",
      refId: "goal-goa-trip",
      isRead: true,
      readAt: timestampFromDate(now),
      createdAt: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 6, 12, 30))),
    },
  ];

  const consultantBookings = [
    {
      id: "booking-001",
      consultantId: "consultant-ananya-iyer",
      consultantName: "Ananya Iyer",
      slotId: "slot-2026-04-10-1830",
      scheduledAt: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 10, 13, 0))),
      durationMins: 45,
      meetLink: "https://meet.google.com/fin-wise-session-1",
      feeINR: 999,
      paymentStatus: "paid",
      status: "upcoming",
      userNotes: "Need tax saving guidance for FY filing.",
      sessionNotes: null,
      rating: null,
      review: null,
      createdAt: timestampFromDate(now),
    },
  ];

  const learningModules = [
    {
      id: "salary-management-basics-en",
      title: "Salary Management Basics",
      description: "A practical guide for Indian salaried professionals to plan monthly cash flow and build savings.",
      emoji: "book",
      coverImageURL: null,
      targetOccupation: ["salaried"],
      targetIncomeRange: ["25k-50k", "50k-100k"],
      difficulty: "beginner",
      language: "en",
      tags: ["salary", "budget", "epf", "tax"],
      category: "basics",
      lessonCount: 4,
      estimatedMins: 40,
      hasQuiz: true,
      passingScore: 70,
      sortOrder: 1,
      isFeatured: true,
      isPublished: true,
      totalEnrollments: 350,
      avgCompletionRate: 0.62,
      createdAt: timestampFromDate(new Date(Date.UTC(2026, 0, 5, 0, 0))),
      updatedAt: timestampFromDate(now),
    },
  ];

  const moduleLessons = [
    {
      moduleId: "salary-management-basics-en",
      id: "lesson-01",
      title: "Build a Monthly Money Plan",
      content:
        "Use a simple split: essentials, goals, and lifestyle. Track spending weekly and revise limits based on actual usage.",
      contentType: "text",
      videoURL: null,
      imageURL: null,
      sortOrder: 1,
      readTimeSec: 360,
      createdAt: timestampFromDate(new Date(Date.UTC(2026, 0, 5, 0, 0))),
    },
    {
      moduleId: "salary-management-basics-en",
      id: "lesson-02",
      title: "Understand CTC, In-Hand, and Deductions",
      content:
        "Know PF, professional tax, and TDS impacts. Compare CTC and net salary before setting spending plans.",
      contentType: "text",
      videoURL: null,
      imageURL: null,
      sortOrder: 2,
      readTimeSec: 420,
      createdAt: timestampFromDate(new Date(Date.UTC(2026, 0, 5, 0, 0))),
    },
  ];

  const moduleQuizzes = [
    {
      moduleId: "salary-management-basics-en",
      id: "quiz-01",
      questions: [
        {
          id: "q1",
          questionText: "Which amount is best for monthly budgeting?",
          options: ["CTC", "In-hand salary", "Gross annual salary", "Bonus amount"],
          correctIndex: 1,
          explanation: "In-hand salary reflects actual money available each month.",
        },
        {
          id: "q2",
          questionText: "What is a practical first saving goal for salaried users?",
          options: ["Luxury gadget", "Emergency fund", "International trip", "Credit card reward points"],
          correctIndex: 1,
          explanation: "Emergency fund improves resilience against income shocks.",
        },
      ],
      totalQuestions: 2,
      passingScore: 70,
      createdAt: timestampFromDate(new Date(Date.UTC(2026, 0, 5, 0, 0))),
    },
  ];

  const governmentSchemes = [
    {
      id: "pm-mudra-yojana",
      name: "PM Mudra Yojana",
      fullName: "Pradhan Mantri MUDRA Yojana",
      ministry: "Ministry of Finance",
      emoji: "bank",
      tagline: "Loans up to INR 10 lakh for small businesses",
      description:
        "Supports micro and small business units with collateral-free loans under Shishu, Kishore, and Tarun categories.",
      logoURL: null,
      officialURL: "https://www.mudra.org.in/",
      eligibilityTags: ["business", "small_enterprise", "startup_india"],
      targetOccupation: ["business", "freelancer"],
      incomeRangeMin: "0-10k",
      incomeRangeMax: "100k+",
      benefitType: "loan",
      maxBenefit: "INR 10,00,000 loan",
      applicationMode: "both",
      applicationURL: "https://www.mudra.org.in/Offerings",
      isActive: true,
      launchYear: 2015,
      lastVerifiedAt: timestampFromDate(now),
      translations: null,
      createdAt: timestampFromDate(new Date(Date.UTC(2025, 5, 1, 0, 0))),
      updatedAt: timestampFromDate(now),
    },
    {
      id: "atal-pension-yojana",
      name: "Atal Pension Yojana",
      fullName: "Atal Pension Yojana",
      ministry: "Ministry of Finance",
      emoji: "shield",
      tagline: "Assured pension for unorganized sector workers",
      description:
        "Government-backed pension scheme with guaranteed monthly pension slabs after retirement.",
      logoURL: null,
      officialURL: "https://www.npscra.nsdl.co.in/scheme-details.php",
      eligibilityTags: ["retirement", "pension", "middle_income"],
      targetOccupation: ["salaried", "business", "freelancer"],
      incomeRangeMin: "0-10k",
      incomeRangeMax: "100k+",
      benefitType: "pension",
      maxBenefit: "INR 5000 monthly pension",
      applicationMode: "both",
      applicationURL: null,
      isActive: true,
      launchYear: 2015,
      lastVerifiedAt: timestampFromDate(now),
      translations: null,
      createdAt: timestampFromDate(new Date(Date.UTC(2025, 5, 1, 0, 0))),
      updatedAt: timestampFromDate(now),
    },
  ];

  const expertConsultants = [
    {
      id: "consultant-ananya-iyer",
      name: "Ananya Iyer",
      photoURL: null,
      designation: "SEBI-Registered Investment Advisor",
      specializations: ["mutual_funds", "tax_planning", "retirement"],
      languages: ["en", "hi", "mr"],
      bio: "12 years of advisory experience helping Indian families with goal-based investing.",
      experience: 12,
      sessionFeeINR: 999,
      sessionDurMins: 45,
      meetMode: ["video", "audio"],
      avgRating: 4.8,
      totalReviews: 186,
      totalSessions: 640,
      isActive: true,
      createdAt: timestampFromDate(new Date(Date.UTC(2025, 8, 10, 0, 0))),
    },
  ];

  const consultantAvailability = [
    {
      consultantId: "consultant-ananya-iyer",
      id: "slot-2026-04-10-1830",
      startTime: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 10, 13, 0))),
      endTime: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 10, 13, 45))),
      isBooked: true,
      bookedBy: userId,
    },
    {
      consultantId: "consultant-ananya-iyer",
      id: "slot-2026-04-12-1100",
      startTime: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 12, 5, 30))),
      endTime: timestampFromDate(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 12, 6, 15))),
      isBooked: false,
      bookedBy: null,
    },
  ];

  const dailyTips = [
    {
      id: "tip-2026-04-01",
      date: "2026-04-01",
      tip: "Automate SIP and emergency fund transfers on salary day to avoid missed savings.",
      category: "saving",
      targetOccupation: ["all"],
      language: "en",
      emoji: "light",
      source: "FinWise Editorial",
      createdAt: timestampFromDate(now),
    },
    {
      id: "tip-2026-04-02",
      date: "2026-04-02",
      tip: "Track electricity and mobile recharges monthly to identify recurring leakage.",
      category: "budgeting",
      targetOccupation: ["all"],
      language: "en",
      emoji: "notes",
      source: "FinWise Editorial",
      createdAt: timestampFromDate(now),
    },
  ];

  return {
    userProfile,
    transactions,
    monthlySummaries,
    budgets,
    goals,
    aiChats,
    videoInsights,
    learningProgress,
    badges,
    notifications,
    consultantBookings,
    learningModules,
    moduleLessons,
    moduleQuizzes,
    governmentSchemes,
    expertConsultants,
    consultantAvailability,
    dailyTips,
  };
}

async function seedFirestore() {
  const userId = process.env.SEED_USER_ID || "vyoLjyxGixbUz4BILtabL8O4bDD3";

  initializeFirebaseAdmin();
  const db = admin.firestore();
  const data = buildData(userId);
  const nowTs = admin.firestore.Timestamp.now();

  const batch = db.batch();
  const userRef = db.collection("users").doc(userId);

  batch.set(userRef, data.userProfile, { merge: true });

  for (const txn of data.transactions) {
    const txnRef = userRef.collection("transactions").doc(txn.id);
    batch.set(txnRef, {
      ...txn,
      currency: "INR",
      date: timestampFromDate(txn.date),
      createdAt: nowTs,
      updatedAt: nowTs,
    });
  }

  for (const [month, summary] of Object.entries(data.monthlySummaries)) {
    const summaryRef = userRef.collection("monthly_summaries").doc(month);
    batch.set(summaryRef, summary, { merge: true });
  }

  for (const budget of data.budgets) {
    const budgetRef = userRef.collection("budgets").doc(budget.id);
    batch.set(budgetRef, budget, { merge: true });
  }

  for (const goal of data.goals) {
    const goalRef = userRef.collection("goals").doc(goal.id);
    batch.set(goalRef, goal, { merge: true });
  }

  for (const chat of data.aiChats) {
    const chatRef = userRef.collection("ai_chats").doc(chat.id);
    batch.set(chatRef, chat, { merge: true });
  }

  for (const insight of data.videoInsights) {
    const insightRef = userRef.collection("video_insights").doc(insight.id);
    batch.set(insightRef, insight, { merge: true });
  }

  for (const progress of data.learningProgress) {
    const progressRef = userRef.collection("learning_progress").doc(progress.moduleId);
    batch.set(progressRef, progress, { merge: true });
  }

  for (const badge of data.badges) {
    const badgeRef = userRef.collection("badges").doc(badge.badgeId);
    batch.set(badgeRef, badge, { merge: true });
  }

  for (const notif of data.notifications) {
    const notifRef = userRef.collection("notifications").doc(notif.id);
    batch.set(notifRef, notif, { merge: true });
  }

  for (const booking of data.consultantBookings) {
    const bookingRef = userRef.collection("consultant_bookings").doc(booking.id);
    batch.set(bookingRef, booking, { merge: true });
  }

  for (const moduleDoc of data.learningModules) {
    const moduleRef = db.collection("learning_modules").doc(moduleDoc.id);
    batch.set(moduleRef, moduleDoc, { merge: true });
  }

  for (const lesson of data.moduleLessons) {
    const lessonRef = db
      .collection("learning_modules")
      .doc(lesson.moduleId)
      .collection("lessons")
      .doc(lesson.id);
    batch.set(lessonRef, lesson, { merge: true });
  }

  for (const quiz of data.moduleQuizzes) {
    const quizRef = db
      .collection("learning_modules")
      .doc(quiz.moduleId)
      .collection("quizzes")
      .doc(quiz.id);
    batch.set(quizRef, quiz, { merge: true });
  }

  for (const scheme of data.governmentSchemes) {
    const schemeRef = db.collection("government_schemes").doc(scheme.id);
    batch.set(schemeRef, scheme, { merge: true });
  }

  for (const consultant of data.expertConsultants) {
    const consultantRef = db.collection("expert_consultants").doc(consultant.id);
    batch.set(consultantRef, consultant, { merge: true });
  }

  for (const slot of data.consultantAvailability) {
    const slotRef = db
      .collection("expert_consultants")
      .doc(slot.consultantId)
      .collection("availability")
      .doc(slot.id);
    batch.set(slotRef, slot, { merge: true });
  }

  for (const tip of data.dailyTips) {
    const tipRef = db.collection("daily_tips").doc(tip.id);
    batch.set(tipRef, tip, { merge: true });
  }

  await batch.commit();

  console.log("Seed completed for user:", userId);
  console.log("Collections seeded: users, transactions, monthly_summaries, budgets, goals, ai_chats, video_insights, learning_progress, badges, notifications, consultant_bookings, learning_modules, government_schemes, expert_consultants, daily_tips");
}

seedFirestore().catch((error) => {
  console.error("Seed failed.");
  if (String(error?.message || "").includes("Could not load the default credentials")) {
    console.error("No Firebase Admin credentials found.");
    console.error("Fix options:");
    console.error("1) Set FIREBASE_SERVICE_ACCOUNT_PATH in .env.local (absolute or project-relative path)");
    console.error("2) Set FIREBASE_SERVICE_ACCOUNT_KEY in .env.local (JSON string)");
    console.error("3) Place one of these files in project root: service-account.json, firebase-service-account.json, or serviceAccountKey.json");
  }
  console.error(error);
  process.exitCode = 1;
});
