import '../../domain/entities/add_money_option.dart';
import '../../domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  @override
  Future<List<AddMoneyOption>> getAddMoneyOptions() async {
    return const <AddMoneyOption>[
      AddMoneyOption(label: 'Move your direct deposit'),
      AddMoneyOption(label: 'Transfer from other banks'),
      AddMoneyOption(label: 'Apple Pay'),
      AddMoneyOption(label: 'Debit / Credit Card'),
    ];
  }
}
