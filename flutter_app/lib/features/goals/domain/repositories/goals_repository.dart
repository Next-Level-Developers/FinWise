import '../entities/goal_entity.dart';

abstract class GoalsRepository {
  Future<List<GoalEntity>> watchAll();
}
