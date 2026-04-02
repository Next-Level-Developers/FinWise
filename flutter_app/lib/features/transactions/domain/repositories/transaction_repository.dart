import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Stream<List<TransactionEntity>> watchByMonth(String month);
  Future<void> add(TransactionEntity transaction);
}
