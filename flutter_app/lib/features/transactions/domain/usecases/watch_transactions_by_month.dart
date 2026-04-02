import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class WatchTransactionsByMonth {
  const WatchTransactionsByMonth(this._repository);

  final TransactionRepository _repository;

  Stream<List<TransactionEntity>> call(String month) {
    return _repository.watchByMonth(month);
  }
}
