class BudgetEntity {
  const BudgetEntity({
    required this.total,
    required this.spent,
    required this.month,
    required this.categoryLimits,
    required this.categorySpent,
    required this.aiInsightSummary,
  });

  final double total;
  final double spent;
  final String month;
  final Map<String, double> categoryLimits;
  final Map<String, double> categorySpent;
  final String aiInsightSummary;
}
