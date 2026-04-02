import '../entities/goal_entity.dart';

abstract class GoalsRepository {
  Stream<List<GoalEntity>> watchAll();
  Stream<GoalEntity?> watchGoalById(String goalId);
  Future<void> addContribution({
    required String goalId,
    required double amount,
  });
  Future<void> createGoal(GoalEntity goal);
}
