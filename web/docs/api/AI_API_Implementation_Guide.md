# FinWise AI APIs — Implementation Guide

**Version:** 1.0  
**Date:** April 2026  
**Framework:** Next.js 16 with App Router  
**AI Engine:** Groq (LangChain) + Gemini-compatible prompting  
**Status:** Scaffolded & ready for Firestore integration

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Architecture Overview](#architecture-overview)
3. [Shared Infrastructure](#shared-infrastructure)
4. [API Endpoints Reference](#api-endpoints-reference)
   - [1. Expense Insights](#1-expense-insights)
   - [2. Generate Budget](#2-generate-budget)
   - [3. AI Chat](#3-ai-chat)
   - [4. Goal Advice](#4-goal-advice)
   - [5. Video Insights](#5-video-insights)
   - [6. Scheme Recommend](#6-scheme-recommend)
   - [7. Predict Expenses](#7-predict-expenses)
   - [8. OCR Categorize](#8-ocr-categorize)
   - [9. Learning Path](#9-learning-path)
   - [10. Smart Alerts](#10-smart-alerts)
5. [Error Handling](#error-handling)
6. [Security & PII Safety](#security--pii-safety)
7. [Caching Strategy](#caching-strategy)
8. [Integration Checklist](#integration-checklist)

---

## Quick Start

### Prerequisites

```bash
# Dependencies already installed
pnpm add @langchain/groq langchain zod
```

### Environment Variables

Add to `.env.local`:

```env
GROQ_API_KEY=your_groq_api_key_here
GROQ_MODEL=llama-3.3-70b-versatile
```

### Test an Endpoint

```bash
curl -X POST http://localhost:3000/api/ai/chat \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "test-session-123",
    "mode": "general",
    "message": "How can I save more money?",
    "userContext": {
      "occupationType": "salaried",
      "incomeRange": "25k-50k",
      "monthlyIncome": 42000
    }
  }'
```

---

## Architecture Overview

```
User Request
    ↓
Route Handler (app/api/ai/[feature]/route.ts)
    ↓
    ├─ Read & Parse JSON Body
    ├─ Validate with Zod Schema
    ├─ Build AI Prompts
    ├─ Invoke Groq via LangChain
    ├─ Parse Structured JSON Response
    └─ Return NextResponse
    ↓
Response (success + insight_type + cache_ttl)
```

### Key Files

| File | Purpose |
|------|---------|
| `lib/groq-client.ts` | LangChain ChatGroq wrapper, JSON parsing |
| `lib/ai-validators.ts` | Zod schemas & validation per endpoint |
| `lib/ai-route-helpers.ts` | Common request/response utilities |
| `app/api/ai/[feature]/route.ts` | Individual endpoint handlers (10 total) |

---

## Shared Infrastructure

### 1. Groq JSON Invoker

**File:** `lib/groq-client.ts`

```typescript
import { invokeStructuredJSON } from "@/lib/groq-client";

const result = await invokeStructuredJSON<T>(systemPrompt, userPrompt);
```

**Features:**
- Reads `GROQ_API_KEY` and `GROQ_MODEL` from env
- Uses LangChain ChatGroq with temperature=0.2
- Normalizes API response content
- Safely extracts JSON from markdown code fences
- Throws on invalid JSON

**Error Handling:**
```typescript
try {
  const result = await invokeStructuredJSON(systemPrompt, userPrompt);
} catch (err) {
  console.error("AI processing failed:", err.message);
  return NextResponse.json(
    { error: "AI processing failed", message: err.message },
    { status: 500 }
  );
}
```

### 2. Request Helpers

**File:** `lib/ai-route-helpers.ts`

```typescript
import {
  readJsonBody,
  invalidJsonResponse,
  validationErrorResponse,
} from "@/lib/ai-route-helpers";

// Parse request body
const result = await readJsonBody(request);
if (!result.ok) return invalidJsonResponse(); // 400

// Validation failure
if (!validation.valid) return validationErrorResponse(validation.errors); // 422
```

### 3. Validation Framework

**File:** `lib/ai-validators.ts`

All endpoints use Zod schemas. Example usage:

```typescript
import { validateExpenseInsightsInput } from "@/lib/ai-validators";

const validation = validateExpenseInsightsInput(body);
if (!validation.valid) {
  return validationErrorResponse(validation.errors);
}
const data = validation.data; // Fully typed
```

---

## API Endpoints Reference

### Response Template (All Endpoints)

```typescript
{
  "success": true,
  "insight_type": "expense_insights" | "budget_generation" | ... ,
  "result": { /* AI-generated JSON */ },
  "cache_ttl_hours": 24,  // or cache_ttl_days, cache_ttl, cache_scope
}
```

**Error Response:**
```typescript
{
  "error": "Validation failed" | "AI processing failed",
  "details": ["field.path: error message"],  // validation errors only
  "message": "Human-readable error"           // AI errors only
}
```

---

### 1. Expense Insights

**Route:** `POST /api/ai/expense-insights`

**Purpose:** Analyze monthly spending, identify anomalies, provide savings recommendations.

**Request Body:**

```typescript
{
  "user": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "monthlyIncome": 42000,
    "currentMonthBudget": 38000,
    "currentMonthSpent": 31500,
    "topGoals": ["emergency_fund", "vacation"]
  },
  "monthlySummary": {
    "month": "2026-04",
    "totalIncome": 42000,
    "totalExpense": 31500,
    "totalSavings": 10500,
    "savingsRate": 0.25,
    "categoryBreakdown": {
      "food": 8500,
      "transport": 3000,
      "shopping": 5200,
      "bills": 7800,
      "entertainment": 2500,
      "other": 4500
    },
    "budgetAmount": 38000,
    "budgetVariance": -6500,
    "txnCount": 47
  },
  "recentTransactions": [
    {
      "type": "expense",
      "amount": 500,
      "category": "food",
      "subCategory": "restaurant",
      "tags": ["dining_out"],
      "paymentMethod": "upi",
      "date": "2026-04-01",
      "isRecurring": false,
      "source": "manual"
    }
    // ... more transactions
  ]
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "expense_insights",
  "result": {
    "summary": "You spent ₹3,200 more on food this month compared to last month.",
    "topCategories": [
      {
        "category": "food",
        "amount": 8500,
        "percentOfTotal": 27,
        "trend": "up"
      },
      {
        "category": "bills",
        "amount": 7800,
        "percentOfTotal": 25,
        "trend": "stable"
      }
    ],
    "savingsHealth": "good",
    "savingsRateComment": "Your savings rate of 25% exceeds the recommended 20%. Keep it up!",
    "anomalies": [
      "3 large transactions above ₹2,000 in entertainment this week"
    ],
    "recommendations": [
      "Cut dining out by 2 meals/week to save ₹1,500",
      "Your grocery spend is well within budget — keep it up!"
    ],
    "nextMonthForecast": {
      "estimatedExpense": 29500,
      "confidence": 0.78
    }
  },
  "cache_ttl_hours": 24
}
```

**Cache:**
- TTL: 24 hours
- Invalidate: When `aiInsightVersion` incremented in Firestore
- Store in: `users/{userId}/monthly_summaries/{YYYY-MM}.aiInsightSummary`

**Firestore Write (Backend):**
```javascript
await updateDoc(
  doc(db, `users/${userId}/monthly_summaries`, monthKey),
  {
    aiInsightSummary: result.summary,
    aiInsightGeneratedAt: serverTimestamp(),
    aiInsightVersion: 1,
  }
);
```

---

### 2. Generate Budget

**Route:** `POST /api/ai/generate-budget`

**Purpose:** Create realistic category-based budget from historical spending and active goals.

**Request Body:**

```typescript
{
  "user": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "monthlyIncome": 42000,
    "topGoals": ["emergency_fund", "vacation"],
    "currentMonthSpent": 31500
  },
  "monthlySummaries": [
    {
      "month": "2026-02",
      "totalIncome": 40000,
      "totalExpense": 30500,
      "categoryBreakdown": { "food": 8000, "transport": 2800, ... },
      "savingsRate": 0.238
    },
    {
      "month": "2026-03",
      "totalIncome": 41000,
      "totalExpense": 31200,
      "categoryBreakdown": { "food": 8300, "transport": 2900, ... },
      "savingsRate": 0.239
    }
  ],
  "activeGoals": [
    {
      "category": "emergency_fund",
      "targetAmount": 200000,
      "currentAmount": 50000,
      "targetDate": "2027-12-31",
      "monthlyContribution": 3000,
      "priority": "high"
    },
    {
      "category": "vacation",
      "targetAmount": 100000,
      "currentAmount": 25000,
      "monthlyContribution": 2000,
      "priority": "medium"
    }
  ],
  "lastBudget": {
    "totalBudget": 38000,
    "categoryLimits": {
      "food": 8500,
      "transport": 3500,
      ...
    }
  }
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "budget_generation",
  "result": {
    "totalBudget": 40000,
    "categoryLimits": {
      "food": 8000,
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
      {
        "goalCategory": "emergency_fund",
        "monthlyContribution": 3000
      },
      {
        "goalCategory": "vacation",
        "monthlyContribution": 2000
      }
    ],
    "savingsTarget": 5000,
    "alertThreshold": 0.8,
    "tips": [
      "Your food spend has been consistently high — setting a ₹8,000 cap helps.",
      "Bills are fixed — no changes needed there."
    ]
  },
  "cache_scope": "per_budget_document"
}
```

**Cache:**
- TTL: Per budget document
- Regenerate: Only on user request
- Store in: `users/{userId}/budgets/{budgetId}`

**Firestore Write:**
```javascript
await setDoc(doc(db, `users/${userId}/budgets`, budgetId), {
  ...result,
  generatedBy: "ai",
  aiPromptContext: JSON.stringify(promptData),
  createdAt: serverTimestamp(),
});
```

---

### 3. AI Chat

**Route:** `POST /api/ai/chat`

**Purpose:** Real-time conversational finance assistant answering user questions with context.

**Request Body:**

```typescript
{
  "sessionId": "chat-session-abc123",
  "mode": "general",  // "general" | "budget" | "investment" | "planning"
  "message": "How can I save more money this month?",
  "userContext": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "monthlyIncome": 42000,
    "currentMonthBudget": 38000,
    "currentMonthSpent": 31500,
    "topGoals": ["emergency_fund"]
  },
  "financialSnapshot": {
    "totalExpense": 31500,
    "totalIncome": 42000,
    "totalSavings": 10500,
    "savingsRate": 0.25,
    "categoryBreakdown": { "food": 8500, "transport": 3000, ... }
  },
  "activeGoals": [
    {
      "category": "emergency_fund",
      "targetAmount": 200000,
      "currentAmount": 50000,
      "targetDate": "2027-12-31"
    }
  ],
  "currentBudget": {
    "totalBudget": 38000,
    "categoryLimits": { "food": 8000, ... }
  },
  "recentMessages": [
    {
      "role": "user",
      "content": "What should I do with my savings?",
      "createdAt": "2026-04-02T10:00:00Z"
    },
    {
      "role": "assistant",
      "content": "Great question! With ₹10,500 monthly savings...",
      "createdAt": "2026-04-02T10:00:30Z"
    }
  ]
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "chat_message",
  "session_id": "chat-session-abc123",
  "result": {
    "reply": "Based on your ₹42,000 income and ₹31,500 spent so far, you have ₹10,500 left. If you skip dining out twice this week, you can hit your ₹10,000 savings target easily!",
    "suggestedActions": [
      "View your food expenses",
      "Update your emergency fund goal"
    ],
    "followUpSuggestions": [
      "How can I reduce transport costs?",
      "Show me my savings trend"
    ]
  },
  "cache_ttl": "none"
}
```

**Cache:**
- TTL: None — always real-time
- Store in: `users/{userId}/ai_chats/{sessionId}.messages`

**Firestore Write:**
```javascript
await updateDoc(doc(db, `users/${userId}/ai_chats`, sessionId), {
  messages: arrayUnion({
    role: "user",
    content: message,
    createdAt: serverTimestamp(),
  }, {
    role: "assistant",
    content: result.reply,
    createdAt: serverTimestamp(),
  }),
  lastMessageAt: serverTimestamp(),
});
```

---

### 4. Goal Advice

**Route:** `POST /api/ai/goal-advice`

**Purpose:** Assess goal progress and suggest strategies to stay on track.

**Request Body:**

```typescript
{
  "user": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "monthlyIncome": 42000
  },
  "goal": {
    "category": "emergency_fund",
    "targetAmount": 200000,
    "currentAmount": 50000,
    "progressPercent": 25,
    "startDate": "2025-01-01",
    "targetDate": "2027-12-31",
    "monthlyContribution": 3000,
    "status": "active",
    "priority": "high"
  },
  "recentSummaries": [
    {
      "month": "2026-02",
      "totalSavings": 9500,
      "savingsRate": 0.238
    },
    {
      "month": "2026-03",
      "totalSavings": 10200,
      "savingsRate": 0.249
    }
  ],
  "currentBudget": {
    "totalBudget": 38000,
    "categoryLimits": { "investment": 6000, ... }
  }
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "goal_advice",
  "result": {
    "projectedCompletionDate": "2028-06-15",
    "isOnTrack": false,
    "shortfallAmount": 12000,
    "requiredMonthlySaving": 4500,
    "currentMonthlySaving": 3000,
    "advice": "At your current saving rate of ₹3,000/month, you'll miss your target by about 4 months. Increasing by ₹1,500/month puts you back on track.",
    "strategies": [
      "Reduce entertainment budget by ₹1,000 and redirect to this goal",
      "Set up auto-deduction on salary day to avoid spending the amount"
    ],
    "milestoneMessage": "You're 25% there — great progress! The next milestone is ₹50,000.",
    "riskLevel": "medium"
  },
  "cache_ttl_days": 3
}
```

**Cache:**
- TTL: 3 days
- Invalidate: When `currentAmount` changes by >10%
- Store in: `users/{userId}/goals/{goalId}`

---

### 5. Video Insights

**Route:** `POST /api/ai/video-insights`

**Purpose:** Analyze YouTube finance videos and extract personalized insights.

**Request Body:**

```typescript
{
  "videoId": "dQw4w9WgXcQ",  // YouTube video ID
  "videoTitle": "How to invest ₹5000/month in 2024",
  "transcript": "Today we're discussing investment strategies for Indians earning 25k-50k per month. The video covers SIPs, mutual funds, index funds, and tax-saving investments. (full transcript)",
  "userContext": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "topGoals": ["emergency_fund", "investment"],
    "preferredLanguage": "en"
  }
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "video_insights",
  "video_id": "dQw4w9WgXcQ",
  "result": {
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
    "relatedGoals": ["investment"],
    "relatedCategory": "investment"
  },
  "cache_ttl": "permanent_per_video_id"
}
```

**Cache:**
- TTL: Permanent per `videoId`
- Store in: `users/{userId}/video_insights/{insightId}`
- Check: Before calling endpoint, query Firestore for existing `videoId`

---

### 6. Scheme Recommend

**Route:** `POST /api/ai/scheme-recommend`

**Purpose:** Match user to relevant government schemes based on eligibility.

**Request Body:**

```typescript
{
  "user": {
    "occupationType": "business",
    "incomeRange": "10k-25k",
    "monthlyIncome": 18000,
    "topGoals": ["business_growth"],
    "eligibilityTags": ["self_employed", "small_business"]
  },
  "schemes": [
    {
      "schemeId": "pm-mudra-yojana",
      "name": "PM Mudra Yojana",
      "fullName": "Pradhan Mantri Mudra Yojana",
      "eligibilityTags": ["self_employed", "business_loan"],
      "targetOccupation": "business",
      "incomeRangeMin": 0,
      "incomeRangeMax": 50000,
      "benefitType": "business_loan",
      "maxBenefit": 1000000,
      "tagline": "Loans up to 10 lakhs for small business",
      "applicationMode": "online",
      "description": "Scheme to help small businesses and entrepreneurs..."
    },
    // ... more schemes
  ]
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "scheme_recommendation",
  "result": {
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
    "totalSchemesFetched": 15,
    "totalMatched": 4
  },
  "cache_ttl_days": 7
}
```

**Cache:**
- TTL: 7 days
- Invalidate: When `occupationType` or `incomeRange` changes
- Store in: `users/{userId}/notifications` or dashboard widget

---

### 7. Predict Expenses

**Route:** `POST /api/ai/predict-expenses`

**Purpose:** Forecast next month spending using historical trends and seasonal patterns.

**Request Body:**

```typescript
{
  "user": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "monthlyIncome": 42000
  },
  "monthlySummaries": [
    {
      "month": "2026-01",
      "totalIncome": 40000,
      "totalExpense": 29500,
      "categoryBreakdown": { "food": 8000, "transport": 2800, ... },
      "savingsRate": 0.2625
    },
    {
      "month": "2026-02",
      "totalIncome": 40000,
      "totalExpense": 30500,
      "categoryBreakdown": { "food": 8200, "transport": 2900, ... },
      "savingsRate": 0.2375
    },
    {
      "month": "2026-03",
      "totalIncome": 41000,
      "totalExpense": 31200,
      "categoryBreakdown": { "food": 8300, "transport": 2950, ... },
      "savingsRate": 0.2390
    }
  ],
  "recurringTransactions": [
    { "amount": 500, "category": "bills", "paymentMethod": "upi" },
    // Fixed costs
  ],
  "nextMonthBudget": {
    "totalBudget": 38000,
    "categoryLimits": { "food": 8000, ... }
  }
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "expense_prediction",
  "result": {
    "predictedTotalExpense": 31500,
    "confidence": 0.82,
    "categoryForecasts": {
      "food": {
        "predicted": 8200,
        "trend": "stable",
        "changePercent": 3
      },
      "transport": {
        "predicted": 3100,
        "trend": "up",
        "changePercent": 12
      },
      "shopping": {
        "predicted": 4500,
        "trend": "down",
        "changePercent": -8
      }
    },
    "warnings": [
      "Your transport spend has been rising 10–15% monthly — watch out.",
      "December historically shows a spike in shopping for you."
    ],
    "savingsProjection": 10500,
    "recommendedBudgetAdjustments": [
      "Increase transport budget by ₹500 based on trend",
      "Shopping budget can safely be reduced by ₹1,000"
    ]
  },
  "cache_ttl_days": 7
}
```

**Cache:**
- TTL: 7 days
- Refresh: At start of new month
- Store in: `users/{userId}/monthly_summaries/{next month}.aiInsightSummary`

---

### 8. OCR Categorize

**Route:** `POST /api/ai/ocr-categorize`

**Purpose:** Extract and categorize transaction from receipt/bill OCR text.

**Request Body:**

```typescript
{
  "ocrRawText": "ZOMATO INDIA\nOrder #ZOM998821\nItem: Butter Chicken x2 - ₹480\nDelivery - ₹40\nTotal: ₹520\nDate: 12 Jul 2025",
  "userContext": {
    "preferredLanguage": "en",
    "occupationType": "salaried"
  }
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "ocr_categorization",
  "result": {
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
  },
  "cache_ttl": "none"
}
```

**Cache:**
- TTL: None — per-scan, real-time
- Store in: `users/{userId}/transactions/{txnId}` with `source: "ocr_scan"`

**Firestore Write:**
```javascript
await addDoc(collection(db, `users/${userId}/transactions`), {
  ...result,
  aiCategorized: true,
  source: "ocr_scan",
  ocrRawText: body.ocrRawText,
  createdAt: serverTimestamp(),
});
```

---

### 9. Learning Path

**Route:** `POST /api/ai/learning-path`

**Purpose:** Recommend personalized financial learning modules based on user profile and progress.

**Request Body:**

```typescript
{
  "user": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "topGoals": ["emergency_fund", "investment"],
    "preferredLanguage": "en",
    "streakDays": 5
  },
  "learningProgress": [
    {
      "moduleId": "salary-management-basics",
      "status": "completed",
      "progressPercent": 100,
      "bestQuizScore": 88,
      "quizPassed": true
    },
    {
      "moduleId": "budgeting-101",
      "status": "in_progress",
      "progressPercent": 65
    }
  ],
  "badges": [
    { "badgeId": "first_lesson", "category": "engagement" },
    { "badgeId": "quiz_master", "category": "achievement" }
  ],
  "learningModules": [
    {
      "id": "salary-management-basics",
      "title": "Salary Management Basics",
      "targetOccupation": "salaried",
      "targetIncomeRange": "25k-50k",
      "difficulty": "beginner",
      "tags": ["salary", "basics"],
      "category": "fundamentals",
      "estimatedMins": 15,
      "hasQuiz": true
    },
    // ... more modules
  ]
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "learning_path",
  "result": {
    "recommendedPath": [
      {
        "moduleId": "epf-explained",
        "title": "EPF & PF Explained",
        "reason": "You haven't explored retirement savings yet — this is critical for your income level",
        "priority": 1,
        "estimatedMins": 20
      },
      {
        "moduleId": "tax-saving-101",
        "title": "Tax Saving Under 80C",
        "reason": "High impact for salaried employees — can save ₹15,000+ in taxes",
        "priority": 2,
        "estimatedMins": 25
      }
    ],
    "learnerLevel": "beginner",
    "motivationNote": "You're on a 5-day streak! Keep going — just 2 modules to earn the 'Finance Starter' badge.",
    "nextBadgeHint": "Complete 3 modules to unlock the Finance Starter badge 🏅"
  },
  "cache_ttl_days": 14
}
```

**Cache:**
- TTL: 14 days
- Invalidate: On module completion or profile change
- Store in: `users/{userId}` as `recommendedModuleIds: string[]` (optional, for dashboard widget)

---

### 10. Smart Alerts

**Route:** `POST /api/ai/smart-alerts`

**Purpose:** Generate contextual alerts when user approach budget limits, hit savings goals, or need action.

**Note:** This endpoint is typically triggered by Cloud Functions on transaction write or scheduled daily job, not user-initiated.

**Request Body:**

```typescript
{
  "user": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "notificationsEnabled": true
  },
  "currentSummary": {
    "totalExpense": 31500,
    "budgetAmount": 38000,
    "categoryBreakdown": {
      "food": 7225,
      "transport": 2950,
      ...
    },
    "budgetVariance": -6500
  },
  "currentBudget": {
    "categoryLimits": { "food": 8000, "transport": 3500, ... },
    "alertThreshold": 0.8
  },
  "activeGoals": [
    {
      "targetAmount": 200000,
      "currentAmount": 50000,
      "targetDate": "2027-12-31",
      "monthlyContribution": 3000
    }
  ],
  "recentTransactions": [
    {
      "amount": 500,
      "category": "food",
      "date": "2026-04-02",
      "isRecurring": false
    },
    // Last 7-14 days
  ]
}
```

**Response:**

```typescript
{
  "success": true,
  "insight_type": "smart_alert",
  "result": {
    "alerts": [
      {
        "type": "overspend_warning",
        "title": "You've used 85% of your Food budget",
        "body": "₹7,225 of ₹8,000 spent on food — 18 days left in the month. Slow down to avoid overspending.",
        "emoji": "🍔",
        "urgency": "high",
        "deepLink": "/dashboard/budget/category/food",
        "refType": "budget",
        "refId": "budgetId_abc"
      },
      {
        "type": "goal_milestone",
        "title": "You hit 25% of your Emergency Fund goal! 🎉",
        "body": "Great job! You've saved ₹50,000 of your ₹200,000 target.",
        "emoji": "🏆",
        "urgency": "low",
        "deepLink": "/dashboard/goals/goalId_xyz",
        "refType": "goal",
        "refId": "goalId_xyz"
      }
    ]
  },
  "cache_ttl": "event_driven"
}
```

**Cache:**
- TTL: None — event-driven
- Store in: `users/{userId}/notifications/{notifId}`
- Push via FCM if `notificationsEnabled: true`

---

## Error Handling

### HTTP Status Codes

| Code | Scenario | Example |
|------|----------|---------|
| 400 | Invalid JSON body | `{"error": "Invalid JSON body"}` |
| 422 | Validation failed | `{"error": "Validation failed", "details": ["field: error message"]}` |
| 500 | AI processing error | `{"error": "AI processing failed", "message": "..."}`  |

### Common Validation Errors

```json
{
  "error": "Validation failed",
  "details": [
    "user.monthlyIncome: Expected number, received string",
    "goal.targetAmount: Number must be greater than or equal to 0",
    "monthlySummaries: Array must contain at least 1 item(s)",
    "videoTitle: String must contain at least 1 character(s)"
  ]
}
```

### AI Error Fallback

```typescript
try {
  const result = await invokeStructuredJSON(systemPrompt, userPrompt);
  // Parse failed
} catch (err) {
  console.error("Groq invocation failed:", err);
  return NextResponse.json(
    {
      error: "AI processing failed",
      message: "Model did not return valid JSON. Please retry.",
    },
    { status: 500 }
  );
}
```

---

## Security & PII Safety

> **Golden Rule:** Never send PII to AI models. The following fields are **BLOCKED**:

### Blocked Fields (Never to AI)

| Field | Location | Reason |
|-------|----------|--------|
| `email` | `users/{userId}` | Direct PII |
| `displayName` | `users/{userId}` | Direct PII |
| `phoneNumber` | `users/{userId}` | Direct PII |
| `photoURL` | `users/{userId}` | Direct PII |
| `uid` | All collections | Internal identifier |
| Transaction `title` | `transactions` | May contain names, locations |
| Transaction `merchantName` | (sent in some cases) | Can contain personal vendor info |
| Transaction `note` | `transactions` | Free-form PII risk |
| Goal `title` | `goals` | May contain personal life events ("Ravi's Wedding Fund") |

### Safe Fields (Passed to AI)

✅ `occupationType`, `incomeRange`, `monthlyIncome` (range, not exact)  
✅ `topGoals` (category tags, not personal titles)  
✅ `preferredLanguage`, `eligibilityTags`  
✅ Aggregated financial totals and category breakdowns  
✅ `categoryBreakdown` (e.g., `{ "food": 8500, "transport": 3000 }`)  
✅ Historical summaries (month, totalExpense, savingsRate)

### Validation Example

```typescript
// ❌ WRONG
const userPrompt = `User ${user.email} with goal "${goal.title}" needs help.`;

// ✅ CORRECT
const userPrompt = `User with occupationType "${user.occupationType}" and goal category "${goal.category}" needs help.`;
```

---

## Caching Strategy

### Summary Table

| Endpoint | TTL | Trigger | Store Location |
|----------|-----|---------|-----------------|
| Expense Insights | 24h | `aiInsightVersion` increment | `monthly_summaries/{month}.aiInsightSummary` |
| Generate Budget | Per doc | User regenerates | `budgets/{budgetId}` |
| AI Chat | None | Real-time | `ai_chats/{sessionId}.messages` |
| Goal Advice | 3d | `currentAmount` delta >10% | `goals/{goalId}.aiSuggestion` |
| Video Insights | Permanent | Per `videoId` | `video_insights/{insightId}` |
| Scheme Recommend | 7d | Profile change | Dashboard widget |
| Predict Expenses | 7d | New month start | `monthly_summaries/{next-month}` |
| OCR Categorize | None | Per scan | `transactions/{txnId}` |
| Learning Path | 14d | Module complete | `users/{userId}` (optional) |
| Smart Alerts | Event-driven | Transaction write / daily | `notifications/{notifId}` |

### Implementation Pattern

```typescript
// Check cache before calling AI
const cached = await getDoc(doc(db, `users/${userId}/goals`, goalId));
if (cached.exists() && cached.data().aiSuggestion) {
  const generatedAt = cached.data().aiSuggestionAt.toDate();
  const now = new Date();
  const ageDays = (now - generatedAt) / (1000 * 60 * 60 * 24);
  if (ageDays < 3) {
    // Return cached result
    return cached.data().aiSuggestion;
  }
}

// Cache expired or missing; call API
const result = await fetch("/api/ai/goal-advice", { ... });
await updateDoc(..., {
  aiSuggestion: result,
  aiSuggestionAt: serverTimestamp(),
});
```

---

## Integration Checklist

Use this checklist when integrating each endpoint into your app:

### Per Endpoint

- [ ] Read from correct Firestore collections (from API guide)
- [ ] Scrub PII before sending to API
- [ ] Parse response.result and validate structure
- [ ] Handle error responses (400, 422, 500)
- [ ] Implement caching per TTL specified
- [ ] Write results back to Firestore
- [ ] Test with example payloads
- [ ] Monitor logs for rate limits / API errors

### Global Security

- [ ] Add auth guard to all `/api/ai/*` routes (check `userId` from session)
- [ ] Add rate limiting (e.g., 10 requests/minute per user)
- [ ] Scrub all PII from request bodies
- [ ] Log API calls (without sensitive data) for debugging
- [ ] Set up error tracking (Sentry / similar)

### Testing

- [ ] Test each endpoint with valid payloads
- [ ] Test with empty/minimal data
- [ ] Test with invalid/extra fields (422 response)
- [ ] Test with malformed JSON (400 response)
- [ ] Test AI timeout scenarios
- [ ] Test concurrent requests
- [ ] Test cache invalidation

### Monitoring

- [ ] Track API latency per endpoint
- [ ] Monitor Groq API token usage
- [ ] Alert on 500 errors
- [ ] Log cache hit/miss rates
- [ ] Monitor Firestore write quota

---

## Testing Examples

### cURL Test: Chat API

```bash
curl -X POST http://localhost:3000/api/ai/chat \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "test-session-001",
    "mode": "general",
    "message": "How much should I save each month?",
    "userContext": {
      "occupationType": "salaried",
      "incomeRange": "25k-50k",
      "monthlyIncome": 42000
    },
    "financialSnapshot": {
      "totalIncome": 42000,
      "totalExpense": 31500,
      "totalSavings": 10500,
      "savingsRate": 0.25
    }
  }'
```

### Node.js Test: Expense Insights

```typescript
import fetch from "node-fetch";

const response = await fetch("http://localhost:3000/api/ai/expense-insights", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    user: {
      occupationType: "salaried",
      monthlyIncome: 42000,
    },
    monthlySummary: {
      totalIncome: 42000,
      totalExpense: 31500,
      categoryBreakdown: {
        food: 8500,
        transport: 3000,
      },
    },
    recentTransactions: [],
  }),
});

const data = await response.json();
console.log(data.result);
```

---

## Next Steps

1. **Connect Firestore Operations**
   - Each route currently calls `/ai/...` and returns raw AI results
   - Add `async function` to read Firestore, scrub PII, pass to `/api` route
   - Add Firestore writes to cache results

2. **Add Auth Middleware**
   ```typescript
   export async function POST(request: Request) {
     const userId = await authenticateUser(request);
     if (!userId) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
     // ... rest of handler
   }
   ```

3. **Add Rate Limiting**
   ```typescript
   import { Ratelimit } from "@upstash/ratelimit";
   const ratelimit = new Ratelimit({
     redis: Redis.fromEnv(),
     limiter: Ratelimit.slidingWindow(10, "1 m"),
   });
   const result = await ratelimit.limit(userId);
   if (!result.success) return NextResponse.json({ error: "Rate limited" }, { status: 429 });
   ```

4. **Add Input/Output Validation**
   - Add Zod schemas for AI response validation
   - Ensure required fields are present before writing to Firestore

5. **Deploy & Monitor**
   - Test all endpoints in staging
   - Monitor Groq API costs and token usage
   - Set up error logs and alerts

---

## Environment Variables Reference

```env
# Required
GROQ_API_KEY=gsk_xxxxxxxxxxxxx
GROQ_MODEL=llama-3.3-70b-versatile

# Optional
NEXT_PUBLIC_LOG_AI_CALLS=true
AI_LOG_LEVEL=debug
```

---

## FAQ

**Q: Can I use a different LLM provider?**  
A: Yes, modify `lib/groq-client.ts` to use `ChatOpenAI` or `ChatAnthropic` instead of `ChatGroq`. The interface and response handling remain the same.

**Q: What if the user is offline?**  
A: Cache responses aggressively. The chat endpoint has no cache, but all others do. Consider adding a service worker to serve stale cache on network failure.

**Q: How do I reduce API costs?**  
A: Use flash models (`gemini-1.5-flash`) for simple endpoints (OCR, alerts) and pro models for complex ones (budgeting, predictions). Implement aggressive caching (24h+ TTLs).

**Q: What PII can I pass safely?**  
A: Only occupation type, income range (not exact), categories, and aggregated totals. Never pass email, names, phone, or transaction titles.

---

**Document Version:** 1.0  
**Last Updated:** April 2026  
**Maintained By:** FinWise AI Team
