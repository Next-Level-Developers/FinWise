import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goals_repository.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  @override
  Future<List<GoalEntity>> watchAll() async => const <GoalEntity>[];
}
