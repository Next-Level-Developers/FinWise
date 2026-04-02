import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/budget_repository_impl.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/usecases/watch_category_transactions.dart';
import '../../domain/usecases/watch_current_budget.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

final Provider<BudgetRepository> budgetRepositoryProvider =
    Provider<BudgetRepository>((Ref ref) => BudgetRepositoryImpl());

final Provider<WatchCurrentBudget> watchCurrentBudgetProvider =
    Provider<WatchCurrentBudget>((Ref ref) {
      return WatchCurrentBudget(ref.watch(budgetRepositoryProvider));
    });

final Provider<WatchCategoryTransactions> watchCategoryTransactionsProvider =
    Provider<WatchCategoryTransactions>((Ref ref) {
      return WatchCategoryTransactions(ref.watch(budgetRepositoryProvider));
    });

final StreamProviderFamily<BudgetEntity?, String> currentBudgetProvider =
    StreamProvider.family<BudgetEntity?, String>((Ref ref, String month) {
      return ref
          .watch(watchCurrentBudgetProvider)
          .call(month: month)
          .handleError((Object error) {
            if (error is BudgetRepositoryException) {
              throw Exception(error.message);
            }
            throw error;
          });
    });

final StreamProviderFamily<
  List<TransactionEntity>,
  ({String month, String category})
>
categoryTransactionsProvider =
    StreamProvider.family<
      List<TransactionEntity>,
      ({String month, String category})
    >((Ref ref, ({String month, String category}) params) {
      return ref
          .watch(watchCategoryTransactionsProvider)
          .call(month: params.month, category: params.category)
          .handleError((Object error) {
            if (error is BudgetRepositoryException) {
              throw Exception(error.message);
            }
            throw error;
          });
    });
