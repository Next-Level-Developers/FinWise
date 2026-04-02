import '../../../transactions/domain/entities/transaction_entity.dart';
import '../repositories/budget_repository.dart';

class WatchCategoryTransactions {
  const WatchCategoryTransactions(this._repository);

  final BudgetRepository _repository;

  Stream<List<TransactionEntity>> call({
    required String month,
    required String category,
  }) {
    return _repository.watchCategoryTransactions(
      month: month,
      category: category,
    );
  }
}
