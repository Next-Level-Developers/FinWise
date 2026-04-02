import '../repositories/goals_repository.dart';

class AddGoalContribution {
  const AddGoalContribution(this._repository);

  final GoalsRepository _repository;

  Future<void> call({required String goalId, required double amount}) {
    return _repository.addContribution(goalId: goalId, amount: amount);
  }
}
