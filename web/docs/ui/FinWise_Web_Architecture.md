# 🏦 FinWise — Next.js Website Architecture
### Complete Web Architecture Document | Next.js 14 App Router

> **Stack:** Next.js 14 (App Router) · Tailwind CSS · Firebase Auth · Firestore · Gemini AI  
> **Hosting:** Vercel · **Auth:** Firebase Auth / Clerk  
> **Version:** 1.0 | FinWise Web Team

---

## 📋 Table of Contents

1. [Project Structure Overview](#1-project-structure-overview)
2. [App Router — Route Map](#2-app-router--route-map)
3. [Full File & Folder Structure](#3-full-file--folder-structure)
4. [Page-by-Page Architecture](#4-page-by-page-architecture)
5. [Component Architecture](#5-component-architecture)
6. [Data Fetching Strategy](#6-data-fetching-strategy)
7. [State Management](#7-state-management)
8. [API Routes (Next.js Route Handlers)](#8-api-routes-nextjs-route-handlers)
9. [Authentication & Middleware](#9-authentication--middleware)
10. [Firebase Integration Layer](#10-firebase-integration-layer)
11. [AI Integration Architecture](#11-ai-integration-architecture)
12. [Environment Variables](#12-environment-variables)
13. [Layouts & Nesting Strategy](#13-layouts--nesting-strategy)
14. [SEO & Metadata Strategy](#14-seo--metadata-strategy)
15. [Prompt Reference Sheet](#15-prompt-reference-sheet)

---

## 1. Project Structure Overview

FinWise Web is built using **Next.js 14 App Router** — all routing is file-system based inside the `/app` directory. The project is divided into 3 major zones:

| Zone | Path Prefix | Who Sees It | Auth Required |
|------|-------------|-------------|---------------|
| **Public / Marketing** | `/` | Everyone | ❌ No |
| **Auth** | `/auth/*` | Unauthenticated users | ❌ No |
| **App (Dashboard)** | `/dashboard/*` | Logged-in users only | ✅ Yes |

The codebase is separated into:
- `app/` — All routes (pages, layouts, loading, error states)
- `components/` — Reusable UI components
- `lib/` — Firebase, AI helpers, utility functions
- `hooks/` — Custom React hooks
- `store/` — Global state (Zustand or Context)
- `types/` — TypeScript interfaces (mirrors Firebase schema)
- `public/` — Static assets

---

## 2. App Router — Route Map

```
/                               → Landing Page (Marketing)
/features                       → Feature Showcase
/pricing                        → Pricing Page
/about                          → About FinWise
/blog                           → Blog Index
/blog/[slug]                    → Blog Post Detail

/auth/login                     → Login Page
/auth/register                  → Registration Page
/auth/onboarding                → Onboarding Flow (Step 1-4)
/auth/forgot-password           → Password Reset

/dashboard                      → Main Dashboard (Redirect to /dashboard/overview)
/dashboard/overview             → Overview — Spend, Savings, Goals Summary
/dashboard/transactions         → Transaction List & History
/dashboard/transactions/add     → Add New Transaction
/dashboard/transactions/[id]    → Transaction Detail / Edit
/dashboard/transactions/import  → Bulk CSV Import Page
/dashboard/budget               → Budget Overview
/dashboard/budget/create        → Create / Edit Budget
/dashboard/goals                → Financial Goals List
/dashboard/goals/[id]           → Goal Detail & Progress
/dashboard/goals/create         → Create New Goal
/dashboard/ai                   → AI Hub (All AI tools)
/dashboard/ai/chat              → AI Chat Assistant
/dashboard/ai/video-insights    → YouTube Video Insight Tool
/dashboard/ai/expense-breakdown → AI Expense Analysis
/dashboard/learn                → Learning Module Home
/dashboard/learn/[moduleId]     → Module Detail (Lesson List)
/dashboard/learn/[moduleId]/[lessonId] → Individual Lesson
/dashboard/learn/quiz/[moduleId]  → Quiz Page
/dashboard/schemes              → Government Scheme Recommender
/dashboard/schemes/[id]         → Scheme Detail Page
/dashboard/experts              → Expert Consultant Listings
/dashboard/experts/[id]         → Consultant Profile
/dashboard/experts/[id]/book    → Booking Flow
/dashboard/notifications        → Notification Center
/dashboard/settings             → Settings Hub
/dashboard/settings/profile     → Profile Settings
/dashboard/settings/preferences → App Preferences (language, theme)
/dashboard/settings/security    → Security Settings
```

---

## 3. Full File & Folder Structure

```
finwise-web/
│
├── app/                                   ← Next.js App Router Root
│   │
│   ├── layout.tsx                         ← Root Layout (html, body, providers)
│   ├── page.tsx                           ← Landing Page "/"
│   ├── not-found.tsx                      ← Global 404 Page
│   ├── error.tsx                          ← Global Error Boundary
│   │
│   ├── (marketing)/                       ← Route Group: Public Pages
│   │   ├── layout.tsx                     ← Marketing Layout (Navbar + Footer)
│   │   ├── features/
│   │   │   └── page.tsx
│   │   ├── pricing/
│   │   │   └── page.tsx
│   │   ├── about/
│   │   │   └── page.tsx
│   │   └── blog/
│   │       ├── page.tsx                   ← Blog Index
│   │       └── [slug]/
│   │           └── page.tsx              ← Blog Post Detail
│   │
│   ├── auth/                              ← Auth Route Group
│   │   ├── layout.tsx                     ← Auth Layout (centered card)
│   │   ├── login/
│   │   │   └── page.tsx
│   │   ├── register/
│   │   │   └── page.tsx
│   │   ├── onboarding/
│   │   │   ├── layout.tsx                 ← Onboarding shell (stepper UI)
│   │   │   └── page.tsx                  ← Multi-step onboarding flow
│   │   └── forgot-password/
│   │       └── page.tsx
│   │
│   ├── dashboard/                         ← Protected: App Shell
│   │   ├── layout.tsx                     ← Dashboard Layout (Sidebar + Topbar)
│   │   ├── loading.tsx                    ← Dashboard Skeleton Loader
│   │   ├── error.tsx                      ← Dashboard Error Page
│   │   ├── page.tsx                       ← Redirect → /dashboard/overview
│   │   │
│   │   ├── overview/
│   │   │   ├── page.tsx                   ← Main dashboard widgets
│   │   │   └── loading.tsx
│   │   │
│   │   ├── transactions/
│   │   │   ├── page.tsx                   ← Transaction list + filters
│   │   │   ├── loading.tsx
│   │   │   ├── add/
│   │   │   │   └── page.tsx              ← Add Transaction Form
│   │   │   ├── import/
│   │   │   │   └── page.tsx              ← CSV / Bank Statement Import
│   │   │   └── [id]/
│   │   │       ├── page.tsx              ← Transaction Detail / Edit
│   │   │       └── loading.tsx
│   │   │
│   │   ├── budget/
│   │   │   ├── page.tsx                   ← Budget Overview + Gauge Charts
│   │   │   ├── create/
│   │   │   │   └── page.tsx              ← Create or Edit Budget
│   │   │   └── loading.tsx
│   │   │
│   │   ├── goals/
│   │   │   ├── page.tsx                   ← Goals Board
│   │   │   ├── create/
│   │   │   │   └── page.tsx
│   │   │   └── [id]/
│   │   │       ├── page.tsx              ← Goal Detail + Contributions
│   │   │       └── loading.tsx
│   │   │
│   │   ├── ai/
│   │   │   ├── page.tsx                   ← AI Hub — Tool Cards
│   │   │   ├── chat/
│   │   │   │   └── page.tsx              ← AI Chat Interface
│   │   │   ├── video-insights/
│   │   │   │   └── page.tsx              ← YouTube Link → Insight Generator
│   │   │   └── expense-breakdown/
│   │   │       └── page.tsx              ← AI Expense Analysis with Charts
│   │   │
│   │   ├── learn/
│   │   │   ├── page.tsx                   ← Learning Home (module cards)
│   │   │   ├── [moduleId]/
│   │   │   │   ├── page.tsx              ← Module Detail + Lesson List
│   │   │   │   └── [lessonId]/
│   │   │   │       └── page.tsx          ← Lesson Content Page
│   │   │   └── quiz/
│   │   │       └── [moduleId]/
│   │   │           └── page.tsx          ← Quiz Page
│   │   │
│   │   ├── schemes/
│   │   │   ├── page.tsx                   ← Scheme Recommender + List
│   │   │   └── [id]/
│   │   │       └── page.tsx              ← Scheme Detail
│   │   │
│   │   ├── experts/
│   │   │   ├── page.tsx                   ← Consultant Listings
│   │   │   └── [id]/
│   │   │       ├── page.tsx              ← Consultant Profile
│   │   │       └── book/
│   │   │           └── page.tsx          ← Booking / Slot Selection
│   │   │
│   │   ├── notifications/
│   │   │   └── page.tsx
│   │   │
│   │   └── settings/
│   │       ├── layout.tsx                 ← Settings Layout (sub-tabs)
│   │       ├── page.tsx                   ← Redirect → settings/profile
│   │       ├── profile/
│   │       │   └── page.tsx
│   │       ├── preferences/
│   │       │   └── page.tsx
│   │       └── security/
│   │           └── page.tsx
│   │
│   └── api/                               ← Next.js Route Handlers (API)
│       ├── auth/
│       │   └── session/
│       │       └── route.ts               ← Firebase session cookie management
│       ├── ai/
│       │   ├── chat/
│       │   │   └── route.ts               ← Gemini AI Chat (streaming)
│       │   ├── expense-analysis/
│       │   │   └── route.ts               ← Gemini expense insight generation
│       │   └── video-insights/
│       │       └── route.ts               ← YouTube transcript + Gemini analysis
│       ├── transactions/
│       │   ├── route.ts                   ← GET list / POST create
│       │   └── [id]/
│       │       └── route.ts               ← GET / PATCH / DELETE single
│       ├── budget/
│       │   └── route.ts
│       ├── goals/
│       │   └── route.ts
│       └── schemes/
│           └── recommend/
│               └── route.ts               ← Eligibility-based scheme recommender
│
├── components/                            ← Reusable UI Components
│   ├── ui/                                ← Base Design System (shadcn/ui based)
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Card.tsx
│   │   ├── Badge.tsx
│   │   ├── Modal.tsx
│   │   ├── Skeleton.tsx
│   │   ├── Toast.tsx
│   │   ├── Tooltip.tsx
│   │   ├── Select.tsx
│   │   ├── Tabs.tsx
│   │   └── Progress.tsx
│   │
│   ├── layout/                            ← Layout Components
│   │   ├── Navbar.tsx                     ← Public marketing nav
│   │   ├── Footer.tsx                     ← Public footer
│   │   ├── Sidebar.tsx                    ← Dashboard sidebar
│   │   ├── Topbar.tsx                     ← Dashboard top header
│   │   └── MobileSidebar.tsx              ← Mobile nav drawer
│   │
│   ├── dashboard/                         ← Dashboard-specific widgets
│   │   ├── SummaryCard.tsx                ← Income / Spend / Savings metric card
│   │   ├── SpendChart.tsx                 ← Monthly bar / donut chart
│   │   ├── GoalProgressCard.tsx           ← Goal widget with progress bar
│   │   ├── BudgetGauge.tsx                ← Budget used vs remaining
│   │   ├── RecentTransactions.tsx         ← Mini transaction list
│   │   ├── DailyTipCard.tsx               ← Today's financial tip widget
│   │   └── AIInsightBanner.tsx            ← Gemini AI insight call-to-action
│   │
│   ├── transactions/
│   │   ├── TransactionList.tsx
│   │   ├── TransactionCard.tsx
│   │   ├── TransactionForm.tsx            ← Add / Edit form
│   │   ├── TransactionFilters.tsx         ← Category, date, type filters
│   │   ├── CategoryBadge.tsx
│   │   └── CSVImporter.tsx                ← Drag-and-drop CSV import
│   │
│   ├── ai/
│   │   ├── ChatInterface.tsx              ← Full chat UI (messages + input)
│   │   ├── ChatMessage.tsx                ← Individual message bubble
│   │   ├── VideoInsightForm.tsx           ← YouTube URL input form
│   │   ├── InsightResult.tsx              ← Summary + Tips + Actions display
│   │   └── AIThinkingIndicator.tsx        ← Loading skeleton for AI response
│   │
│   ├── goals/
│   │   ├── GoalCard.tsx
│   │   ├── GoalForm.tsx
│   │   └── ContributionModal.tsx
│   │
│   ├── learn/
│   │   ├── ModuleCard.tsx
│   │   ├── LessonPlayer.tsx               ← Lesson content renderer (Markdown)
│   │   ├── QuizEngine.tsx                 ← Quiz UI with answer logic
│   │   ├── BadgeDisplay.tsx
│   │   └── ProgressBar.tsx                ← Module completion progress
│   │
│   ├── schemes/
│   │   ├── SchemeCard.tsx
│   │   └── EligibilityChecker.tsx
│   │
│   ├── experts/
│   │   ├── ConsultantCard.tsx
│   │   └── BookingCalendar.tsx
│   │
│   └── auth/
│       ├── LoginForm.tsx
│       ├── RegisterForm.tsx
│       └── OnboardingFlow.tsx             ← Multi-step form wizard (4 steps)
│
├── lib/                                   ← Core Library / Helpers
│   ├── firebase/
│   │   ├── config.ts                      ← Firebase app init
│   │   ├── auth.ts                        ← Auth helpers (signIn, signOut, session)
│   │   ├── firestore.ts                   ← Firestore CRUD helpers
│   │   └── storage.ts                     ← Firebase Storage upload helpers
│   ├── ai/
│   │   ├── gemini.ts                      ← Gemini API client init
│   │   ├── prompts.ts                     ← All AI system prompts (centralized)
│   │   └── youtube.ts                     ← YouTube transcript fetcher
│   ├── utils/
│   │   ├── formatCurrency.ts              ← ₹ formatting helpers
│   │   ├── formatDate.ts
│   │   ├── categoryIcons.ts               ← Category → Icon mapping
│   │   └── eligibilityEngine.ts           ← Scheme eligibility tag calculator
│   └── constants/
│       ├── categories.ts                  ← Expense category definitions
│       ├── languages.ts                   ← Supported language list
│       └── routes.ts                      ← Centralized route constants
│
├── hooks/                                 ← Custom React Hooks
│   ├── useAuth.ts                         ← Auth state + user profile
│   ├── useTransactions.ts                 ← Real-time transaction listener
│   ├── useMonthlySummary.ts               ← Monthly stats hook
│   ├── useGoals.ts
│   ├── useBudget.ts
│   ├── useAIChat.ts                       ← Chat session state + streaming
│   └── useNotifications.ts
│
├── store/                                 ← Global State (Zustand)
│   ├── useUserStore.ts                    ← User profile state
│   ├── useUIStore.ts                      ← Sidebar open, theme, toasts
│   └── useOnboardingStore.ts              ← Onboarding step state
│
├── types/                                 ← TypeScript Type Definitions
│   ├── user.ts                            ← UserProfile (mirrors Firestore schema)
│   ├── transaction.ts                     ← Transaction type
│   ├── budget.ts
│   ├── goal.ts
│   ├── aiChat.ts
│   ├── learning.ts
│   ├── scheme.ts
│   └── consultant.ts
│
├── middleware.ts                          ← Auth guard (protects /dashboard/*)
│
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
├── .env.local                             ← Environment Variables
└── package.json
```

---

## 4. Page-by-Page Architecture

### 🏠 Landing Page — `/`

**Purpose:** Convert visitors to sign-ups. Marketing-focused.

**Sections to Build:**
- Hero section (tagline + CTA buttons → Register / Demo)
- Problem statement (pain points: 3-column grid)
- Feature showcase (Track → Analyze → Plan → Learn flow)
- Competitive comparison table
- AI Video Insights spotlight section (star feature)
- Testimonials / Social proof
- CTA Banner → "Start Free Today"
- Footer

**Data Needs:** None (static content, no Firebase)

**Rendering:** Static — `export const dynamic = 'force-static'`

---

### 🔐 Onboarding — `/auth/onboarding`

**Purpose:** Collect user profile data right after first registration.

**Steps (4-step wizard):**

| Step | Fields | Maps to Firebase |
|------|--------|-----------------|
| Step 1 | Occupation type (Job / Business / Student / Freelancer) | `occupationType` |
| Step 2 | Income range + optional exact income | `incomeRange`, `monthlyIncome` |
| Step 3 | Top 3 financial goals (multi-select) | `topGoals[]` |
| Step 4 | Preferred language + theme preference | `preferredLanguage`, `theme` |

**On Complete:** Write full profile to `users/{userId}`, compute `eligibilityTags`, set `isOnboardingComplete: true`, redirect to `/dashboard/overview`

---

### 📊 Dashboard Overview — `/dashboard/overview`

**Purpose:** Command center — snapshot of financial health.

**Widgets (layout: 3-col grid):**
- Summary Cards: Total Income / Total Expenses / Savings this month
- Spend Donut Chart (category breakdown from `monthly_summaries`)
- Budget Gauge (spent vs budgeted)
- Top 2 Goals progress bars
- Recent Transactions (last 5)
- AI Insight Banner (cached `aiInsightSummary` from `monthly_summaries`)
- Daily Tip Card (from `daily_tips`)

**Data Sources:**
- `users/{userId}` → `currentMonthSpent`, `currentMonthBudget`, `totalSavings`
- `monthly_summaries/{YYYY-MM}` → `categoryBreakdown`, `aiInsightSummary`
- `transactions` → last 5 entries (real-time listener)
- `daily_tips` → today's tip

**Rendering:** Server Component + Client Components for real-time widgets

---

### 💸 Transactions — `/dashboard/transactions`

**Purpose:** Full transaction history with filters.

**Features:**
- Filter bar: by month, category, type (expense/income), payment method
- Search by title or merchant name
- Sortable list (date, amount)
- Pagination (20 per page)
- Floating "Add Transaction" button
- Link to CSV Import

**Data Source:** `transactions` subcollection with Firestore composite indexes on `month` + `createdAt`

---

### 🤖 AI Chat — `/dashboard/ai/chat`

**Purpose:** Conversational AI financial advisor.

**UI Layout:**
- Left panel: Chat session history list (from `ai_chats`)
- Right panel: Active chat window (message bubbles + input)
- System context injected: user profile + current month summary

**Data Flow:**
1. User sends message → POST `/api/ai/chat`
2. API builds context (profile + monthly data) + calls Gemini with streaming
3. Stream response rendered token-by-token in chat
4. Full session written to `ai_chats/{sessionId}.messages`

---

### 🎥 Video Insights — `/dashboard/ai/video-insights`

**Purpose:** Paste YouTube link → get AI-powered financial summary.

**UI Flow:**
1. Input: YouTube URL field + "Analyze" button
2. Loading state: "Fetching transcript... Analyzing with AI..."
3. Result card:
   - Video title + thumbnail
   - 2-3 line Summary
   - Key Financial Tips (bulleted)
   - Action Points (checklist style)
   - "Save Insight" button

**API Flow:** POST `/api/ai/video-insights` → fetch transcript from YouTube API → send to Gemini → return structured JSON → save to `video_insights/{insightId}`

---

### 🎓 Learning Home — `/dashboard/learn`

**Purpose:** Personalized learning path landing page.

**Layout:**
- "Your Learning Path" section (modules matched to user's `occupationType`)
- Progress overview strip (modules completed / total)
- Module cards grid (locked/unlocked/completed states)
- Daily tip widget
- Badges earned shelf

**Data Source:** `learning_modules` (global) + `learning_progress` (user-specific)

---

### 🏦 Government Schemes — `/dashboard/schemes`

**Purpose:** Recommend relevant government schemes based on user profile.

**Layout:**
- "Recommended for You" section (filtered by `eligibilityTags`)
- All Schemes list (searchable, filterable by benefit type)
- Scheme Card: name, ministry, tagline, benefit amount, "Learn More" button

**Eligibility Logic:** `eligibilityEngine.ts` reads `occupationType` + `incomeRange` → computes matching `eligibilityTags` → filters `government_schemes` collection

---

### ⚙️ Settings — `/dashboard/settings`

**Sub-pages:**

| Tab | Page | Key Fields |
|-----|------|-----------|
| Profile | `/settings/profile` | Display name, photo, phone, email |
| Preferences | `/settings/preferences` | Language, theme, currency, notifications |
| Security | `/settings/security` | Change password, biometric toggle, delete account |

---

## 5. Component Architecture

### Component Categories

**1. Server Components (default in App Router)**
Used for: pages that fetch data at build/request time
Examples: `LearnPage`, `SchemesPage`, `SchemeDetailPage`, `BlogPost`

**2. Client Components (`'use client'`)**
Used for: interactive UI, real-time data, hooks, user events
Examples: `ChatInterface`, `TransactionForm`, `GoalCard`, `SpendChart`, `OnboardingFlow`

**3. Hybrid Pattern (recommended for dashboard)**
Parent page = Server Component (fetches initial data via Firebase Admin SDK)
Child widgets = Client Components (subscribe to real-time updates)

---

### Key Shared Components

**`SummaryCard`**
- Props: `title`, `value`, `delta` (vs last month), `icon`, `color`
- Used on: Overview, Budget, Goals pages

**`TransactionForm`**
- Props: `mode: 'add' | 'edit'`, `initialData?`
- Fields: amount, category, type, date, paymentMethod, title, note
- Validation: Zod schema

**`ChatInterface`**
- Props: `sessionId?` (loads existing or starts new)
- Internal state: `messages[]`, `isStreaming`, `inputValue`
- Uses `useAIChat` hook

**`OnboardingFlow`**
- Internal step management via `useOnboardingStore`
- 4 children step components, animated transitions
- Progress indicator at top

---

## 6. Data Fetching Strategy

| Scenario | Strategy | Where |
|----------|----------|-------|
| Dashboard summary stats | Server Component + Firestore Admin SDK | `overview/page.tsx` |
| Real-time transaction list | Client Component + `onSnapshot` listener | `TransactionList.tsx` |
| Learning modules (global content) | Static generation with ISR (revalidate 24h) | `learn/page.tsx` |
| Government schemes | Static generation with ISR | `schemes/page.tsx` |
| AI chat session | Client-side fetch + streaming | `chat/page.tsx` |
| User profile | Zustand store hydrated on login | `useUserStore.ts` |
| Monthly summary | SWR or React Query + Firestore | `useMonthlySummary.ts` |

---

## 7. State Management

### Tool: **Zustand**

**`useUserStore`**
- Holds: `user` (Firebase Auth user), `profile` (Firestore UserProfile doc)
- Actions: `setUser`, `setProfile`, `clearUser`
- Consumed by: Topbar, Sidebar, all dashboard pages, AI context builder

**`useUIStore`**
- Holds: `isSidebarOpen`, `toasts[]`, `activeTheme`
- Actions: `toggleSidebar`, `addToast`, `setTheme`

**`useOnboardingStore`**
- Holds: `step` (1-4), `formData` (partial UserProfile)
- Actions: `nextStep`, `prevStep`, `setField`, `reset`

### Real-time Data: Firestore `onSnapshot` listeners
Used for transactions, notifications, and chat messages.
Managed inside custom hooks (`useTransactions`, `useNotifications`, `useAIChat`).

---

## 8. API Routes (Next.js Route Handlers)

### `POST /api/ai/chat`

**Input:**
```json
{
  "message": "Can I afford a ₹15,000 vacation?",
  "sessionId": "abc123",
  "userContext": {
    "occupationType": "salaried",
    "monthlyIncome": 42000,
    "currentMonthSpent": 31500,
    "topGoals": ["vacation", "emergency_fund"]
  }
}
```

**Logic:**
- Build system prompt with user context from `lib/ai/prompts.ts`
- Call Gemini API with streaming enabled
- Stream response back to client
- Save full exchange to Firestore `ai_chats` collection

**Returns:** Streaming text response

---

### `POST /api/ai/video-insights`

**Input:**
```json
{
  "youtubeUrl": "https://youtube.com/watch?v=xyz"
}
```

**Logic:**
- Extract video ID from URL
- Fetch transcript via YouTube Transcript API
- Send transcript + user profile context to Gemini
- Request structured JSON output: `{ summary, keyTips[], actionPoints[] }`
- Save result to `video_insights` collection

**Returns:**
```json
{
  "videoTitle": "...",
  "thumbnailUrl": "...",
  "summary": "...",
  "keyTips": ["...", "..."],
  "actionPoints": ["...", "..."]
}
```

---

### `POST /api/ai/expense-analysis`

**Input:** `{ month: "2025-07" }`

**Logic:**
- Read `monthly_summaries/{month}` + last 30 transactions
- Build context prompt
- Call Gemini → get narrative insight paragraph
- Cache result back into `monthly_summaries.aiInsightSummary`

---

### `GET /api/schemes/recommend`

**Logic:**
- Read `eligibilityTags[]` from authenticated user's profile
- Query `government_schemes` where `eligibilityTags` array-contains-any user's tags
- Return filtered, sorted list

---

## 9. Authentication & Middleware

### Firebase Auth Flow

```
User visits /dashboard/*
        ↓
middleware.ts checks session cookie
        ↓
No valid session → redirect to /auth/login
Valid session   → allow through
        ↓
Page loads → useAuth hook hydrates user + profile into Zustand store
```

### `middleware.ts` — Route Protection

**Protected routes:** All paths starting with `/dashboard`
**Public routes:** `/`, `/auth/*`, `/features`, `/pricing`, `/about`, `/blog`

Logic: Read Firebase session cookie → verify with Firebase Admin SDK → allow or redirect

### Session Management

- On login: `POST /api/auth/session` → creates a 5-day Firebase session cookie
- On logout: Delete session cookie + Firebase signOut
- On every request to `/dashboard`: middleware verifies cookie server-side

---

## 10. Firebase Integration Layer

### `lib/firebase/config.ts`
Initializes Firebase Client SDK (Auth + Firestore + Storage) using environment variables. Exports: `app`, `auth`, `db`, `storage`

### `lib/firebase/auth.ts`
- `signInWithEmailAndPassword`
- `signInWithGoogle` (Google OAuth provider)
- `createUserWithEmailAndPassword`
- `signOut`
- `createSessionCookie` (calls `/api/auth/session`)

### `lib/firebase/firestore.ts`
Typed Firestore helpers:
- `getUser(uid)` → returns `UserProfile`
- `updateUser(uid, data)` → partial update
- `addTransaction(uid, data)` → writes to subcollection + increments `monthly_summaries`
- `getTransactions(uid, filters)` → paginated query
- `getMonthlySummary(uid, month)` → reads pre-aggregated doc
- `getGoals(uid)` → real-time listener
- `updateGoalProgress(uid, goalId, amount)` → atomic increment
- `saveAIChatMessage(uid, sessionId, message)` → append to messages array

### Firebase Admin SDK
Used only in API routes and middleware (server-side only):
- Verifying session cookies
- Writing back AI insight summaries
- Scheme recommendation queries (no auth required on client)

---

## 11. AI Integration Architecture

### Gemini Client — `lib/ai/gemini.ts`

Initializes the Google Generative AI SDK with `process.env.GEMINI_API_KEY`. Exports a configured `model` instance using `gemini-pro`.

### Centralized Prompts — `lib/ai/prompts.ts`

All system prompts are defined here as functions that accept user context and return the full prompt string. Prompts include:

- `buildChatSystemPrompt(userProfile, monthlySummary)` → general financial advisor persona
- `buildExpenseAnalysisPrompt(summary, transactions)` → for monthly insight generation
- `buildVideoInsightPrompt(transcript, userProfile)` → for YouTube analysis
- `buildBudgetSuggestionPrompt(userProfile)` → for budget creation assistant

### YouTube Transcript — `lib/ai/youtube.ts`
- Extracts video ID from URL
- Calls YouTube Transcript API (Python microservice via fetch, or JS wrapper)
- Returns cleaned transcript text

---

## 12. Environment Variables

```env
# .env.local

# Firebase (Client)
NEXT_PUBLIC_FIREBASE_API_KEY=
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=
NEXT_PUBLIC_FIREBASE_PROJECT_ID=
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=
NEXT_PUBLIC_FIREBASE_APP_ID=

# Firebase Admin (Server only)
FIREBASE_ADMIN_PROJECT_ID=
FIREBASE_ADMIN_CLIENT_EMAIL=
FIREBASE_ADMIN_PRIVATE_KEY=

# Gemini AI
GEMINI_API_KEY=

# YouTube Transcript (if using a microservice)
YOUTUBE_TRANSCRIPT_API_URL=

# App
NEXT_PUBLIC_APP_URL=https://finwise.in
```

> ⚠️ Variables prefixed with `NEXT_PUBLIC_` are exposed to the browser. Keep Admin SDK keys and Gemini API key server-side only (no `NEXT_PUBLIC_` prefix).

---

## 13. Layouts & Nesting Strategy

```
app/layout.tsx                      ← Root (html, body, Providers: Zustand, Theme)
│
├── (marketing)/layout.tsx          ← Navbar + Footer
│   └── page.tsx, features, pricing, about, blog/...
│
├── auth/layout.tsx                 ← Centered card layout, no nav
│   └── login, register, onboarding, forgot-password
│
└── dashboard/layout.tsx            ← Sidebar + Topbar shell
    ├── overview/page.tsx
    ├── transactions/...
    ├── ai/...
    ├── learn/...
    ├── settings/layout.tsx         ← Nested: Settings tab bar inside dashboard
    │   └── profile, preferences, security
    └── ...
```

### Dashboard Layout (`dashboard/layout.tsx`)
- Renders: `Sidebar` + `Topbar` + `{children}`
- Reads user from Zustand store
- Handles sidebar collapse state
- Applies theme class to wrapper

### Settings Layout (`dashboard/settings/layout.tsx`)
- Nested inside dashboard layout
- Renders a secondary tab bar: Profile | Preferences | Security
- `{children}` renders the active settings sub-page

---

## 14. SEO & Metadata Strategy

### Static Pages (Marketing)

Each marketing page exports a `metadata` object:

```typescript
// Example: /features page
export const metadata: Metadata = {
  title: 'Features | FinWise — Smart AI Finance Platform',
  description: 'Track expenses, get AI insights, learn finance — all in one app.',
  openGraph: { ... },
  twitter: { ... },
}
```

### Dynamic Pages

For blog posts and scheme detail pages, use `generateMetadata` function:
- Fetch the document from Firestore (or CMS)
- Return dynamic `title`, `description`, `openGraph` based on content

### Dashboard Pages

Dashboard pages are excluded from public indexing:
```typescript
// dashboard/layout.tsx
export const metadata: Metadata = {
  robots: { index: false, follow: false }
}
```

---

## 15. Prompt Reference Sheet

> Use these prompts when building each part of the website with an AI coding assistant. Copy-paste as task descriptions.

---

### 🔧 Setup & Config

```
Set up a Next.js 14 App Router project with TypeScript and Tailwind CSS.
Install and configure Firebase SDK (Auth, Firestore, Storage).
Install Zustand for state management.
Create lib/firebase/config.ts that initializes the Firebase app using
environment variables from .env.local and exports auth, db, and storage.
```

---

### 🔒 Middleware & Auth Guard

```
Create middleware.ts for a Next.js 14 App Router project that protects
all routes under /dashboard/*. Read a Firebase session cookie named
'finwise_session', verify it using Firebase Admin SDK, and redirect
unauthenticated users to /auth/login. Allow all other routes through.
```

---

### 🏠 Dashboard Layout

```
Build the dashboard/layout.tsx for FinWise — a finance app. Include a
fixed left Sidebar with navigation links: Overview, Transactions, Budget,
Goals, AI Assistant, Learn, Schemes, Experts, Notifications, and Settings.
Include a Topbar with the user's avatar, name, and a notification bell icon.
The layout should support sidebar collapse on desktop and a slide-out drawer
on mobile. Use Tailwind CSS. Read user data from a Zustand useUserStore hook.
```

---

### 📊 Overview Page Widgets

```
Build the /dashboard/overview page for FinWise. Fetch data server-side from
Firebase Firestore: the user's profile doc (currentMonthSpent, currentMonthBudget,
totalSavings) and the current month's monthly_summaries doc (categoryBreakdown,
aiInsightSummary). Render the following widgets in a responsive grid: three
SummaryCards (Income, Expenses, Savings), a donut chart using Recharts for
category breakdown, a budget progress bar, the last 5 transactions, and an
AI insight banner with the cached Gemini summary. Use Tailwind for styling.
```

---

### 💬 AI Chat Interface

```
Build the AI Chat page for FinWise at /dashboard/ai/chat using Next.js 14
with React client components. The UI should have a split layout: left panel
lists past chat sessions from Firestore ai_chats collection, right panel
shows the active conversation. Messages should appear as bubbles (user on
right, AI on left). Implement streaming by calling POST /api/ai/chat and
reading the response as a ReadableStream. Show a typing indicator while
streaming. Save the completed message to Firestore after streaming ends.
Use Tailwind CSS.
```

---

### 🎥 Video Insights Tool

```
Build the /dashboard/ai/video-insights page for FinWise. Include a URL
input field for YouTube links and an Analyze button. On submit, call
POST /api/ai/video-insights with the URL. Show a multi-step loading state:
"Fetching video transcript..." then "Analyzing with Gemini AI...". On success,
display a result card with: video thumbnail, title, a 2-3 line summary,
a Key Financial Tips section (bulleted list), and an Action Points section
(checkable list). Include a Save Insight button that writes the result to
Firestore video_insights collection. Use Tailwind CSS.
```

---

### 🎓 Onboarding Flow

```
Build a 4-step onboarding wizard for FinWise at /auth/onboarding using
Next.js and React. Use Zustand (useOnboardingStore) to track the current
step and form data. Step 1: select occupation type (Job, Business, Student,
Freelancer) as large clickable cards. Step 2: select income range as radio
buttons plus an optional exact income field. Step 3: pick top 3 financial
goals from a grid of options (House, Vehicle, Emergency Fund, Vacation,
Investment, Education). Step 4: choose preferred language and app theme.
On final submit, write the full profile to Firestore users/{uid}, compute
eligibilityTags using eligibilityEngine.ts, set isOnboardingComplete: true,
then redirect to /dashboard/overview. Show a step progress indicator at the top.
```

---

### 🏦 Scheme Recommender

```
Build the /dashboard/schemes page for FinWise. On load, read the user's
eligibilityTags from their Firestore profile. Query the government_schemes
collection for schemes where eligibilityTags array-contains-any the user's
tags. Display matched schemes in a "Recommended for You" section. Below that,
show all active schemes in a searchable, filterable list. Each SchemeCard
should show: emoji icon, scheme name, ministry, tagline, benefit type badge,
max benefit amount, and a "View Details" button. Filter bar should allow
filtering by benefit type (loan, subsidy, insurance, pension). Use Tailwind
CSS and Next.js server components for the initial fetch.
```

---

### 📈 Transaction Add Form

```
Build the Add Transaction form for FinWise at /dashboard/transactions/add.
Fields: Transaction Type (expense/income/transfer toggle), Amount (₹, number
input), Category (dropdown: food, transport, shopping, health, entertainment,
bills, salary, investment), Sub-category (conditional), Title, Date (date picker,
defaults to today), Payment Method (UPI, Cash, Debit Card, Credit Card, Net
Banking, EMI), Optional Note. Validate using Zod schema. On submit, write to
Firestore users/{uid}/transactions and atomically increment the corresponding
monthly_summaries document for the transaction month. Show a success toast and
redirect to /dashboard/transactions. Use Tailwind CSS.
```

---

### 🔌 API Route — AI Chat (Streaming)

```
Create a Next.js 14 Route Handler at app/api/ai/chat/route.ts for FinWise.
Accept POST requests with body: { message, sessionId, userContext }. Build a
system prompt using the userContext (occupationType, monthlyIncome,
currentMonthSpent, topGoals) using the buildChatSystemPrompt function from
lib/ai/prompts.ts. Call the Gemini API (gemini-pro model) with streaming
enabled. Return the stream as a StreamingTextResponse. Handle errors and
return appropriate HTTP status codes. After streaming completes, save the
full user + assistant message exchange to Firestore ai_chats/{sessionId}.
```

---

*Architecture Document Version: 1.0*  
*FinWise Web Team | Next.js 14 + Firebase + Gemini AI*  
*Built for Hackathon MVP → Production Scale*
