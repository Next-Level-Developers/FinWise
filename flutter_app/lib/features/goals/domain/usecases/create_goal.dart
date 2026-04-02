import '../entities/goal_entity.dart';
import '../repositories/goals_repository.dart';

class CreateGoal {
  const CreateGoal(this._repository);

  final GoalsRepository _repository;

  Future<void> call(GoalEntity goal) => _repository.createGoal(goal);
}
