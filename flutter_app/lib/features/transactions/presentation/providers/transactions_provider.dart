import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/transactions_repository_impl.dart';
import '../../domain/entities/add_money_option.dart';
import '../../domain/repositories/transactions_repository.dart';

final Provider<TransactionsRepository> transactionsRepositoryProvider =
    Provider<TransactionsRepository>((Ref ref) => TransactionsRepositoryImpl());

final FutureProvider<List<AddMoneyOption>> addMoneyOptionsProvider =
    FutureProvider<List<AddMoneyOption>>((Ref ref) {
      return ref.watch(transactionsRepositoryProvider).getAddMoneyOptions();
    });
