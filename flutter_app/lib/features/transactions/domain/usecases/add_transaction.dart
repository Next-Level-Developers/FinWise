import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  const AddTransaction(this._repository);

  final TransactionRepository _repository;

  Future<void> call(TransactionEntity transaction) {
    return _repository.add(transaction);
  }
}
