# 🏦 FinWise — Smart AI-Based Finance Platform
### Hackathon Project Document | Domain: FinTech & Digital Economy

---

## 📋 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Problem Statement](#2-problem-statement)
3. [Proposed Solution](#3-proposed-solution)
4. [Core Features](#4-core-features)
5. [Innovation Highlights](#5-innovation-highlights)
6. [Tech Stack](#6-tech-stack)
7. [System Architecture](#7-system-architecture)
8. [User Flow](#8-user-flow)
9. [MVP Scope](#9-mvp-scope)
10. [Feasibility Analysis](#10-feasibility-analysis)
11. [Potential Impact](#11-potential-impact)
12. [Future Roadmap](#12-future-roadmap)
13. [Evaluation Criteria Mapping](#13-evaluation-criteria-mapping)

---

## 1. Project Overview

| Field | Details |
|-------|---------|
| **Project Name** | FinWise |
| **Tagline** | *Not just tracking money — improving financial intelligence* |
| **Domain** | FinTech & Digital Economy |
| **Platforms** | Mobile (Flutter) + Web (Next.js) |
| **Target Users** | Students, Salaried Employees, Business Owners |
| **Core Engine** | Gemini AI + Google ML Kit |

### 🎯 One-Line Pitch
> FinWise is an all-in-one AI-powered personal finance platform that combines expense tracking, smart budgeting, personalized financial education, and YouTube video insights — all tailored to your income type and goals.

---

## 2. Problem Statement

India has **500M+ smartphone users** but very low financial literacy and discipline. Key pain points:

| # | Problem | Impact |
|---|---------|--------|
| 1 | People don't track daily expenses | Uncontrolled spending, no savings |
| 2 | Lack of accessible financial education | Poor investment decisions |
| 3 | No personalized financial advice | Generic advice doesn't work |
| 4 | Too many fragmented apps | Tracking here, learning there, no sync |
| 5 | Complex government financial schemes | Users miss out on benefits |
| 6 | Language barriers | Financial tools mostly in English only |

### 💬 Real Scenario
> Ravi earns ₹40,000/month. He uses one app to track expenses, watches random YouTube finance videos, and still doesn't know if he qualifies for PM Mudra Yojana. He's financially lost — FinWise solves all of this in one place.

---

## 3. Proposed Solution

**FinWise** is a unified, AI-first personal finance platform with 6 intelligent modules:

```
┌─────────────────────────────────────────────────────────┐
│                        FinWise                          │
│                                                         │
│   📊 Track  →  🤖 Analyze  →  🎯 Plan  →  🎓 Learn    │
│                                                         │
│        All powered by Gemini AI + User Profile         │
└─────────────────────────────────────────────────────────┘
```

---

## 4. Core Features

### 📊 A. Expense & Transaction Management

> Effortlessly log, import, and analyze every rupee

- ✅ **Add Transaction** — Manual entry via app & web
- ✅ **Bulk Import** — Upload bank statements / CSV files
- ✅ **Transaction History** — Filterable, searchable log
- ✅ **OCR Bill Scanner** — Scan any bill/receipt → AI auto-fills entry (powered by Google ML Kit)

**Output:**
- AI-generated Expense Breakdown (charts + smart insights)
- Category-wise spend analysis
- Month-over-month comparison

---

### 🤖 B. AI Smart Assistant

> Your personal finance advisor, available 24/7

- 💬 **Chat with AI** — Ask anything: *"Can I afford a ₹15,000 vacation next month?"*
- 📅 **Budget Assistant** — Generates monthly budget plan based on income & goals
- 📈 **Investment Assistant** — Basic investment guidance (FD, SIP, gold, etc.)

**Example Interaction:**
```
User: "Can I save ₹10,000 this month?"
FinWise AI: "Based on your ₹42,000 income and ₹31,500 in fixed expenses,
you can save up to ₹10,500 if you cut dining out by 30%.
Here's a plan 👇"
```

---

### 🎯 C. Goal & Planning

> Dream it. Plan it. Achieve it.

- 🏠 Set goals: House, vehicle, emergency fund, vacation
- 📊 Visual progress tracker per goal
- 🧠 AI Smart Suggestions based on income and spending habits
- 🔔 Milestone alerts and reminders

---

### 🎓 D. Learning Mode *(Key Differentiator)*

> Financial literacy made simple, personalized, and fun

| User Type | Personalized Content |
|-----------|---------------------|
| 👔 Salaried | Salary management, Tax saving, PF/EPF, HRA |
| 🏪 Business | GST, loans, government schemes, business expenses |
| 🎓 Student | Budgeting basics, SIP intro, first salary tips |

**Features:**
- 📚 Bite-sized educational modules
- 🧩 Quizzes with rewards/badges
- 🗺️ Personalized learning path based on onboarding profile
- 📰 Daily financial tips

---

### 🎥 E. AI Video Insights *(Unique Star Feature ⭐)*

> Turn any finance YouTube video into actionable wisdom

**How it works:**
1. User pastes a YouTube video link
2. Gemini AI analyzes the video transcript
3. FinWise generates:
   - 📝 **Summary** (2-3 lines)
   - 💡 **Key Financial Tips** (bullet points)
   - ✅ **Action Points** (what to do today)

**Example:**
```
Video: "How to invest ₹5000/month in 2024" (30-min video)

FinWise Summary:
→ Summary: Start SIP early, diversify across index funds...
→ Key Tips: Invest minimum 20% of income, use Nifty 50 index...
→ Action Points: Open a Zerodha/Groww account, Start ₹500 SIP today
```

> **Why it's innovative:** No other personal finance app digests external video content for the user and gives personalized action points.

---

### 👤 F. User Profiling & Personalization

> FinWise adapts to YOU from Day 1

**Onboarding Questions:**
- Occupation type: Job / Business / Student / Freelancer
- Monthly income range
- Top 3 financial goals
- Preferred language

**Output — Everything is personalized:**
- Financial advice tone & complexity
- Learning path content
- Government scheme recommendations
- Budget templates

---

### 🌐 G. Extra Features

- 🌍 **Multi-language Support** — Hindi, Marathi, Tamil, Telugu + more
- 🔔 **Smart Alerts** — Overspending warnings, bill reminders
- 📈 **AI Expense Prediction** — Predict next month's expenses based on patterns
- 🏦 **Government Scheme Recommender** — Based on user profile (PM Mudra, Jan Dhan, etc.)
- 👨‍💼 **Expert Connect** — Book sessions with certified financial consultants

---

## 5. Innovation Highlights

```
╔══════════════════════════════════════════════════════════╗
║              What Makes FinWise Different?               ║
╠══════════════════════════════════════════════════════════╣
║  1. AI + Finance + Learning in ONE unified app           ║
║  2. YouTube Video → AI Insights (extremely rare)         ║
║  3. Personalization from Day 1 via user profiling        ║
║  4. OCR + AI + Chat = Full Automation Loop               ║
║  5. Government Scheme Recommender                        ║
║  6. Vernacular (multi-language) support                  ║
╚══════════════════════════════════════════════════════════╝
```

### 🆚 Competitive Comparison

| Feature | FinWise | Walnut | Money View | ET Money |
|---------|---------|--------|------------|----------|
| Expense Tracking | ✅ | ✅ | ✅ | ✅ |
| AI Chat Assistant | ✅ | ❌ | ❌ | ❌ |
| Financial Education | ✅ | ❌ | ❌ | ✅ (basic) |
| YouTube AI Insights | ✅ | ❌ | ❌ | ❌ |
| OCR Bill Scan | ✅ | ❌ | ✅ | ❌ |
| Govt Scheme Recommender | ✅ | ❌ | ❌ | ❌ |
| Multi-language | ✅ | ❌ | ✅ | ❌ |
| Goal Planning + AI | ✅ | ✅ | ✅ | ✅ |

---

## 6. Tech Stack

### 📱 Mobile App
| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| State Management | Riverpod / BLoC |
| Local Storage | Hive / SQLite |
| OCR | Google ML Kit |

### 🌐 Web App
| Layer | Technology |
|-------|-----------|
| Framework | Next.js 14 (App Router) |
| Styling | Tailwind CSS |
| Charts | Recharts / Chart.js |

### 🔧 Backend
| Layer | Technology |
|-------|-----------|
| Server | Node.js / FastAPI (Python) |
| Database | Firebase Firestore / PostgreSQL |
| Auth | Firebase Auth / Clerk |
| Storage | Firebase Storage |

### 🤖 AI & ML
| Feature | Technology |
|---------|-----------|
| Chat Assistant | Gemini API (Google) |
| Video Analysis | Gemini + YouTube Transcript API |
| Expense Insights | Gemini API |
| OCR | Google ML Kit |
| Expense Prediction | Custom ML model / Gemini |

### ☁️ Cloud & DevOps
| Component | Technology |
|-----------|-----------|
| Hosting (Web) | Vercel |
| Mobile CI/CD | GitHub Actions + Codemagic |
| API Gateway | Cloud Run / Railway |

---

## 7. System Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                         USER LAYER                           │
│         Flutter App (Mobile)  |  Next.js (Web)              │
└────────────────────┬─────────────────────┬───────────────────┘
                     │                     │
                     ▼                     ▼
┌──────────────────────────────────────────────────────────────┐
│                      API GATEWAY                             │
│                  (Node.js / FastAPI)                         │
└──────┬───────────┬────────────┬──────────────┬──────────────┘
       │           │            │              │
       ▼           ▼            ▼              ▼
┌──────────┐ ┌─────────┐ ┌──────────┐ ┌────────────────┐
│ Expense  │ │  User   │ │   AI     │ │   Learning     │
│  Module  │ │ Profile │ │ Module   │ │    Module      │
│          │ │ Service │ │ (Gemini) │ │                │
└──────────┘ └─────────┘ └──────────┘ └────────────────┘
       │           │            │              │
       └───────────┴────────────┴──────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │      DATABASE LAYER     │
              │  Firebase / PostgreSQL  │
              └─────────────────────────┘
```

---

## 8. User Flow

```
App Launch
    │
    ▼
Onboarding (First time)
    ├── Select: Job / Business / Student
    ├── Set income range
    ├── Set goals
    └── Choose language
         │
         ▼
      Dashboard
    ┌────┼──────────────────────┐
    │    │                      │
    ▼    ▼                      ▼
Track  AI Chat             Learn & Grow
Expense  Assistant         Financial Modules
    │    │                      │
    ▼    ▼                      ▼
OCR  Budget Plan          Quizzes + Badges
Scan     │
         ▼
    Goal Progress
    Smart Alerts
    Video Insights
```

---

## 9. MVP Scope

> What can be built and demoed within hackathon timeframe

### ✅ Must Have (MVP)
- [ ] User Onboarding with Profiling
- [ ] Add / View Transactions
- [ ] AI-powered Expense Breakdown (Gemini)
- [ ] Basic AI Chat Assistant
- [ ] 1 Learning Module (Salaried user)
- [ ] Goal Setting + Progress View

### 🚀 Good to Have (Bonus)
- [ ] OCR Bill Scan (ML Kit)
- [ ] YouTube Video AI Insights
- [ ] Smart Alerts (basic overspending)
- [ ] Government Scheme Recommender

### 🔮 Future (Post-Hackathon)
- [ ] Full multi-language support
- [ ] Bank account integration
- [ ] Investment marketplace
- [ ] Credit score tracking
- [ ] Expert consultant booking

---

## 10. Feasibility Analysis

### ✅ Why This Is Achievable

| Concern | Answer |
|---------|--------|
| AI Integration complexity | Gemini API is well-documented and fast to integrate |
| Cross-platform dev | Flutter handles mobile, Next.js handles web — both fast frameworks |
| OCR | Google ML Kit is plug-and-play |
| Database | Firebase is serverless — no backend infra needed for MVP |
| Video Insights | YouTube Transcript API + Gemini — 2 API calls max |

### ⚠️ Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Gemini API rate limits | Cache responses + retry logic |
| OCR accuracy issues | Manual correction fallback UI |
| Data privacy (financial data) | Local-first storage, no PII in AI prompts |
| Complex UI on both platforms | Shared design system (Figma tokens) |

---

## 11. Potential Impact

### 👥 Target Audience Size

| Segment | India Population | Addressable Users |
|---------|-----------------|-------------------|
| Salaried employees | ~150M | ~80M |
| Small business owners | ~63M | ~30M |
| Students (college+) | ~38M | ~20M |
| **Total TAM** | | **~130M users** |

### 🌍 Societal Impact
- 📈 Improves **financial literacy** across income levels
- 💰 Encourages **savings culture** in young Indians
- 🏦 Helps users discover and access **government schemes**
- 🌐 Removes **language barrier** from financial tools
- 📊 Supports India's **Digital Economy** vision

### 🔢 Success Metrics (1-Year Post Launch)
- 100K+ registered users
- ₹5Cr+ tracked in expenses
- 1M+ learning modules completed
- 50K+ YouTube videos analyzed

---

## 12. Future Roadmap

```
Phase 1 (MVP - Hackathon)
├── Expense tracking
├── AI Chat
└── Basic Learning

Phase 2 (3-6 Months)
├── Bank SMS/API integration
├── Full OCR pipeline
├── Multi-language rollout
└── YouTube Video Insights (live)

Phase 3 (6-12 Months)
├── Investment marketplace
├── Credit score tracking
├── Expert consultant marketplace
└── Business accounting module

Phase 4 (12-24 Months)
├── NBFC partnerships
├── Embedded insurance
├── WhatsApp bot integration
└── Open banking API support
```

---

## 13. Evaluation Criteria Mapping

### 🏆 How FinWise Scores on All 4 Parameters

#### 💡 Innovation
> *"AI + Finance + Learning — in a single personalized platform"*
- YouTube → AI Insights feature is **first-of-its-kind** in personal finance apps
- OCR + AI + Chat creates a **fully automated** finance entry loop
- Personalization engine adapts the entire UX based on user type

#### 🎯 Problem Relevance
> *"Solves real, widespread, and unaddressed pain points"*
- India has 500M+ smartphone users with **low financial literacy**
- Fragmented tools mean people give up tracking entirely
- Language barrier keeps rural/semi-urban users out of financial tools
- Every feature maps to a **documented, real-world problem**

#### ⚙️ Feasibility
> *"Built on proven, production-ready technologies"*
- Flutter + Next.js = battle-tested cross-platform stack
- Gemini API + Firebase = rapid, scalable MVP
- MVP can be demoed in **under 48 hours** of development
- No proprietary hardware required — runs entirely on cloud

#### 🌍 Potential Impact
> *"Designed for 130M+ users across India"*
- Multi-language support = accessibility for Bharat
- Government scheme recommender = direct financial benefit
- Financial education = long-term behavior change
- Scalable architecture = can grow to millions of users

---

## 📎 Appendix

### Glossary
| Term | Meaning |
|------|---------|
| OCR | Optical Character Recognition — reads text from images |
| SIP | Systematic Investment Plan |
| GST | Goods and Services Tax |
| Gemini | Google's multimodal AI model |
| ML Kit | Google's on-device machine learning SDK |
| TAM | Total Addressable Market |

### Key Integrations
- **Gemini API** — `https://ai.google.dev`
- **YouTube Transcript API** — `https://pypi.org/project/youtube-transcript-api/`
- **Google ML Kit** — `https://developers.google.com/ml-kit`
- **Firebase** — `https://firebase.google.com`

---

*Document prepared for Hackathon Submission | FinWise Team*
*Domain: FinTech & Digital Economy*
