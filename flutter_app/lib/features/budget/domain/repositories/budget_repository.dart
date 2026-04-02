import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<BudgetEntity> getCurrentBudget();
}
