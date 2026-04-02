import '../entities/budget_entity.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

abstract class BudgetRepository {
  Stream<BudgetEntity?> watchCurrentBudget({required String month});
  Stream<List<TransactionEntity>> watchCategoryTransactions({
    required String month,
    required String category,
  });
}
