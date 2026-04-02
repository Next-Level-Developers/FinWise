import '../entities/add_money_option.dart';

abstract class TransactionsRepository {
  Future<List<AddMoneyOption>> getAddMoneyOptions();
}
