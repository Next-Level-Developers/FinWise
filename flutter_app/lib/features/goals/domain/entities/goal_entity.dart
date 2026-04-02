class GoalEntity {
  const GoalEntity({
    required this.title,
    required this.target,
    this.id = '',
    this.emoji = '🎯',
    this.category = 'custom',
    this.currentAmount = 0,
    this.progressPercent = 0,
    this.startDate,
    this.targetDate,
    this.completedDate,
    this.monthlyContribution,
    this.autoDeductFromBudget = false,
    this.status = 'active',
    this.priority = 'medium',
    this.aiSuggestion,
    this.aiSuggestionAt,
    this.milestones = const <GoalMilestone>[],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String emoji;
  final String category;
  final double target;
  final double currentAmount;
  final double progressPercent;
  final DateTime? startDate;
  final DateTime? targetDate;
  final DateTime? completedDate;
  final double? monthlyContribution;
  final bool autoDeductFromBudget;
  final String status;
  final String priority;
  final String? aiSuggestion;
  final DateTime? aiSuggestionAt;
  final List<GoalMilestone> milestones;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  double get progressRatio => (progressPercent / 100).clamp(0, 1);
  double get remainingAmount => (target - currentAmount).clamp(0, target);
}

class GoalMilestone {
  const GoalMilestone({
    required this.percent,
    this.reached = false,
    this.reachedAt,
    this.celebrated = false,
  });

  final int percent;
  final bool reached;
  final DateTime? reachedAt;
  final bool celebrated;
}
