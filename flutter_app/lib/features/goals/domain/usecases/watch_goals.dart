import '../entities/goal_entity.dart';
import '../repositories/goals_repository.dart';

class WatchGoals {
  const WatchGoals(this._repository);

  final GoalsRepository _repository;

  Stream<List<GoalEntity>> call() => _repository.watchAll();
}
