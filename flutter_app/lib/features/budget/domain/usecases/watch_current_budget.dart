import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

class WatchCurrentBudget {
  const WatchCurrentBudget(this._repository);

  final BudgetRepository _repository;

  Stream<BudgetEntity?> call({required String month}) {
    return _repository.watchCurrentBudget(month: month);
  }
}
