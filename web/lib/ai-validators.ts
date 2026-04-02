import { z } from "zod";

type ValidationSuccess<T> = { valid: true; data: T };
type ValidationFailure = { valid: false; errors: string[] };

type ValidationResult<T> = ValidationSuccess<T> | ValidationFailure;

function toValidationResult<T>(schema: z.ZodType<T>, body: unknown): ValidationResult<T> {
  const parsed = schema.safeParse(body);
  if (parsed.success) {
    return { valid: true, data: parsed.data };
  }

  return {
    valid: false,
    errors: parsed.error.issues.map((issue) => `${issue.path.join(".") || "root"}: ${issue.message}`),
  };
}

const safeNumber = z.number().finite();
const nonNegativeNumber = safeNumber.nonnegative();
const categoryBreakdownSchema = z.record(z.string(), nonNegativeNumber);

const userContextSchema = z.object({
  occupationType: z.string().optional(),
  incomeRange: z.string().optional(),
  monthlyIncome: nonNegativeNumber.optional(),
  currentMonthBudget: nonNegativeNumber.optional(),
  currentMonthSpent: nonNegativeNumber.optional(),
  topGoals: z.array(z.string()).optional(),
  preferredLanguage: z.string().optional(),
  eligibilityTags: z.array(z.string()).optional(),
});

const monthlySummarySchema = z.object({
  month: z.string().optional(),
  totalIncome: nonNegativeNumber.optional(),
  totalExpense: nonNegativeNumber.optional(),
  totalSavings: safeNumber.optional(),
  savingsRate: safeNumber.optional(),
  categoryBreakdown: categoryBreakdownSchema.optional(),
  budgetAmount: nonNegativeNumber.optional(),
  budgetVariance: safeNumber.optional(),
  txnCount: nonNegativeNumber.optional(),
});

export const expenseInsightsInputSchema = z.object({
  user: userContextSchema,
  monthlySummary: monthlySummarySchema,
  recentTransactions: z.array(
    z.object({
      type: z.string(),
      amount: nonNegativeNumber,
      category: z.string().optional(),
      subCategory: z.string().optional(),
      tags: z.array(z.string()).optional(),
      paymentMethod: z.string().optional(),
      date: z.string().optional(),
      isRecurring: z.boolean().optional(),
      source: z.string().optional(),
    }),
  ).default([]),
});

export const generateBudgetInputSchema = z.object({
  user: userContextSchema,
  monthlySummaries: z.array(monthlySummarySchema).default([]),
  activeGoals: z.array(
    z.object({
      category: z.string(),
      targetAmount: nonNegativeNumber,
      currentAmount: nonNegativeNumber.optional(),
      targetDate: z.string().optional(),
      monthlyContribution: nonNegativeNumber.optional(),
      priority: z.string().optional(),
    }),
  ).default([]),
  lastBudget: z.object({
    totalBudget: nonNegativeNumber.optional(),
    categoryLimits: categoryBreakdownSchema.optional(),
    budgetVariance: safeNumber.optional(),
  }).optional(),
});

export const chatInputSchema = z.object({
  sessionId: z.string().min(1),
  mode: z.string().optional(),
  message: z.string().min(1),
  userContext: userContextSchema,
  financialSnapshot: z.object({
    totalExpense: nonNegativeNumber.optional(),
    totalIncome: nonNegativeNumber.optional(),
    totalSavings: safeNumber.optional(),
    savingsRate: safeNumber.optional(),
    categoryBreakdown: categoryBreakdownSchema.optional(),
  }).optional(),
  activeGoals: z.array(
    z.object({
      category: z.string(),
      targetAmount: nonNegativeNumber,
      currentAmount: nonNegativeNumber.optional(),
      targetDate: z.string().optional(),
      status: z.string().optional(),
    }),
  ).optional(),
  currentBudget: z.object({
    totalBudget: nonNegativeNumber.optional(),
    categoryLimits: categoryBreakdownSchema.optional(),
  }).optional(),
  recentMessages: z.array(
    z.object({
      role: z.enum(["user", "assistant", "system"]),
      content: z.string(),
      createdAt: z.string().optional(),
    }),
  ).default([]),
});

export const goalAdviceInputSchema = z.object({
  user: userContextSchema,
  goal: z.object({
    category: z.string(),
    targetAmount: nonNegativeNumber,
    currentAmount: nonNegativeNumber,
    progressPercent: nonNegativeNumber.optional(),
    startDate: z.string().optional(),
    targetDate: z.string().optional(),
    monthlyContribution: nonNegativeNumber.optional(),
    status: z.string().optional(),
    priority: z.string().optional(),
  }),
  recentSummaries: z.array(monthlySummarySchema).default([]),
  currentBudget: z.object({
    totalBudget: nonNegativeNumber.optional(),
    categoryLimits: categoryBreakdownSchema.optional(),
  }).optional(),
});

export const videoInsightsInputSchema = z.object({
  videoId: z.string().optional(),
  videoTitle: z.string().min(1),
  transcript: z.string().min(1),
  userContext: userContextSchema,
});

export const schemeRecommendInputSchema = z.object({
  user: userContextSchema,
  schemes: z.array(
    z.object({
      schemeId: z.string().optional(),
      name: z.string(),
      fullName: z.string().optional(),
      eligibilityTags: z.array(z.string()).optional(),
      targetOccupation: z.string().optional(),
      incomeRangeMin: safeNumber.optional(),
      incomeRangeMax: safeNumber.optional(),
      benefitType: z.string().optional(),
      maxBenefit: safeNumber.optional(),
      tagline: z.string().optional(),
      applicationMode: z.string().optional(),
      description: z.string().optional(),
    }),
  ).min(1),
});

export const predictExpensesInputSchema = z.object({
  user: userContextSchema,
  monthlySummaries: z.array(monthlySummarySchema).min(1),
  recurringTransactions: z.array(
    z.object({
      amount: nonNegativeNumber,
      category: z.string().optional(),
      paymentMethod: z.string().optional(),
    }),
  ).default([]),
  nextMonthBudget: z.object({
    totalBudget: nonNegativeNumber.optional(),
    categoryLimits: categoryBreakdownSchema.optional(),
  }).optional(),
});

export const ocrCategorizeInputSchema = z.object({
  ocrRawText: z.string().min(1),
  userContext: z.object({
    preferredLanguage: z.string().optional(),
    occupationType: z.string().optional(),
  }).optional(),
});

export const learningPathInputSchema = z.object({
  user: userContextSchema,
  learningProgress: z.array(
    z.object({
      moduleId: z.string(),
      status: z.string(),
      progressPercent: nonNegativeNumber.optional(),
      bestQuizScore: nonNegativeNumber.optional(),
      quizPassed: z.boolean().optional(),
    }),
  ).default([]),
  badges: z.array(
    z.object({
      badgeId: z.string(),
      category: z.string().optional(),
    }),
  ).default([]),
  learningModules: z.array(
    z.object({
      id: z.string(),
      title: z.string(),
      targetOccupation: z.string().optional(),
      targetIncomeRange: z.string().optional(),
      difficulty: z.string().optional(),
      tags: z.array(z.string()).optional(),
      category: z.string().optional(),
      estimatedMins: nonNegativeNumber.optional(),
      hasQuiz: z.boolean().optional(),
    }),
  ).min(1),
});

export const smartAlertsInputSchema = z.object({
  user: z.object({
    occupationType: z.string().optional(),
    incomeRange: z.string().optional(),
    notificationsEnabled: z.boolean().optional(),
  }),
  currentSummary: z.object({
    totalExpense: nonNegativeNumber.optional(),
    budgetAmount: nonNegativeNumber.optional(),
    categoryBreakdown: categoryBreakdownSchema.optional(),
    budgetVariance: safeNumber.optional(),
  }).optional(),
  currentBudget: z.object({
    categoryLimits: categoryBreakdownSchema.optional(),
    alertThreshold: z.number().min(0).max(1).optional(),
  }).optional(),
  activeGoals: z.array(
    z.object({
      targetAmount: nonNegativeNumber,
      currentAmount: nonNegativeNumber,
      targetDate: z.string().optional(),
      monthlyContribution: nonNegativeNumber.optional(),
    }),
  ).default([]),
  recentTransactions: z.array(
    z.object({
      amount: nonNegativeNumber,
      category: z.string().optional(),
      date: z.string().optional(),
      isRecurring: z.boolean().optional(),
    }),
  ).default([]),
});

export function validateExpenseInsightsInput(body: unknown) {
  return toValidationResult(expenseInsightsInputSchema, body);
}

export function validateGenerateBudgetInput(body: unknown) {
  return toValidationResult(generateBudgetInputSchema, body);
}

export function validateChatInput(body: unknown) {
  return toValidationResult(chatInputSchema, body);
}

export function validateGoalAdviceInput(body: unknown) {
  return toValidationResult(goalAdviceInputSchema, body);
}

export function validateVideoInsightsInput(body: unknown) {
  return toValidationResult(videoInsightsInputSchema, body);
}

export function validateSchemeRecommendInput(body: unknown) {
  return toValidationResult(schemeRecommendInputSchema, body);
}

export function validatePredictExpensesInput(body: unknown) {
  return toValidationResult(predictExpensesInputSchema, body);
}

export function validateOcrCategorizeInput(body: unknown) {
  return toValidationResult(ocrCategorizeInputSchema, body);
}

export function validateLearningPathInput(body: unknown) {
  return toValidationResult(learningPathInputSchema, body);
}

export function validateSmartAlertsInput(body: unknown) {
  return toValidationResult(smartAlertsInputSchema, body);
}
