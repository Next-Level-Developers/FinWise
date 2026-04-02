# FinWise AI API Integration Guide

**Version:** 1.0  
**Date:** April 2026  
**Scope:** Web and Flutter integration for all AI APIs in FinWise  
**AI Runtime:** Groq via LangChain on the Next.js backend  
**Format:** Single-source integration guide with request and response examples

---

## Purpose

This guide documents every AI API currently implemented in FinWise, including:

- Request payloads
- Response shapes
- Cache behavior
- Firestore write targets
- Flutter integration examples
- Common validation and error formats

Use this as the one reference for integrating FinWise AI from the web app or from Flutter.

---

## Base URL

Use the same endpoint path structure in both web and Flutter.

### Local Development

```text
http://localhost:3000
```

### Example Endpoint

```text
POST /api/ai/chat
```

### Headers

All endpoints expect JSON.

```http
Content-Type: application/json
Accept: application/json
```

If you later add auth, include the token header as well.

```http
Authorization: Bearer <token>
```

---

## Common API Contract

Every AI route follows the same shape:

### Success Response

```json
{
  "success": true,
  "insight_type": "chat_message",
  "result": {},
  "cache_ttl": "none"
}
```

Some routes may use `cache_ttl_hours`, `cache_ttl_days`, or `cache_scope` instead of `cache_ttl`.

### Error Response

```json
{
  "error": "Validation failed",
  "details": ["field.path: message"]
}
```

```json
{
  "error": "AI processing failed",
  "message": "Model did not return valid JSON"
}
```

### HTTP Status Codes

| Status | Meaning |
|---|---|
| 200 | Success |
| 400 | Invalid JSON body |
| 422 | Validation failed |
| 500 | AI or server processing failed |

---

## Shared PII Safety Rules

Never send these to the AI model:

- `email`
- `displayName`
- `phoneNumber`
- `photoURL`
- `uid`
- transaction `title`
- transaction `merchantName`
- transaction `note`
- goal `title`

Safe context fields:

- `occupationType`
- `incomeRange`
- `monthlyIncome`
- `currentMonthBudget`
- `currentMonthSpent`
- `topGoals`
- `preferredLanguage`
- `eligibilityTags`
- category totals and monthly summaries

---

## Flutter Integration Setup

### pubspec.yaml

```yaml
dependencies:
  http: ^1.2.2
```

### Generic Flutter Client

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class FinWiseApiClient {
  FinWiseApiClient({required this.baseUrl});

  final String baseUrl;

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded['message'] ?? decoded['error'] ?? 'Request failed';
      throw Exception(message);
    }

    return decoded;
  }
}
```

### Flutter Usage Pattern

```dart
final client = FinWiseApiClient(baseUrl: 'http://localhost:3000');
final response = await client.postJson('/api/ai/chat', payload);
final result = response['result'] as Map<String, dynamic>;
```

---

## 1. Expense Insights

**Route:** `POST /api/ai/expense-insights`  
**Purpose:** Monthly spending analysis, anomalies, recommendations, next month forecast  
**Cache:** 24 hours

### Request Body

```json
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
  ]
}
```

### Response Body

```json
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
    "anomalies": ["3 large transactions above ₹2,000 in entertainment this week"],
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

### Flutter Example

```dart
final payload = {
  'user': {
    'occupationType': 'salaried',
    'incomeRange': '25k-50k',
    'monthlyIncome': 42000,
    'currentMonthBudget': 38000,
    'currentMonthSpent': 31500,
    'topGoals': ['emergency_fund', 'vacation'],
  },
  'monthlySummary': {
    'month': '2026-04',
    'totalIncome': 42000,
    'totalExpense': 31500,
    'totalSavings': 10500,
    'savingsRate': 0.25,
    'categoryBreakdown': {'food': 8500, 'transport': 3000},
    'budgetAmount': 38000,
    'budgetVariance': -6500,
    'txnCount': 47,
  },
  'recentTransactions': [],
};

final response = await client.postJson('/api/ai/expense-insights', payload);
```

---

## 2. Generate Budget

**Route:** `POST /api/ai/generate-budget`  
**Purpose:** Build a realistic monthly budget based on history and goals  
**Cache:** Per budget document

### Request Body

```json
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
      "categoryBreakdown": { "food": 8000, "transport": 2800 },
      "savingsRate": 0.238
    },
    {
      "month": "2026-03",
      "totalIncome": 41000,
      "totalExpense": 31200,
      "categoryBreakdown": { "food": 8300, "transport": 2900 },
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
    }
  ],
  "lastBudget": {
    "totalBudget": 38000,
    "categoryLimits": {
      "food": 8500,
      "transport": 3500
    }
  }
}
```

### Response Body

```json
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

### Flutter Example

```dart
final response = await client.postJson('/api/ai/generate-budget', {
  'user': {
    'occupationType': 'salaried',
    'incomeRange': '25k-50k',
    'monthlyIncome': 42000,
    'topGoals': ['emergency_fund'],
    'currentMonthSpent': 31500,
  },
  'monthlySummaries': [],
  'activeGoals': [],
  'lastBudget': null,
});
```

---

## 3. AI Chat

**Route:** `POST /api/ai/chat`  
**Purpose:** Real-time conversational finance assistant  
**Cache:** None

### Request Body

```json
{
  "sessionId": "chat-session-abc123",
  "mode": "general",
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
    "categoryBreakdown": { "food": 8500, "transport": 3000 }
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
    "categoryLimits": { "food": 8000, "transport": 3500 }
  },
  "recentMessages": [
    {
      "role": "user",
      "content": "What should I do with my savings?",
      "createdAt": "2026-04-02T10:00:00Z"
    }
  ]
}
```

### Response Body

```json
{
  "success": true,
  "insight_type": "chat_message",
  "session_id": "chat-session-abc123",
  "result": {
    "reply": "Based on your ₹42,000 income and ₹31,500 spent so far, you have ₹10,500 left. If you skip dining out twice this week, you can hit your ₹10,000 savings target easily!",
    "suggestedActions": ["View your food expenses", "Update your emergency fund goal"],
    "followUpSuggestions": ["How can I reduce transport costs?", "Show me my savings trend"]
  },
  "cache_ttl": "none"
}
```

### Flutter Example

```dart
final response = await client.postJson('/api/ai/chat', {
  'sessionId': 'chat-session-abc123',
  'mode': 'general',
  'message': 'How can I save more money this month?',
  'userContext': {
    'occupationType': 'salaried',
    'incomeRange': '25k-50k',
    'monthlyIncome': 42000,
  },
  'recentMessages': [],
});

final reply = response['result']['reply'] as String;
```

---

## 4. Goal Advice

**Route:** `POST /api/ai/goal-advice`  
**Purpose:** Forecast goal completion and suggest improvements  
**Cache:** 3 days

### Request Body

```json
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
    }
  ],
  "currentBudget": {
    "totalBudget": 38000,
    "categoryLimits": { "investment": 6000 }
  }
}
```

### Response Body

```json
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
      "Set up auto-deduction on salary day"
    ],
    "milestoneMessage": "You're 25% there — great progress!",
    "riskLevel": "medium"
  },
  "cache_ttl_days": 3
}
```

### Flutter Example

```dart
final response = await client.postJson('/api/ai/goal-advice', {
  'user': {
    'occupationType': 'salaried',
    'incomeRange': '25k-50k',
    'monthlyIncome': 42000,
  },
  'goal': {
    'category': 'emergency_fund',
    'targetAmount': 200000,
    'currentAmount': 50000,
    'progressPercent': 25,
    'targetDate': '2027-12-31',
    'status': 'active',
    'priority': 'high',
  },
  'recentSummaries': [],
});
```

---

## 5. Video Insights

**Route:** `POST /api/ai/video-insights`  
**Purpose:** Analyze finance videos and generate actionable takeaways  
**Cache:** Permanent per video ID

### Request Body

```json
{
  "videoId": "dQw4w9WgXcQ",
  "videoTitle": "How to invest ₹5000/month in 2024",
  "transcript": "Today we're discussing investment strategies for Indians...",
  "userContext": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "topGoals": ["emergency_fund", "investment"],
    "preferredLanguage": "en"
  }
}
```

### Response Body

```json
{
  "success": true,
  "insight_type": "video_insights",
  "video_id": "dQw4w9WgXcQ",
  "result": {
    "summary": "The video explains how to build a diversified investment portfolio starting with ₹5,000/month.",
    "keyTips": [
      "Invest at least 20% of monthly income",
      "Start a Nifty 50 index fund SIP",
      "Avoid timing the market"
    ],
    "actionPoints": [
      "Open a Zerodha or Groww account today",
      "Start a ₹500/month SIP"
    ],
    "relevanceScore": 0.91,
    "relatedGoals": ["investment"],
    "relatedCategory": "investment"
  },
  "cache_ttl": "permanent_per_video_id"
}
```

### Flutter Example

```dart
final response = await client.postJson('/api/ai/video-insights', {
  'videoId': 'dQw4w9WgXcQ',
  'videoTitle': 'How to invest ₹5000/month in 2024',
  'transcript': 'Today we are discussing investment strategies...',
  'userContext': {
    'occupationType': 'salaried',
    'incomeRange': '25k-50k',
    'topGoals': ['investment'],
    'preferredLanguage': 'en',
  },
});
```

---

## 6. Scheme Recommend

**Route:** `POST /api/ai/scheme-recommend`  
**Purpose:** Match user profile to relevant government schemes  
**Cache:** 7 days

### Request Body

```json
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
    }
  ]
}
```

### Response Body

```json
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
      }
    ],
    "totalSchemesFetched": 15,
    "totalMatched": 4
  },
  "cache_ttl_days": 7
}
```

### Flutter Example

```dart
final response = await client.postJson('/api/ai/scheme-recommend', {
  'user': {
    'occupationType': 'business',
    'incomeRange': '10k-25k',
    'monthlyIncome': 18000,
    'eligibilityTags': ['self_employed', 'small_business'],
  },
  'schemes': [],
});
```

---

## 7. Predict Expenses

**Route:** `POST /api/ai/predict-expenses`  
**Purpose:** Forecast next month spending from history and recurring costs  
**Cache:** 7 days

### Request Body

```json
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
      "categoryBreakdown": { "food": 8000, "transport": 2800 },
      "savingsRate": 0.2625
    }
  ],
  "recurringTransactions": [
    { "amount": 500, "category": "bills", "paymentMethod": "upi" }
  ],
  "nextMonthBudget": {
    "totalBudget": 38000,
    "categoryLimits": { "food": 8000, "transport": 3500 }
  }
}
```

### Response Body

```json
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
      }
    },
    "warnings": [
      "Your transport spend has been rising 10–15% monthly — watch out."
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

### Flutter Example

```dart
final response = await client.postJson('/api/ai/predict-expenses', {
  'user': {
    'occupationType': 'salaried',
    'incomeRange': '25k-50k',
    'monthlyIncome': 42000,
  },
  'monthlySummaries': [],
  'recurringTransactions': [],
});
```

---

## 8. OCR Categorize

**Route:** `POST /api/ai/ocr-categorize`  
**Purpose:** Convert bill OCR text into a structured transaction object  
**Cache:** None

### Request Body

```json
{
  "ocrRawText": "ZOMATO INDIA\nOrder #ZOM998821\nItem: Butter Chicken x2 - ₹480\nDelivery - ₹40\nTotal: ₹520\nDate: 12 Jul 2025",
  "userContext": {
    "preferredLanguage": "en",
    "occupationType": "salaried"
  }
}
```

### Response Body

```json
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

### Flutter Example

```dart
final response = await client.postJson('/api/ai/ocr-categorize', {
  'ocrRawText': 'ZOMATO INDIA\nTotal: ₹520',
  'userContext': {
    'preferredLanguage': 'en',
    'occupationType': 'salaried',
  },
});
```

---

## 9. Learning Path

**Route:** `POST /api/ai/learning-path`  
**Purpose:** Recommend the next best financial learning modules  
**Cache:** 14 days

### Request Body

```json
{
  "user": {
    "occupationType": "salaried",
    "incomeRange": "25k-50k",
    "topGoals": ["emergency_fund", "investment"],
    "preferredLanguage": "en"
  },
  "learningProgress": [
    {
      "moduleId": "salary-management-basics",
      "status": "completed",
      "progressPercent": 100,
      "bestQuizScore": 88,
      "quizPassed": true
    }
  ],
  "badges": [
    { "badgeId": "first_lesson", "category": "engagement" }
  ],
  "learningModules": [
    {
      "id": "epf-explained",
      "title": "EPF & PF Explained",
      "targetOccupation": "salaried",
      "targetIncomeRange": "25k-50k",
      "difficulty": "beginner",
      "tags": ["epf", "retirement"],
      "category": "fundamentals",
      "estimatedMins": 20,
      "hasQuiz": true
    }
  ]
}
```

### Response Body

```json
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
      }
    ],
    "learnerLevel": "beginner",
    "motivationNote": "You're on a 5-day streak! Keep going — just 2 modules to earn the 'Finance Starter' badge.",
    "nextBadgeHint": "Complete 3 modules to unlock the Finance Starter badge 🏅"
  },
  "cache_ttl_days": 14
}
```

### Flutter Example

```dart
final response = await client.postJson('/api/ai/learning-path', {
  'user': {
    'occupationType': 'salaried',
    'incomeRange': '25k-50k',
    'topGoals': ['emergency_fund'],
    'preferredLanguage': 'en',
  },
  'learningProgress': [],
  'badges': [],
  'learningModules': [],
});
```

---

## 10. Smart Alerts

**Route:** `POST /api/ai/smart-alerts`  
**Purpose:** Generate alert copy for overspend, milestones, and important actions  
**Cache:** Event-driven

### Request Body

```json
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
      "transport": 2950
    },
    "budgetVariance": -6500
  },
  "currentBudget": {
    "categoryLimits": { "food": 8000, "transport": 3500 },
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
    }
  ]
}
```

### Response Body

```json
{
  "success": true,
  "insight_type": "smart_alert",
  "result": {
    "alerts": [
      {
        "type": "overspend_warning",
        "title": "You've used 85% of your Food budget",
        "body": "₹7,225 of ₹8,000 spent on food — 18 days left in the month.",
        "emoji": "🍔",
        "urgency": "high",
        "deepLink": "/dashboard/budget/category/food",
        "refType": "budget",
        "refId": "budgetId_abc"
      }
    ]
  },
  "cache_ttl": "event_driven"
}
```

### Flutter Example

```dart
final response = await client.postJson('/api/ai/smart-alerts', {
  'user': {
    'occupationType': 'salaried',
    'incomeRange': '25k-50k',
    'notificationsEnabled': true,
  },
  'currentSummary': {},
  'currentBudget': {},
  'activeGoals': [],
  'recentTransactions': [],
});
```

---

## Recommended Response Parsing in Flutter

Use a typed map or model class for each endpoint.

### Example

```dart
final response = await client.postJson('/api/ai/chat', payload);
final result = response['result'] as Map<String, dynamic>;
final reply = result['reply'] as String? ?? '';
final suggestedActions = (result['suggestedActions'] as List<dynamic>? ?? [])
    .map((item) => item.toString())
    .toList();
```

---

## Validation and Error Handling

### 400 Invalid JSON

Returned when the body cannot be parsed.

### 422 Validation Failed

Returned when required fields are missing or invalid.

Example:

```json
{
  "error": "Validation failed",
  "details": [
    "sessionId: Required",
    "message: String must contain at least 1 character(s)"
  ]
}
```

### 500 AI Processing Failed

Returned when Groq or JSON parsing fails.

Example:

```json
{
  "error": "AI processing failed",
  "message": "Model did not return valid JSON"
}
```

---

## Firestore Write Targets

The backend may persist AI outputs to these collections:

| Endpoint | Firestore Target |
|---|---|
| Expense Insights | `users/{userId}/monthly_summaries/{YYYY-MM}` |
| Generate Budget | `users/{userId}/budgets/{budgetId}` |
| AI Chat | `users/{userId}/ai_chats/{sessionId}` |
| Goal Advice | `users/{userId}/goals/{goalId}` |
| Video Insights | `users/{userId}/video_insights/{insightId}` |
| Scheme Recommend | `users/{userId}/notifications/{notifId}` |
| Predict Expenses | `users/{userId}/monthly_summaries/{nextMonth}` |
| OCR Categorize | `users/{userId}/transactions/{txnId}` |
| Learning Path | `users/{userId}` optional cache |
| Smart Alerts | `users/{userId}/notifications/{notifId}` |

---

## Practical Flutter Flow Example

### Budget Suggestion Screen

```dart
final client = FinWiseApiClient(baseUrl: 'http://localhost:3000');

Future<void> suggestBudget() async {
  final response = await client.postJson('/api/ai/generate-budget', {
    'user': {
      'occupationType': 'salaried',
      'incomeRange': '25k-50k',
      'monthlyIncome': 42000,
      'topGoals': ['emergency_fund'],
      'currentMonthSpent': 31500,
    },
    'monthlySummaries': [],
    'activeGoals': [],
    'lastBudget': null,
  });

  final result = response['result'] as Map<String, dynamic>;
  final totalBudget = result['totalBudget'] as num? ?? 0;
  final categoryLimits = result['categoryLimits'] as Map<String, dynamic>? ?? {};

  // Update UI state here
}
```

---

## Integration Checklist

- Read Firestore data before sending requests
- Remove all PII fields
- Validate payloads before POST
- Parse `result` from success responses
- Handle 400, 422, and 500 responses
- Cache returned values where the guide recommends it
- Persist AI output to Firestore when appropriate
- Use the same payload schema in Flutter and web

---

## Summary

This single file covers the current FinWise AI APIs and is safe to use as a shared integration guide for:

- Next.js web
- Flutter mobile
- Backend-to-frontend contract review

If you want, I can also generate a compact Postman collection JSON or a Flutter API service file next.
