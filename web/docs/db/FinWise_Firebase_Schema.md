# 🏦 FinWise — Firebase Firestore Database Schema
### Optimized for Flutter (Mobile) + Next.js (Web)
> **Database:** Firebase Firestore (NoSQL, Document-based)  
> **Auth:** Firebase Authentication  
> **Storage:** Firebase Storage  
> **Design Principles:** Denormalization for read performance, subcollections for scoped queries, summary docs to avoid full collection scans.

---

## 📐 Schema Overview (Collection Map)

```
Firestore Root
│
├── users/                          ← Per-user data (private)
│   └── {userId}/
│       ├── [User Profile Doc]
│       ├── transactions/           ← All expense entries
│       ├── monthly_summaries/      ← Pre-aggregated monthly stats ⚡
│       ├── budgets/                ← Monthly budget plans
│       ├── goals/                  ← Financial goals
│       ├── ai_chats/               ← AI chat sessions
│       ├── video_insights/         ← YouTube AI summaries
│       ├── learning_progress/      ← Per-module progress tracking
│       ├── quiz_results/           ← Quiz attempts & scores
│       ├── badges/                 ← Earned badges/rewards
│       ├── notifications/          ← Smart alerts & reminders
│       └── consultant_bookings/    ← Expert session bookings
│
├── learning_modules/               ← Global content (shared, read-only)
│   └── {moduleId}/
│       ├── [Module Doc]
│       ├── lessons/
│       └── quizzes/
│
├── government_schemes/             ← Global schemes (shared, read-only)
│
├── expert_consultants/             ← Consultant profiles
│   └── {consultantId}/
│       └── availability/
│
└── daily_tips/                     ← Global daily financial tips
```

---

## 1. 👤 `users/{userId}` — User Profile Document

> **Purpose:** Core profile, onboarding data, personalization engine input.  
> **Access:** Private — only the authenticated user.

```typescript
// Collection: users
// Document ID: Firebase Auth UID (auto)

{
  // ── Identity ──────────────────────────────────────────────
  uid:                  string,           // Firebase Auth UID (same as doc ID)
  email:                string,           // user@example.com
  displayName:          string,           // "Ravi Kumar"
  photoURL:             string | null,    // Firebase Storage URL
  phoneNumber:          string | null,    // +91XXXXXXXXXX
  isEmailVerified:      boolean,

  // ── Onboarding Profile ────────────────────────────────────
  occupationType:       "salaried" | "business" | "student" | "freelancer",
  incomeRange:          "0-10k" | "10k-25k" | "25k-50k" | "50k-100k" | "100k+",
  monthlyIncome:        number | null,    // Optional exact amount (₹)
  preferredLanguage:    string,           // "en" | "hi" | "mr" | "ta" | "te"
  topGoals:             string[],         // ["house", "emergency_fund", "vacation"]
  isOnboardingComplete: boolean,

  // ── App Settings ──────────────────────────────────────────
  currency:             string,           // "INR"
  notificationsEnabled: boolean,
  biometricEnabled:     boolean,
  theme:                "light" | "dark" | "system",

  // ── Personalization Cache ─────────────────────────────────
  // Denormalized for quick dashboard/AI context load
  currentMonthBudget:   number | null,    // ₹ total budget this month
  currentMonthSpent:    number,           // ₹ spent so far this month
  totalSavings:         number,           // ₹ cumulative savings tracked
  streakDays:           number,           // Learning streak count

  // ── Government Scheme Eligibility Tags ───────────────────
  // Pre-computed on profile update for scheme recommender
  eligibilityTags:      string[],         // ["pm_mudra", "jan_dhan", "startup_india"]

  // ── Timestamps ────────────────────────────────────────────
  createdAt:            Timestamp,
  updatedAt:            Timestamp,
  lastActiveAt:         Timestamp,
}
```

**🔑 Firestore Indexes:**
- `occupationType` + `preferredLanguage` → for content personalization queries

---

## 2. 💸 `users/{userId}/transactions/{txnId}` — Transactions

> **Purpose:** Every expense, income, or transfer entry.  
> **Optimization:** `monthly_summaries` sub-doc prevents scanning all transactions for dashboard stats.

```typescript
// Document ID: Auto-generated

{
  // ── Core Fields ───────────────────────────────────────────
  id:           string,           // Same as doc ID
  type:         "expense" | "income" | "transfer",
  amount:       number,           // Always positive (₹)
  currency:     string,           // "INR"

  // ── Categorization ────────────────────────────────────────
  category:     string,           // "food" | "transport" | "shopping" | "health"
                                  // | "entertainment" | "bills" | "salary" | "investment"
  subCategory:  string | null,    // "restaurant" | "grocery" | "fuel" | "emi"
  tags:         string[],         // ["weekend", "necessary", "impulse"]

  // ── Description ───────────────────────────────────────────
  title:        string,           // "Zomato order"
  note:         string | null,    // Optional user note
  merchantName: string | null,    // "Zomato", "Amazon", "HDFC Bank"

  // ── Source ────────────────────────────────────────────────
  source:       "manual" | "ocr_scan" | "csv_import" | "sms_parse",
  receiptURL:   string | null,    // Firebase Storage URL (for OCR scans)
  ocrRawText:   string | null,    // Raw OCR output (for audit/correction)

  // ── Payment Info ──────────────────────────────────────────
  paymentMethod: "cash" | "upi" | "card_debit" | "card_credit" | "netbanking" | "emi" | "other",
  accountLabel:  string | null,   // "HDFC Savings", "GPay"

  // ── Date & Time ───────────────────────────────────────────
  date:          Timestamp,       // Transaction date (user-provided or OCR-extracted)
  month:         string,          // "2025-07" (YYYY-MM) — for indexed monthly queries ⚡
  createdAt:     Timestamp,       // When logged in app
  updatedAt:     Timestamp,

  // ── AI Metadata ───────────────────────────────────────────
  aiCategorized: boolean,         // Was category auto-suggested by Gemini?
  isRecurring:   boolean,         // Netflix, EMI, etc.
  recurringId:   string | null,   // Links recurring entries
}
```

**🔑 Firestore Composite Indexes:**
- `month` ASC + `createdAt` DESC → Monthly transaction list
- `month` + `category` → Category-wise monthly breakdown
- `type` + `month` → Income vs expense filter
- `isRecurring` + `month` → Recurring expense view

---

## 3. 📊 `users/{userId}/monthly_summaries/{YYYY-MM}` — Monthly Aggregates ⚡

> **Purpose:** Pre-aggregated stats — avoids scanning 100s of transactions every dashboard load.  
> **Update Strategy:** Incremented on every transaction write via Cloud Functions or client-side batch write.

```typescript
// Document ID: "2025-07" (YYYY-MM format)

{
  month:          string,           // "2025-07"
  year:           number,           // 2025
  
  // ── Totals ────────────────────────────────────────────────
  totalIncome:    number,           // ₹ total income this month
  totalExpense:   number,           // ₹ total expenses this month
  totalSavings:   number,           // totalIncome - totalExpense
  savingsRate:    number,           // 0.0 - 1.0 (percentage)
  txnCount:       number,           // Total transaction count

  // ── Category Breakdown ────────────────────────────────────
  // Denormalized map for instant chart rendering
  categoryBreakdown: {
    food:           number,         // ₹
    transport:      number,
    shopping:       number,
    health:         number,
    entertainment:  number,
    bills:          number,
    investment:     number,
    other:          number,
  },

  // ── Budget Comparison ─────────────────────────────────────
  budgetId:       string | null,    // Ref to budget doc for this month
  budgetAmount:   number | null,    // ₹ budgeted
  budgetVariance: number | null,    // budgetAmount - totalExpense (negative = overspent)

  // ── AI Insight Cache ──────────────────────────────────────
  // Cached Gemini analysis — regenerated when data changes significantly
  aiInsightSummary:    string | null,   // "You spent 30% more on food this month..."
  aiInsightGeneratedAt: Timestamp | null,
  aiInsightVersion:    number,          // Increment to force re-generation

  // ── Timestamps ────────────────────────────────────────────
  createdAt:      Timestamp,
  updatedAt:      Timestamp,
}
```

---

## 4. 🎯 `users/{userId}/budgets/{budgetId}` — Monthly Budgets

> **Purpose:** AI-generated or user-set monthly spending plans.

```typescript
// Document ID: Auto-generated

{
  id:             string,
  month:          string,           // "2025-07"
  title:          string,           // "July 2025 Budget"
  totalBudget:    number,           // ₹ total monthly budget

  // ── Category Limits ───────────────────────────────────────
  categoryLimits: {
    food:           number,         // ₹ max allowed per category
    transport:      number,
    shopping:       number,
    health:         number,
    entertainment:  number,
    bills:          number,
    investment:     number,
    other:          number,
  },

  // ── Source ────────────────────────────────────────────────
  generatedBy:    "ai" | "manual" | "template",
  aiPromptContext: string | null,   // Gemini prompt used (for regeneration)

  // ── Status ────────────────────────────────────────────────
  isActive:       boolean,
  alertThreshold: number,           // 0.8 = alert at 80% of budget used

  createdAt:      Timestamp,
  updatedAt:      Timestamp,
}
```

---

## 5. 🏆 `users/{userId}/goals/{goalId}` — Financial Goals

> **Purpose:** Goal tracking with AI-driven suggestions and milestone alerts.

```typescript
// Document ID: Auto-generated

{
  id:               string,
  title:            string,           // "Emergency Fund", "New iPhone", "House Down Payment"
  emoji:            string,           // "🏠" "📱" "✈️"
  category:         "emergency_fund" | "vehicle" | "house" | "vacation"
                  | "education" | "gadget" | "wedding" | "retirement" | "custom",

  // ── Target & Progress ─────────────────────────────────────
  targetAmount:     number,           // ₹ goal amount
  currentAmount:    number,           // ₹ saved so far
  progressPercent:  number,           // 0-100 (denormalized for quick reads)

  // ── Timeline ──────────────────────────────────────────────
  startDate:        Timestamp,
  targetDate:       Timestamp,
  completedDate:    Timestamp | null,

  // ── Auto-contribution ─────────────────────────────────────
  monthlyContribution: number | null, // ₹ to save each month
  autoDeductFromBudget: boolean,

  // ── Status ────────────────────────────────────────────────
  status:           "active" | "completed" | "paused" | "abandoned",
  priority:         "low" | "medium" | "high",

  // ── AI Suggestions ────────────────────────────────────────
  aiSuggestion:     string | null,    // "At this pace, you'll reach your goal by Sep 2026"
  aiSuggestionAt:   Timestamp | null,

  // ── Milestones (embedded array — max ~5) ──────────────────
  milestones: [
    {
      percent:    number,             // 25, 50, 75, 100
      reached:    boolean,
      reachedAt:  Timestamp | null,
      celebrated: boolean,
    }
  ],

  createdAt:        Timestamp,
  updatedAt:        Timestamp,
}
```

---

## 6. 🤖 `users/{userId}/ai_chats/{sessionId}` — AI Chat Sessions

> **Purpose:** Persistent conversation history for Gemini AI assistant.  
> **Optimization:** Messages embedded as array (cap at last 50 messages). Older sessions archived with `isArchived: true`.

```typescript
// Document ID: Auto-generated

{
  id:         string,
  title:      string,           // "Budget Planning - July", auto-generated from first message
  mode:       "general" | "budget" | "investment" | "expense_analysis",
  isArchived: boolean,

  // ── Context Snapshot (sent with every Gemini call) ────────
  // Denormalized user context for prompt engineering
  contextSnapshot: {
    occupationType:   string,
    incomeRange:      string,
    monthlyIncome:    number | null,
    currentMonthSpent: number,
    currentMonthBudget: number | null,
    topGoals:         string[],
  },

  // ── Messages (embedded — max 50) ──────────────────────────
  messages: [
    {
      id:         string,             // uuid
      role:       "user" | "model",
      content:    string,
      timestamp:  Timestamp,
      tokensUsed: number | null,      // For usage tracking
    }
  ],

  messageCount:   number,
  lastMessageAt:  Timestamp,
  createdAt:      Timestamp,
}
```

**🔑 Index:** `isArchived` + `lastMessageAt` DESC → Recent chats list

---

## 7. 🎥 `users/{userId}/video_insights/{insightId}` — YouTube AI Insights

> **Purpose:** Store Gemini-analyzed YouTube video summaries.  
> **Dedup Strategy:** `videoId` field prevents re-analyzing the same video.

```typescript
// Document ID: Auto-generated

{
  id:           string,
  videoId:      string,         // YouTube video ID (e.g., "dQw4w9WgXcQ")
  videoURL:     string,         // Full YouTube URL
  videoTitle:   string,         // Fetched from YouTube API
  channelName:  string | null,
  thumbnailURL: string | null,
  videoDurationSec: number | null,

  // ── AI Output ─────────────────────────────────────────────
  summary:       string,        // 2-3 line summary
  keyTips:       string[],      // ["Invest 20% of income", "Start SIP early"]
  actionPoints:  string[],      // ["Open Groww account", "Set ₹500 SIP today"]
  
  // ── Relevance to User ─────────────────────────────────────
  relevanceScore:  number | null,   // 0.0 - 1.0, Gemini-assessed relevance
  relatedGoals:    string[],        // Goal IDs this video is relevant to
  relatedCategory: string | null,   // "investment" | "budgeting" | "tax_saving"

  // ── Metadata ──────────────────────────────────────────────
  analyzedAt:     Timestamp,
  geminiModel:    string,       // "gemini-1.5-flash" (for version tracking)
  transcriptLength: number | null,  // characters

  createdAt:      Timestamp,
}
```

---

## 8. 🎓 `users/{userId}/learning_progress/{moduleId}` — Learning Progress

> **Purpose:** Per-user progress tracker for each learning module.  
> **Doc ID:** Same as `learning_modules/{moduleId}` for easy cross-reference.

```typescript
// Document ID: Same as learning_modules doc ID

{
  moduleId:       string,
  userId:         string,

  // ── Progress ──────────────────────────────────────────────
  status:           "not_started" | "in_progress" | "completed",
  completedLessons: string[],     // Array of lesson IDs completed
  totalLessons:     number,       // Denormalized from module doc
  progressPercent:  number,       // 0-100

  // ── Quiz ──────────────────────────────────────────────────
  quizAttempts:     number,
  bestQuizScore:    number | null,   // 0-100
  lastQuizScore:    number | null,
  quizPassed:       boolean,

  // ── Engagement ────────────────────────────────────────────
  totalTimeSpentSec: number,
  lastAccessedAt:    Timestamp,
  completedAt:       Timestamp | null,

  createdAt:         Timestamp,
  updatedAt:         Timestamp,
}
```

---

## 9. 🏅 `users/{userId}/badges/{badgeId}` — Earned Badges

```typescript
// Document ID: badge slug (e.g., "first_transaction", "streak_7")

{
  badgeId:      string,           // "streak_7", "first_goal", "savings_champion"
  title:        string,           // "7-Day Streak"
  description:  string,           // "Logged expenses 7 days in a row"
  emoji:        string,           // "🔥"
  category:     "learning" | "savings" | "streak" | "goals" | "social",
  earnedAt:     Timestamp,
  isNew:        boolean,          // For "new badge" notification
}
```

---

## 10. 🔔 `users/{userId}/notifications/{notifId}` — Smart Alerts

```typescript
// Document ID: Auto-generated

{
  id:       string,
  type:     "overspend_warning" | "budget_alert" | "goal_milestone"
          | "streak_reminder" | "daily_tip" | "scheme_recommendation"
          | "bill_reminder" | "badge_earned",

  title:    string,             // "You've spent 80% of your food budget!"
  body:     string,             // Detailed message
  emoji:    string | null,
  deepLink: string | null,      // e.g., "/goals/goalId" — for in-app navigation

  // ── Reference ─────────────────────────────────────────────
  refType:  "goal" | "budget" | "transaction" | "scheme" | "badge" | null,
  refId:    string | null,

  isRead:   boolean,
  readAt:   Timestamp | null,
  createdAt: Timestamp,
}
```

**🔑 Index:** `isRead` + `createdAt` DESC → Unread notifications list

---

## 11. 📚 `learning_modules/{moduleId}` — Global Learning Content

> **Purpose:** Shared content library — NOT per-user, read-only for clients.  
> **Populated by:** Admin dashboard (CMS).

```typescript
// Document ID: Slug (e.g., "salary-management-basics")

{
  id:            string,
  title:         string,            // "Salary Management Basics"
  description:   string,
  emoji:         string,            // "💼"
  coverImageURL: string | null,

  // ── Targeting ─────────────────────────────────────────────
  targetOccupation: string[],       // ["salaried"] or ["student", "freelancer"]
  targetIncomeRange: string[],      // ["10k-25k", "25k-50k"]
  difficulty:       "beginner" | "intermediate" | "advanced",
  language:         string,         // "en" | "hi" (one doc per language)
  tags:             string[],       // ["tax", "saving", "epf", "salary"]
  category:         string,         // "tax_saving" | "budgeting" | "investment" | "basics"

  // ── Content Structure ─────────────────────────────────────
  lessonCount:   number,            // Denormalized
  estimatedMins: number,            // Total read time
  hasQuiz:       boolean,
  passingScore:  number,            // e.g., 70 (%)

  // ── Ordering & Discoverability ────────────────────────────
  sortOrder:     number,
  isFeatured:    boolean,
  isPublished:   boolean,

  // ── Stats (updated periodically) ──────────────────────────
  totalEnrollments: number,
  avgCompletionRate: number,        // 0.0 - 1.0

  createdAt:     Timestamp,
  updatedAt:     Timestamp,
}
```

### 11a. `learning_modules/{moduleId}/lessons/{lessonId}`

```typescript
{
  id:          string,
  moduleId:    string,
  title:       string,            // "What is EPF?"
  content:     string,            // Markdown text
  contentType: "text" | "video" | "infographic",
  videoURL:    string | null,
  imageURL:    string | null,
  sortOrder:   number,
  readTimeSec: number,
  createdAt:   Timestamp,
}
```

### 11b. `learning_modules/{moduleId}/quizzes/{quizId}`

```typescript
{
  id:        string,
  moduleId:  string,
  questions: [
    {
      id:            string,
      questionText:  string,
      options:       string[],    // Array of 4 options
      correctIndex:  number,      // 0-3
      explanation:   string,      // Shown after answer
    }
  ],
  totalQuestions: number,
  passingScore:   number,         // %
  createdAt:      Timestamp,
}
```

---

## 12. 🏛️ `government_schemes/{schemeId}` — Government Scheme Recommender

> **Purpose:** Curated database of government financial schemes.  
> **Filter:** Matched against user `eligibilityTags` on the profile.

```typescript
// Document ID: Slug (e.g., "pm-mudra-yojana")

{
  id:          string,
  name:        string,              // "PM Mudra Yojana"
  fullName:    string,              // "Pradhan Mantri MUDRA Yojana"
  ministry:    string,              // "Ministry of Finance"
  emoji:       string,              // "🏦"
  tagline:     string,              // "Loans up to ₹10L for small businesses"
  description: string,              // Full description (Markdown)
  logoURL:     string | null,
  officialURL: string,              // gov.in link

  // ── Eligibility ───────────────────────────────────────────
  eligibilityTags:   string[],      // ["business", "low_income", "rural"]
  targetOccupation:  string[],      // ["business", "freelancer"]
  incomeRangeMin:    string | null, // "0-10k"
  incomeRangeMax:    string | null, // "25k-50k"

  // ── Benefit Details ───────────────────────────────────────
  benefitType:       "loan" | "subsidy" | "insurance" | "pension" | "savings" | "education",
  maxBenefit:        string,        // "₹10,00,000 loan"
  applicationMode:   "online" | "offline" | "both",
  applicationURL:    string | null,

  // ── Status ────────────────────────────────────────────────
  isActive:          boolean,
  launchYear:        number,
  lastVerifiedAt:    Timestamp,

  // ── Multilingual ──────────────────────────────────────────
  // Separate docs per language OR embed translations map
  translations: {
    hi: { name: string, tagline: string, description: string },
    mr: { name: string, tagline: string, description: string },
  } | null,

  createdAt:         Timestamp,
  updatedAt:         Timestamp,
}
```

---

## 13. 👨‍💼 `expert_consultants/{consultantId}` — Expert Connect

```typescript
{
  id:             string,
  name:           string,
  photoURL:       string | null,
  designation:    string,           // "SEBI-Registered Investment Advisor"
  specializations: string[],        // ["mutual_funds", "tax_planning", "retirement"]
  languages:      string[],         // ["en", "hi"]
  bio:            string,
  experience:     number,           // Years

  // ── Session Info ──────────────────────────────────────────
  sessionFeeINR:  number,           // ₹ per session
  sessionDurMins: number,           // 30 | 45 | 60
  meetMode:       string[],         // ["video", "audio", "chat"]

  // ── Ratings ───────────────────────────────────────────────
  avgRating:      number,           // 1.0 - 5.0
  totalReviews:   number,
  totalSessions:  number,

  isActive:       boolean,
  createdAt:      Timestamp,
}
```

### 13a. `expert_consultants/{consultantId}/availability/{slotId}`

```typescript
{
  id:        string,
  startTime: Timestamp,
  endTime:   Timestamp,
  isBooked:  boolean,
  bookedBy:  string | null,     // userId
}
```

### 13b. `users/{userId}/consultant_bookings/{bookingId}`

```typescript
{
  id:             string,
  consultantId:   string,
  consultantName: string,         // Denormalized for display
  slotId:         string,
  scheduledAt:    Timestamp,
  durationMins:   number,
  meetLink:       string | null,
  feeINR:         number,
  paymentStatus:  "pending" | "paid" | "refunded",
  status:         "upcoming" | "completed" | "cancelled",
  userNotes:      string | null,  // What user wants to discuss
  sessionNotes:   string | null,  // Post-session notes by consultant
  rating:         number | null,
  review:         string | null,
  createdAt:      Timestamp,
}
```

---

## 14. 💡 `daily_tips/{tipId}` — Daily Financial Tips

```typescript
// Document ID: Slug or YYYY-MM-DD

{
  id:               string,
  date:             string,         // "2025-07-15"
  tip:              string,         // Short tip text
  category:         string,         // "saving" | "investment" | "tax" | "budgeting"
  targetOccupation: string[],       // ["salaried"] | ["all"]
  language:         string,
  emoji:            string,
  source:           string | null,  // Attribution
  createdAt:        Timestamp,
}
```

---

## ⚡ Optimization Strategy

### 1. Pre-Aggregated Summary Documents
Monthly dashboards read from `monthly_summaries/{YYYY-MM}` — **NOT** scanning all transactions. Update via Cloud Functions on each transaction write.

### 2. Denormalized Fields on User Profile
`currentMonthSpent`, `currentMonthBudget`, `totalSavings`, `eligibilityTags` — updated atomically. Eliminates joins on app load.

### 3. Composite Indexes Required
| Collection | Fields | Use Case |
|---|---|---|
| `transactions` | `month` ASC + `createdAt` DESC | Monthly list |
| `transactions` | `month` + `category` | Category breakdown |
| `transactions` | `type` + `month` | Income vs expense |
| `ai_chats` | `isArchived` + `lastMessageAt` DESC | Recent chats |
| `notifications` | `isRead` + `createdAt` DESC | Unread alerts |
| `government_schemes` | `isActive` + `eligibilityTags` | Scheme recommender |

### 4. Caching AI Responses
- `monthly_summaries.aiInsightSummary` caches Gemini expense analysis
- `goals.aiSuggestion` caches goal advice
- Regenerate only when `aiInsightVersion` is incremented (on significant data change)

### 5. Document Size Limits
- `ai_chats` messages array capped at **50 messages** — paginate older sessions
- `transactions` never embed large blobs — OCR images go to Firebase Storage, only URL stored
- `learning_modules` content stored in `lessons` subcollection, not in parent doc

### 6. Security Rules Pattern
```
match /users/{userId}/{document=**} {
  allow read, write: if request.auth.uid == userId;
}
match /learning_modules/{document=**} {
  allow read: if request.auth != null;
  allow write: if false; // Admin SDK only
}
match /government_schemes/{document=**} {
  allow read: if request.auth != null;
  allow write: if false;
}
```

---

## 📦 Firebase Storage Structure

```
finwise-storage/
│
├── users/{userId}/
│   ├── profile/
│   │   └── avatar.jpg
│   └── receipts/
│       └── {txnId}.jpg         ← OCR scanned bills
│
├── learning/
│   └── {moduleId}/
│       └── {lessonId}/
│           └── cover.jpg
│
└── consultants/
    └── {consultantId}/
        └── photo.jpg
```

---

## 🔄 Data Flow Summary

```
User Action              → Firestore Writes
──────────────────────────────────────────────────────────
Add Transaction          → transactions/{txnId}
                           monthly_summaries/{YYYY-MM}  (increment)
                           users/{userId}.currentMonthSpent (increment)

Complete Onboarding      → users/{userId} (full profile)
                           eligibilityTags computed + written

AI Chat Message          → ai_chats/{sessionId}.messages (append)
                           ai_chats/{sessionId}.lastMessageAt

Complete Learning Module → learning_progress/{moduleId}.status = "completed"
                           badges/{badgeId} (if badge earned)
                           users/{userId}.streakDays (increment)

Set Goal                 → goals/{goalId}
Add Goal Contribution    → goals/{goalId}.currentAmount (increment)
                           transactions/{txnId} (type: "transfer")

YouTube Insight          → video_insights/{insightId}
```

---

*Schema Version: 1.0 | FinWise | Optimized for Firebase Firestore*  
*Designed for Flutter (Mobile) + Next.js (Web)*
