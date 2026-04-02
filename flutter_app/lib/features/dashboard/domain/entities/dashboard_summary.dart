import '../../../goals/domain/entities/goal_entity.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.userName,
    required this.spent,
    required this.budget,
    required this.deltaLabel,
    required this.categoryBreakdown,
    required this.goals,
    required this.recentTransactions,
  });

  final String userName;
  final double spent;
  final double budget;
  final String deltaLabel;
  final Map<String, double> categoryBreakdown;
  final List<GoalEntity> goals;
  final List<TransactionEntity> recentTransactions;
}
