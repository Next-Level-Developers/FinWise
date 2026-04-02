import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/transactions_provider.dart';
import '../widgets/add_transaction_fab.dart';
import '../widgets/month_selector.dart';
import '../widgets/transaction_filter_bar.dart';
import '../widgets/transaction_list_item.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  String _selectedCategory = 'all';
  int _selectedType = 0;

  String get _monthKey => DateFormat('yyyy-MM').format(_selectedMonth);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goPrevMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _goNextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  List<TransactionEntity> _applyFilters(List<TransactionEntity> source) {
    final String q = _searchController.text.trim().toLowerCase();
    return source.where((TransactionEntity tx) {
      final bool categoryMatch =
          _selectedCategory == 'all' ||
          tx.category.toLowerCase() == _selectedCategory;

      final bool typeMatch = switch (_selectedType) {
        1 => !tx.isDebit,
        2 => tx.isDebit,
        _ => true,
      };

      final bool searchMatch =
          q.isEmpty ||
          tx.title.toLowerCase().contains(q) ||
          tx.category.toLowerCase().contains(q) ||
          tx.amount.toStringAsFixed(0).contains(q);

      return categoryMatch && typeMatch && searchMatch;
    }).toList();
  }

  List<String> _extractCategories(List<TransactionEntity> txs) {
    final Set<String> categories = <String>{};
    for (final TransactionEntity tx in txs) {
      if (tx.category.trim().isNotEmpty) {
        categories.add(_titleCase(tx.category.trim()));
      }
    }
    final List<String> result = categories.toList()..sort();
    return result;
  }

  String _titleCase(String input) {
    if (input.isEmpty) {
      return input;
    }
    return '${input[0].toUpperCase()}${input.substring(1)}';
  }

  String _emojiForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return '🍔';
      case 'transport':
        return '🚕';
      case 'shopping':
        return '🛍️';
      case 'health':
        return '💊';
      case 'entertainment':
        return '🎬';
      case 'bills':
        return '📄';
      case 'salary':
        return '💼';
      case 'investment':
        return '📈';
      default:
        return '💸';
    }
  }

  String _friendlyError(Object error) {
    final String message = error.toString();
    if (message.contains('failed-precondition') ||
        message.contains('Setting up transactions data')) {
      return 'Setting up transactions data… please wait';
    }
    return 'Unable to load transactions right now.';
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<TransactionEntity>> asyncTx = ref.watch(
      transactionsByMonthProvider(_monthKey),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: <Widget>[
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: AddTransactionFab(
        onPressed: () => context.push(AppRoutes.addTransaction),
      ),
      body: asyncTx.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Text(
                _friendlyError(error),
                style: const TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        data: (List<TransactionEntity> monthTransactions) {
          final List<TransactionEntity> filtered = _applyFilters(
            monthTransactions,
          )..sort((a, b) => b.datetime.compareTo(a.datetime));

          final List<String> categories = _extractCategories(monthTransactions);

          final double totalIncome = monthTransactions
              .where((TransactionEntity tx) => !tx.isDebit)
              .fold(
                0.0,
                (double sum, TransactionEntity tx) => sum + tx.amount.abs(),
              );
          final double totalExpense = monthTransactions
              .where((TransactionEntity tx) => tx.isDebit)
              .fold(
                0.0,
                (double sum, TransactionEntity tx) => sum + tx.amount.abs(),
              );
          final double netBalance = totalIncome - totalExpense;

          final Map<String, List<TransactionEntity>> grouped =
              <String, List<TransactionEntity>>{};
          for (final TransactionEntity tx in filtered) {
            final String dateKey = DateFormat(
              'dd MMM yyyy',
            ).format(tx.datetime);
            grouped.putIfAbsent(dateKey, () => <TransactionEntity>[]).add(tx);
          }

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            children: <Widget>[
              MonthSelector(
                monthLabel: DateFormat('MMMM yyyy').format(_selectedMonth),
                onPrevious: _goPrevMonth,
                onNext: _goNextMonth,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 14),
              TransactionFilterBar(
                categories: categories,
                selectedCategory: _selectedCategory,
                onCategoryChanged: (String value) {
                  setState(() => _selectedCategory = value);
                },
                selectedType: _selectedType,
                onTypeChanged: (int value) {
                  setState(() => _selectedType = value);
                },
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Total In: +₹${totalIncome.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.credit),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total Out: -₹${totalExpense.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.debit),
                        ),
                      ],
                    ),
                    Text(
                      'Net: ₹${netBalance.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: netBalance >= 0
                            ? AppColors.credit
                            : AppColors.debit,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (filtered.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No transactions found.',
                    style: TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...grouped.entries.expand((
                  MapEntry<String, List<TransactionEntity>> e,
                ) {
                  return <Widget>[
                    Text(
                      e.key,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    ...e.value.map((TransactionEntity tx) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TransactionListItem(
                          emoji: _emojiForCategory(tx.category),
                          merchant: tx.title,
                          datetime: DateFormat('hh:mm a').format(tx.datetime),
                          amount:
                              '${tx.isDebit ? '-' : '+'}₹${tx.amount.abs().toStringAsFixed(0)}',
                          isDebit: tx.isDebit,
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                  ];
                }),
              const SizedBox(height: 90),
            ],
          );
        },
      ),
    );
  }
}
