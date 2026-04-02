import '../../domain/entities/add_money_option.dart';
import '../../domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  @override
  Future<List<AddMoneyOption>> getAddMoneyOptions() async {
    return const <AddMoneyOption>[];
  }
}
