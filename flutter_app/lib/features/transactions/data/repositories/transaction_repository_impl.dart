import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  @override
  Future<void> add(TransactionEntity transaction) async {}

  @override
  Stream<List<TransactionEntity>> watchByMonth(String month) async* {
    yield const <TransactionEntity>[];
  }
}
