import '../entities/goal_entity.dart';
import '../repositories/goals_repository.dart';

class WatchGoalById {
  const WatchGoalById(this._repository);

  final GoalsRepository _repository;

  Stream<GoalEntity?> call(String goalId) => _repository.watchGoalById(goalId);
}
