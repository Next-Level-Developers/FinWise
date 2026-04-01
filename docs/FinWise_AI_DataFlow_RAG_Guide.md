# 🤖 FinWise — AI API Data Flow & RAG Readiness Guide
### Version 1.0 | Gemini AI + Firebase Firestore Integration

> **Purpose:** This document defines every AI-powered endpoint in FinWise — what Firestore data flows into the AI, what the AI outputs, how results are cached, and how each feature can be upgraded with Retrieval-Augmented Generation (RAG).  
> **AI Engine:** Google Gemini API (`gemini-1.5-flash` / `gemini-1.5-pro`)  
> **PII Policy:** Personal Identifiable Information (email, phone, displayName, photoURL) is **never** sent to AI models.  
> **Cache Strategy:** AI responses are cached in Firestore to reduce redundant API calls and cost.

---

## 📋 Table of Contents

1. [Expense Insight Analysis](#1-expense-insight-analysis)
2. [AI Budget Generator](#2-ai-budget-generator)
3. [AI Chat Assistant](#3-ai-chat-assistant)
4. [Goal Advisor](#4-goal-advisor)
5. [YouTube Video Insight Analyzer](#5-youtube-video-insight-analyzer)
6. [Government Scheme Recommender](#6-government-scheme-recommender)
7. [Expense Prediction Engine](#7-expense-prediction-engine)
8. [OCR Transaction Categorizer](#8-ocr-transaction-categorizer)
9. [Learning Path Personalizer](#9-learning-path-personalizer)
10. [Smart Alert Trigger Engine](#10-smart-alert-trigger-engine)
11. [RAG Architecture Overview](#11-rag-architecture-overview)
12. [PII Safety Reference](#12-pii-safety-reference)
13. [Cache & Cost Optimization Summary](#13-cache--cost-optimization-summary)

---

## 1. Expense Insight Analysis

**Endpoint:** `POST /api/ai/expense-insights`

| Layer | Details |
|-------|---------|
| Insight Type | `expense_insights` |
| Cache TTL | 24 hours (or until `aiInsightVersion` is incremented) |
| Trigger | User opens dashboard / month summary view |

**Firestore Collections Read:**

| Collection | Fields Passed to AI | Purpose |
|---|---|---|
| `users/{userId}` | `occupationType`, `incomeRange`, `monthlyIncome`, `currentMonthBudget`, `currentMonthSpent` | User financial context |
| `users/{userId}/monthly_summaries/{YYYY-MM}` | `totalIncome`, `totalExpense`, `totalSavings`, `savingsRate`, `categoryBreakdown`, `budgetAmount`, `budgetVariance`, `txnCount` | Aggregated monthly spend data |
| `users/{userId}/transactions` (last 30, current month) | `type`, `amount`, `category`, `subCategory`, `tags`, `paymentMethod`, `date`, `isRecurring`, `source` | Transaction-level patterns |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `photoURL`, `uid`
- `title` (merchant-level transaction notes may contain PII)

**AI Output Shape:**

```json
{
  "summary": "You spent ₹3,200 more on food this month compared to last month.",
  "topCategories": [
    { "category": "food", "amount": 8500, "percentOfTotal": 34, "trend": "up" },
    { "category": "shopping", "amount": 5200, "percentOfTotal": 21, "trend": "down" }
  ],
  "savingsHealth": "poor",
  "savingsRateComment": "Your savings rate of 8% is below the recommended 20% for your income range.",
  "anomalies": ["3 large transactions above ₹2,000 in entertainment this week"],
  "recommendations": [
    "Cut dining out by 2 meals/week to save ₹1,500",
    "Your grocery spend is well within budget — keep it up!"
  ],
  "nextMonthForecast": {
    "estimatedExpense": 27000,
    "confidence": 0.78
  }
}
```

**Written to Firestore:**
- `/users/{userId}/monthly_summaries/{YYYY-MM}` → `aiInsightSummary`, `aiInsightGeneratedAt`, `aiInsightVersion`

**RAG Notes:**

Strong RAG candidate. Embed per-user monthly summary documents (past 6–12 months) into a vector store, keyed by `userId`. At inference time, retrieve the 3–5 most relevant past months (by similar income range, same season, or similar categoryBreakdown pattern) to ground comparisons.  
Fields to embed: `month` + `totalIncome` + `totalExpense` + `savingsRate` + `categoryBreakdown` + `occupationType`.

---

## 2. AI Budget Generator

**Endpoint:** `POST /api/ai/generate-budget`

| Layer | Details |
|-------|---------|
| Insight Type | `budget_generation` |
| Cache TTL | Per budget document (regenerate only if user requests) |
| Trigger | User taps "Generate Budget with AI" or starts a new month |

**Firestore Collections Read:**

| Collection | Fields Passed to AI | Purpose |
|---|---|---|
| `users/{userId}` | `occupationType`, `incomeRange`, `monthlyIncome`, `topGoals`, `currentMonthSpent` | Income and lifestyle context |
| `users/{userId}/monthly_summaries` (last 3 months) | `totalIncome`, `totalExpense`, `categoryBreakdown`, `savingsRate` | Historical spend baseline |
| `users/{userId}/goals` (active only) | `category`, `targetAmount`, `currentAmount`, `targetDate`, `monthlyContribution`, `priority` | Goal-based budget allocation |
| `users/{userId}/budgets` (last 1 month) | `totalBudget`, `categoryLimits`, `budgetVariance` | Prior budget performance |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `uid`
- Goal `title` (may contain personal info like "Ravi's Wedding Fund")

**AI Output Shape:**

```json
{
  "totalBudget": 40000,
  "categoryLimits": {
    "food": 7000,
    "transport": 3500,
    "shopping": 4000,
    "health": 2000,
    "entertainment": 2500,
    "bills": 8000,
    "investment": 6000,
    "other": 2000
  },
  "reasoning": "Based on your past 3-month average spend and your emergency fund goal, I've allocated ₹6,000 to investments.",
  "goalAllocations": [
    { "goalCategory": "emergency_fund", "monthlyContribution": 3000 }
  ],
  "savingsTarget": 5000,
  "alertThreshold": 0.8,
  "tips": [
    "Your food spend has been consistently high — setting a ₹7,000 cap helps.",
    "Bills are fixed — no changes needed there."
  ]
}
```

**Written to Firestore:**
- `/users/{userId}/budgets/{budgetId}` → full budget document
- `generatedBy: "ai"`, `aiPromptContext` → stored for regeneration reference

**RAG Notes:**

Good RAG candidate. Embed anonymized budget templates by occupation type and income range into a shared vector store. At generation time, retrieve 3–5 similar user budget profiles (same `occupationType` + `incomeRange` + `topGoals`) to inform suggested category limits. This prevents Gemini from generating unrealistic budgets for new users with no history.  
Fields to embed: `occupationType` + `incomeRange` + `topGoals` + `categoryBreakdown` + `savingsRate`.

---

## 3. AI Chat Assistant

**Endpoint:** `POST /api/ai/chat`

| Layer | Details |
|-------|---------|
| Insight Type | `chat_message` |
| Cache TTL | No cache — real-time conversational |
| Trigger | User sends a message in the AI Chat screen |

**Firestore Collections Read:**

| Collection | Fields Passed to AI | Purpose |
|---|---|---|
| `users/{userId}/ai_chats/{sessionId}` | `mode`, `contextSnapshot` (full), `messages` (last 20) | Conversation history + user context |
| `users/{userId}/monthly_summaries/{current month}` | `totalIncome`, `totalExpense`, `totalSavings`, `categoryBreakdown`, `budgetAmount` | Live financial snapshot |
| `users/{userId}/goals` (active) | `category`, `targetAmount`, `currentAmount`, `targetDate`, `status` | Goal context for planning questions |
| `users/{userId}/budgets/{current}` | `totalBudget`, `categoryLimits` | Budget awareness |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `uid`
- Individual transaction `title`, `merchantName`, `note` (may contain PII)

**System Prompt Context Shape (sent on every call):**

```json
{
  "userContext": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "monthlyIncome": 42000,
    "currentMonthSpent": 31500,
    "currentMonthBudget": 38000,
    "topGoals": ["emergency_fund", "vacation"],
    "preferredLanguage": "en"
  },
  "financialSnapshot": {
    "totalExpense": 31500,
    "totalIncome": 42000,
    "totalSavings": 10500,
    "savingsRate": 0.25,
    "categoryBreakdown": { "food": 8500, "transport": 3000 }
  }
}
```

**AI Output Shape:**

```json
{
  "reply": "Based on your ₹42,000 income and ₹31,500 spent so far, you have ₹10,500 left. If you skip dining out twice this week, you can hit your ₹10,000 savings target easily!",
  "suggestedActions": ["View your food expenses", "Update your goal"],
  "followUpSuggestions": ["How can I reduce transport costs?", "Show me my savings trend"]
}
```

**Written to Firestore:**
- `/users/{userId}/ai_chats/{sessionId}.messages` → append new user + model messages
- `/users/{userId}/ai_chats/{sessionId}.lastMessageAt` → updated

**RAG Notes:**

Moderate RAG candidate. For the `investment` and `budget` chat modes, RAG can inject relevant learning module content (lessons on SIP, EPF, tax-saving) into the system prompt based on the user's question intent. Embed `learning_modules` lesson content into a shared vector store. Retrieve top 2–3 relevant lesson chunks when the user asks an educational finance question.  
Fields to embed: lesson `content` + `tags` + `category` + `targetOccupation`.

---

## 4. Goal Advisor

**Endpoint:** `POST /api/ai/goal-advice`

| Layer | Details |
|-------|---------|
| Insight Type | `goal_advice` |
| Cache TTL | 3 days (or when `currentAmount` changes significantly) |
| Trigger | User opens a goal detail page or requests AI advice |

**Firestore Collections Read:**

| Collection | Fields Passed to AI | Purpose |
|---|---|---|
| `users/{userId}` | `occupationType`, `incomeRange`, `monthlyIncome` | Income capacity context |
| `users/{userId}/goals/{goalId}` | `category`, `targetAmount`, `currentAmount`, `progressPercent`, `startDate`, `targetDate`, `monthlyContribution`, `status`, `priority` | Goal-specific data |
| `users/{userId}/monthly_summaries` (last 3 months) | `totalSavings`, `savingsRate`, `totalIncome`, `totalExpense` | Savings capacity assessment |
| `users/{userId}/budgets/{current}` | `totalBudget`, `categoryLimits.investment` | Available budget headroom |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `uid`
- Goal `title` (replaced by `category` for AI context)

**AI Output Shape:**

```json
{
  "projectedCompletionDate": "2026-03-15",
  "isOnTrack": false,
  "shortfallAmount": 12000,
  "requiredMonthlySaving": 4500,
  "currentMonthlySaving": 3000,
  "advice": "At your current saving rate of ₹3,000/month, you'll miss your target by about 4 months. Increasing by ₹1,500/month puts you back on track.",
  "strategies": [
    "Reduce entertainment budget by ₹1,000 and redirect to this goal",
    "Set up auto-deduction on salary day to avoid spending the amount"
  ],
  "milestoneMessage": "You're 42% there — great progress! The next milestone is ₹50,000.",
  "riskLevel": "medium"
}
```

**Written to Firestore:**
- `/users/{userId}/goals/{goalId}` → `aiSuggestion`, `aiSuggestionAt`

**RAG Notes:**

Good RAG candidate. Embed historical goal records (completed or abandoned) into a vector store. Retrieve 3–5 similar goals by `category` + `incomeRange` + `targetAmount` to surface realistic timelines and proven strategies. Example: "Users with similar emergency fund goals at your income level typically complete in 9–11 months."  
Fields to embed: `category` + `targetAmount` + `incomeRange` + `monthlyContribution` + `status` + `completedDate`.

---

## 5. YouTube Video Insight Analyzer

**Endpoint:** `POST /api/ai/video-insights`

| Layer | Details |
|-------|---------|
| Insight Type | `video_insights` |
| Cache TTL | Permanent (per `videoId` — same video never re-analyzed) |
| Trigger | User pastes a YouTube URL and taps "Analyze" |

**External API Calls (before Gemini):**

| Step | API | Purpose |
|------|-----|---------|
| 1 | YouTube Data API v3 | Fetch `videoTitle`, `channelName`, `thumbnailURL`, `videoDurationSec` |
| 2 | YouTube Transcript API | Fetch full video transcript text |

**Firestore Collections Read:**

| Collection | Fields Passed to AI | Purpose |
|---|---|---|
| `users/{userId}` | `occupationType`, `incomeRange`, `topGoals`, `preferredLanguage` | Personalize relevance scoring |
| `users/{userId}/video_insights` | `videoId` | Deduplication check — skip if already analyzed |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `uid`

**Payload sent to Gemini:**

```json
{
  "transcript": "<full transcript text>",
  "videoTitle": "How to invest ₹5000/month in 2024",
  "userContext": {
    "occupationType": "salaried",
    "topGoals": ["emergency_fund", "investment"],
    "incomeRange": "25k-50k"
  }
}
```

**AI Output Shape:**

```json
{
  "summary": "The video explains how to build a diversified investment portfolio starting with ₹5,000/month, focusing on index funds and SIPs for long-term wealth.",
  "keyTips": [
    "Invest at least 20% of monthly income",
    "Start a Nifty 50 index fund SIP for low-risk growth",
    "Avoid timing the market — stay consistent"
  ],
  "actionPoints": [
    "Open a Zerodha or Groww account today",
    "Start a ₹500/month SIP in any index fund",
    "Set up auto-invest on salary credit date"
  ],
  "relevanceScore": 0.91,
  "relatedGoals": ["goalId_xyz"],
  "relatedCategory": "investment"
}
```

**Written to Firestore:**
- `/users/{userId}/video_insights/{insightId}` → full insight document

**RAG Notes:**

Excellent RAG candidate. Embed past video insights (keyTips + actionPoints) into a per-user vector store. When a user asks the AI Chat a finance question, retrieve top 2–3 relevant past video insights to include as grounding context. This turns video insights into a personalized knowledge base.  
Fields to embed: `keyTips` + `actionPoints` + `relatedCategory` + `summary`.

---

## 6. Government Scheme Recommender

**Endpoint:** `POST /api/ai/scheme-recommend`

| Layer | Details |
|-------|---------|
| Insight Type | `scheme_recommendation` |
| Cache TTL | 7 days (or when user profile changes) |
| Trigger | User visits Scheme Recommender tab or updates profile |

**Firestore Collections Read:**

| Collection | Fields Passed to AI | Purpose |
|---|---|---|
| `users/{userId}` | `occupationType`, `incomeRange`, `monthlyIncome`, `topGoals`, `eligibilityTags` | User eligibility profile |
| `government_schemes` (all active) | `name`, `fullName`, `eligibilityTags`, `targetOccupation`, `incomeRangeMin`, `incomeRangeMax`, `benefitType`, `maxBenefit`, `tagline`, `applicationMode` | Scheme pool for matching |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `uid`
- `address`, `aadhaarNumber` (never stored in FinWise)

**AI Output Shape:**

```json
{
  "recommendations": [
    {
      "schemeId": "pm-mudra-yojana",
      "name": "PM Mudra Yojana",
      "matchScore": 0.94,
      "matchReason": "You're a business owner in the ₹10k-25k income range — Mudra loans are designed exactly for you.",
      "suggestedAction": "Apply online at mudra.org.in",
      "urgency": "high"
    },
    {
      "schemeId": "jan-dhan-yojana",
      "name": "Pradhan Mantri Jan Dhan Yojana",
      "matchScore": 0.81,
      "matchReason": "Eligible based on your income range. Provides zero-balance savings account with accident insurance.",
      "suggestedAction": "Visit your nearest bank branch",
      "urgency": "medium"
    }
  ],
  "totalSchemesFetched": 12,
  "totalMatched": 4
}
```

**Written to Firestore:**
- `/users/{userId}/notifications/{notifId}` → `type: "scheme_recommendation"` notification for top match
- `users/{userId}.eligibilityTags` → re-computed if profile has changed

**RAG Notes:**

Moderate RAG candidate. Embed scheme descriptions and eligibility criteria into a shared vector store. Use semantic search to match user profile fields against scheme content — this handles edge cases where `eligibilityTags` don't exactly match but the scheme description is contextually relevant.  
Fields to embed: `description` + `eligibilityTags` + `targetOccupation` + `benefitType` + `tagline`.

---

## 7. Expense Prediction Engine

**Endpoint:** `POST /api/ai/predict-expenses`

| Layer | Details |
|-------|---------|
| Insight Type | `expense_prediction` |
| Cache TTL | 7 days (refreshed at start of new month) |
| Trigger | User views "Next Month Forecast" card on dashboard |

**Firestore Collections Read:**

| Collection | Fields Passed to AI | Purpose |
|---|---|---|
| `users/{userId}` | `occupationType`, `incomeRange`, `monthlyIncome` | Income baseline |
| `users/{userId}/monthly_summaries` (last 6 months) | `month`, `totalIncome`, `totalExpense`, `totalSavings`, `categoryBreakdown`, `savingsRate` | Historical spending trend |
| `users/{userId}/transactions` (recurring only: `isRecurring: true`) | `amount`, `category`, `paymentMethod` | Fixed recurring costs |
| `users/{userId}/budgets/{next month if exists}` | `totalBudget`, `categoryLimits` | Planned budget context |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `uid`
- Transaction `title`, `merchantName`, `note`

**AI Output Shape:**

```json
{
  "predictedTotalExpense": 29500,
  "confidence": 0.82,
  "categoryForecasts": {
    "food": { "predicted": 8200, "trend": "stable", "changePercent": 3 },
    "transport": { "predicted": 3100, "trend": "up", "changePercent": 12 },
    "shopping": { "predicted": 4500, "trend": "down", "changePercent": -8 },
    "bills": { "predicted": 7800, "trend": "stable", "changePercent": 0 }
  },
  "warnings": [
    "Your transport spend has been rising 10–15% monthly — watch out.",
    "December historically shows a spike in shopping for you."
  ],
  "savingsProjection": 12500,
  "recommendedBudgetAdjustments": [
    "Increase transport budget by ₹500 based on trend",
    "Shopping budget can safely be reduced by ₹1,000"
  ]
}
```

**Written to Firestore:**
- `/users/{userId}/monthly_summaries/{next month}` → `aiInsightSummary` (prediction note), `aiInsightGeneratedAt`

**RAG Notes:**

Strong RAG candidate. Embed 6-month rolling summaries per user into a time-series vector store. Retrieve similar historical periods (same month in prior years, or months with similar income/spending patterns) to improve forecast accuracy. Seasonal patterns (Diwali shopping, year-end bills) can be captured via RAG context rather than hard-coded rules.  
Fields to embed: `month` + `totalExpense` + `categoryBreakdown` + `savingsRate` + `occupationType`.

---

## 8. OCR Transaction Categorizer

**Endpoint:** `POST /api/ai/ocr-categorize`

| Layer | Details |
|-------|---------|
| Insight Type | `ocr_categorization` |
| Cache TTL | No cache — per-scan, real-time |
| Trigger | User scans a bill/receipt via camera (Google ML Kit → Gemini) |

**Input to API:**

| Source | Data | Purpose |
|--------|------|---------|
| Google ML Kit (on-device) | `ocrRawText` (extracted text from bill image) | Raw receipt content |
| `users/{userId}` | `preferredLanguage`, `occupationType` | Localization + context |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `uid`
- Receipt image itself — only ML Kit-extracted text is sent to Gemini

**Payload sent to Gemini:**

```json
{
  "ocrRawText": "ZOMATO INDIA\nOrder #ZOM998821\nItem: Butter Chicken x2 - ₹480\nDelivery - ₹40\nTotal: ₹520\nDate: 12 Jul 2025",
  "userOccupation": "salaried"
}
```

**AI Output Shape:**

```json
{
  "amount": 520,
  "currency": "INR",
  "category": "food",
  "subCategory": "restaurant",
  "merchantName": "Zomato",
  "title": "Zomato Order",
  "date": "2025-07-12",
  "paymentMethod": "upi",
  "tags": ["delivery", "food_order"],
  "confidence": 0.95,
  "needsUserReview": false
}
```

**Written to Firestore:**
- `/users/{userId}/transactions/{txnId}` → new transaction document with `aiCategorized: true`, `source: "ocr_scan"`, `ocrRawText`
- `/users/{userId}/monthly_summaries/{YYYY-MM}` → incremented totals

**RAG Notes:**

Low RAG priority for MVP. Future enhancement: embed the user's past OCR-corrected transactions to learn their personal merchant-to-category mappings (e.g., user always re-categorizes "Amazon" from "shopping" to "home_supplies"). Retrieve top 5 similar past merchant names to pre-fill corrections.  
Fields to embed: `merchantName` + `category` + `subCategory` + `tags` (user-corrected entries only).

---

## 9. Learning Path Personalizer

**Endpoint:** `POST /api/ai/learning-path`

| Layer | Details |
|-------|---------|
| Insight Type | `learning_path` |
| Cache TTL | 14 days (or when user profile changes) |
| Trigger | User completes onboarding or requests "What should I learn next?" |

**Firestore Collections Read:**

| Collection | Fields Passed to AI | Purpose |
|---|---|---|
| `users/{userId}` | `occupationType`, `incomeRange`, `topGoals`, `preferredLanguage`, `streakDays` | Learner profile |
| `users/{userId}/learning_progress` (all) | `moduleId`, `status`, `progressPercent`, `bestQuizScore`, `quizPassed` | Completed & in-progress modules |
| `users/{userId}/badges` | `badgeId`, `category` | Engagement level proxy |
| `learning_modules` (published, matching language) | `id`, `title`, `targetOccupation`, `targetIncomeRange`, `difficulty`, `tags`, `category`, `estimatedMins`, `hasQuiz` | Available module pool |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `uid`

**AI Output Shape:**

```json
{
  "recommendedPath": [
    {
      "moduleId": "salary-management-basics",
      "title": "Salary Management Basics",
      "reason": "Essential starting point for salaried users",
      "priority": 1,
      "estimatedMins": 15
    },
    {
      "moduleId": "epf-explained",
      "title": "EPF & PF Explained",
      "reason": "You haven't explored retirement savings yet — this is critical for your income level",
      "priority": 2,
      "estimatedMins": 20
    },
    {
      "moduleId": "tax-saving-101",
      "title": "Tax Saving Under 80C",
      "reason": "High impact for salaried employees — can save ₹15,000+ in taxes",
      "priority": 3,
      "estimatedMins": 25
    }
  ],
  "learnerLevel": "beginner",
  "motivationNote": "You're on a 5-day streak! Keep going — just 2 modules to earn the 'Finance Starter' badge.",
  "nextBadgeHint": "Complete 3 modules to unlock the Finance Starter badge 🏅"
}
```

**Written to Firestore:**
- This endpoint is read-heavy; no Firestore writes. Results are displayed in-app only.
- Optionally cache in `/users/{userId}` as `recommendedModuleIds: string[]` for quick dashboard widget load.

**RAG Notes:**

Excellent RAG candidate. Embed learning module content and metadata into a shared vector store. When the user asks the AI Chat "What should I learn about SIP?", RAG retrieves the most relevant lesson chunks and injects them into the response. This effectively turns the learning library into a knowledge base accessible via natural language.  
Fields to embed: lesson `content` + `title` + `tags` + `category` + `targetOccupation` + `difficulty`.

---

## 10. Smart Alert Trigger Engine

**Endpoint:** `POST /api/ai/smart-alerts` *(Cloud Function — not user-triggered)*

| Layer | Details |
|-------|---------|
| Insight Type | `smart_alert` |
| Cache TTL | No cache — event-driven |
| Trigger | Cloud Function on transaction write, or daily scheduled job |

**Firestore Collections Read:**

| Collection | Fields Passed to AI | Purpose |
|---|---|---|
| `users/{userId}` | `occupationType`, `incomeRange`, `notificationsEnabled` | Alert eligibility |
| `users/{userId}/monthly_summaries/{current}` | `totalExpense`, `budgetAmount`, `categoryBreakdown`, `budgetVariance` | Budget threshold check |
| `users/{userId}/budgets/{current}` | `categoryLimits`, `alertThreshold` | Per-category alert rules |
| `users/{userId}/goals` (active) | `targetAmount`, `currentAmount`, `targetDate`, `monthlyContribution` | Goal health check |
| `users/{userId}/transactions` (last 7 days) | `amount`, `category`, `date`, `isRecurring` | Spend velocity check |

**Fields NOT sent to AI (PII-safe):**
- `email`, `displayName`, `phoneNumber`, `uid`

**AI Output Shape:**

```json
{
  "alerts": [
    {
      "type": "overspend_warning",
      "title": "You've used 85% of your Food budget",
      "body": "₹7,225 of ₹8,500 spent on food — 18 days left in the month. Slow down to avoid overspending.",
      "emoji": "🍔",
      "urgency": "high",
      "deepLink": "/budget/category/food",
      "refType": "budget",
      "refId": "budgetId_abc"
    },
    {
      "type": "goal_milestone",
      "title": "You hit 50% of your Emergency Fund goal! 🎉",
      "body": "Great job! You've saved ₹25,000 of your ₹50,000 target.",
      "emoji": "🏆",
      "urgency": "low",
      "deepLink": "/goals/goalId_xyz",
      "refType": "goal",
      "refId": "goalId_xyz"
    }
  ]
}
```

**Written to Firestore:**
- `/users/{userId}/notifications/{notifId}` → one document per alert generated
- Push notification triggered via FCM if `notificationsEnabled: true`

**RAG Notes:**

Low RAG priority. Rule-based thresholds handle most alert logic. AI layer adds natural language quality to alert messages. Future enhancement: RAG over the user's past response to alerts (did they act after previous overspend warnings?) to personalize alert urgency and tone.

---

## 11. RAG Architecture Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                     FinWise RAG Pipeline                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. INDEXING (Offline / Scheduled)                               │
│  ─────────────────────────────────                               │
│  Firestore Documents                                             │
│       │                                                          │
│       ▼                                                          │
│  Embedding Model (text-embedding-004 / Gemini Embed)             │
│       │                                                          │
│       ▼                                                          │
│  Vector Store (Vertex AI Matching Engine / Pinecone / Weaviate)  │
│       ├── user_monthly_summaries  (per-user index)               │
│       ├── learning_content        (shared index)                 │
│       ├── government_schemes      (shared index)                 │
│       ├── video_insights          (per-user index)               │
│       └── completed_goals         (anonymized shared index)      │
│                                                                  │
│  2. RETRIEVAL (At Inference Time)                                │
│  ─────────────────────────────────                               │
│  User Query / Endpoint Trigger                                   │
│       │                                                          │
│       ▼                                                          │
│  Build Query Embedding                                           │
│       │                                                          │
│       ▼                                                          │
│  ANN Search → Top-K Documents Retrieved                          │
│       │                                                          │
│       ▼                                                          │
│  Inject into Gemini System Prompt as [CONTEXT]                   │
│       │                                                          │
│       ▼                                                          │
│  Gemini Generates Grounded Response                              │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### RAG Priority Matrix

| Feature | RAG Priority | Vector Store Type | Top-K | Embed Fields |
|---|---|---|---|---|
| Expense Insights | ⭐⭐⭐ High | Per-user | 5 | monthly summary fields |
| Budget Generator | ⭐⭐⭐ High | Shared (anonymized) | 5 | budget + occupation + income |
| AI Chat (investment mode) | ⭐⭐ Medium | Shared (learning content) | 3 | lesson content + tags |
| Goal Advisor | ⭐⭐⭐ High | Shared (anonymized) | 5 | goal outcome + income |
| YouTube Insights | ⭐⭐⭐ High | Per-user | 3 | tips + category |
| Scheme Recommender | ⭐⭐ Medium | Shared (schemes) | 5 | scheme description + eligibility |
| Expense Prediction | ⭐⭐⭐ High | Per-user | 6 | monthly summary time-series |
| Learning Path | ⭐⭐⭐ High | Shared (learning content) | 5 | lesson content + difficulty |
| OCR Categorizer | ⭐ Low | Per-user | 3 | merchant + category corrections |
| Smart Alerts | ⭐ Low | N/A | — | Rule-based, no RAG needed |

---

## 12. PII Safety Reference

> **Rule:** None of the following fields are ever sent to any AI model, regardless of endpoint.

| Field | Location | Reason |
|---|---|---|
| `email` | `users/{userId}` | Direct PII |
| `displayName` | `users/{userId}` | Direct PII |
| `phoneNumber` | `users/{userId}` | Direct PII |
| `photoURL` | `users/{userId}` | Direct PII |
| `uid` | All collections | Internal identifier |
| Transaction `title` | `transactions` | May contain names, places |
| Transaction `merchantName` | `transactions` | May contain personal vendor info |
| Transaction `note` | `transactions` | Free text — uncontrolled PII risk |
| Goal `title` | `goals` | May contain personal life events |
| Booking `userNotes` | `consultant_bookings` | May contain personal health/financial info |
| `sessionNotes` | `consultant_bookings` | Sensitive advisor content |
| `ocrRawText` | `transactions` | Only ML Kit-extracted structured fields sent, not raw text |

**Safe fields used as AI context (non-PII):**
- `occupationType`, `incomeRange`, `monthlyIncome` (range, not exact)
- `topGoals` (category tags, not personal titles)
- `preferredLanguage`, `eligibilityTags`
- Aggregated financial totals and category breakdowns

---

## 13. Cache & Cost Optimization Summary

| Endpoint | Cache Location | Cache TTL | Invalidation Trigger |
|---|---|---|---|
| Expense Insights | `monthly_summaries.aiInsightSummary` | 24 hours | `aiInsightVersion` increment |
| Budget Generator | `budgets.aiPromptContext` | Per budget doc | User requests regeneration |
| AI Chat | No cache | Real-time | N/A |
| Goal Advisor | `goals.aiSuggestion` | 3 days | `currentAmount` delta > 10% |
| YouTube Insights | `video_insights/{insightId}` | Permanent | Never (per `videoId`) |
| Scheme Recommender | `notifications` + in-app display | 7 days | Profile `occupationType` or `incomeRange` change |
| Expense Prediction | `monthly_summaries` (next month) | 7 days | New month start |
| OCR Categorizer | No cache | Per scan | N/A |
| Learning Path | `users.recommendedModuleIds` (optional) | 14 days | Module completion or profile change |
| Smart Alerts | No cache | Event-driven | Transaction write / daily job |

### Cost Reduction Strategies

- **Deduplicate video analysis** — `videoId` check prevents re-processing the same YouTube video across any session.
- **Incremental budget updates** — AI budget is only regenerated when the user explicitly requests it, not on every transaction.
- **Monthly summary as AI input** — Dashboard insights read from the pre-aggregated `monthly_summaries` document, not by scanning all transactions at inference time.
- **Flash vs. Pro model routing** — Use `gemini-1.5-flash` for OCR categorization, chat replies, and alert copy; reserve `gemini-1.5-pro` for budget generation and expense prediction.
- **Version-gated regeneration** — `aiInsightVersion` on `monthly_summaries` ensures Gemini is only called when underlying data has meaningfully changed, not on every page load.

---

*Document Version: 1.0 | FinWise AI Team*  
*Gemini API + Firebase Firestore | PII-Safe by Design*
