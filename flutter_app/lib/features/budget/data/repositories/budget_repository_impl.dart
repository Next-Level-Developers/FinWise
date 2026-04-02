import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  @override
  Future<BudgetEntity> getCurrentBudget() async =>
      const BudgetEntity(total: 0, spent: 0);
}
