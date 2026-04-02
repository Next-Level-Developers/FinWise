import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/goals_repository_impl.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goals_repository.dart';
import '../../domain/usecases/add_goal_contribution.dart';
import '../../domain/usecases/create_goal.dart';
import '../../domain/usecases/watch_goal_by_id.dart';
import '../../domain/usecases/watch_goals.dart';

final Provider<GoalsRepository> goalsRepositoryProvider =
    Provider<GoalsRepository>((Ref ref) => GoalsRepositoryImpl());

final Provider<WatchGoals> watchGoalsProvider = Provider<WatchGoals>((Ref ref) {
  return WatchGoals(ref.watch(goalsRepositoryProvider));
});

final Provider<WatchGoalById> watchGoalByIdProvider = Provider<WatchGoalById>((
  Ref ref,
) {
  return WatchGoalById(ref.watch(goalsRepositoryProvider));
});

final Provider<AddGoalContribution> addGoalContributionProvider =
    Provider<AddGoalContribution>((Ref ref) {
      return AddGoalContribution(ref.watch(goalsRepositoryProvider));
    });

final Provider<CreateGoal> createGoalProvider = Provider<CreateGoal>((Ref ref) {
  return CreateGoal(ref.watch(goalsRepositoryProvider));
});

final StreamProvider<List<GoalEntity>> goalsStreamProvider =
    StreamProvider<List<GoalEntity>>((Ref ref) {
      return ref.watch(watchGoalsProvider).call().handleError((Object error) {
        if (error is GoalsRepositoryException) {
          throw Exception(error.message);
        }
        throw error;
      });
    });

final StreamProviderFamily<GoalEntity?, String> goalByIdProvider =
    StreamProvider.family<GoalEntity?, String>((Ref ref, String goalId) {
      return ref.watch(watchGoalByIdProvider).call(goalId).handleError((
        Object error,
      ) {
        if (error is GoalsRepositoryException) {
          throw Exception(error.message);
        }
        throw error;
      });
    });
