import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/transactions_repository_impl.dart';
import '../../domain/entities/add_money_option.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/watch_transactions_by_month.dart';

final Provider<TransactionsRepository> transactionsRepositoryProvider =
    Provider<TransactionsRepository>((Ref ref) => TransactionsRepositoryImpl());

final Provider<TransactionRepository> transactionRepositoryProvider =
    Provider<TransactionRepository>((Ref ref) => TransactionRepositoryImpl());

final Provider<WatchTransactionsByMonth> watchTransactionsByMonthProvider =
    Provider<WatchTransactionsByMonth>((Ref ref) {
      return WatchTransactionsByMonth(ref.watch(transactionRepositoryProvider));
    });

final Provider<AddTransaction> addTransactionUseCaseProvider =
    Provider<AddTransaction>((Ref ref) {
      return AddTransaction(ref.watch(transactionRepositoryProvider));
    });

final StreamProviderFamily<List<TransactionEntity>, String>
transactionsByMonthProvider =
    StreamProvider.family<List<TransactionEntity>, String>((
      Ref ref,
      String month,
    ) {
      return ref
          .watch(watchTransactionsByMonthProvider)
          .call(month)
          .handleError((Object error) {
            if (error is TransactionRepositoryException) {
              throw Exception(error.message);
            }
            throw error;
          });
    });

final FutureProvider<List<AddMoneyOption>> addMoneyOptionsProvider =
    FutureProvider<List<AddMoneyOption>>((Ref ref) {
      return ref.watch(transactionsRepositoryProvider).getAddMoneyOptions();
    });
