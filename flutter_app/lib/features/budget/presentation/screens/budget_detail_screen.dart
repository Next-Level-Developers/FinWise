import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/budget_entity.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../providers/budget_provider.dart';

class BudgetDetailScreen extends ConsumerWidget {
  const BudgetDetailScreen({super.key, this.category = 'food'});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String month = DateFormat('yyyy-MM').format(DateTime.now());
    final AsyncValue<BudgetEntity?> budget = ref.watch(
      currentBudgetProvider(month),
    );
    final AsyncValue<List<TransactionEntity>> tx = ref.watch(
      categoryTransactionsProvider((month: month, category: category)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${_titleCase(category)} Budget'),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
        ],
      ),
      body: budget.when(
        data: (BudgetEntity? budgetData) {
          final double limit = budgetData == null
              ? 0
              : (budgetData.categoryLimits[category] ?? 0);
          final double spent = budgetData == null
              ? 0
              : (budgetData.categorySpent[category] ?? 0);
          final double remaining = (limit - spent).clamp(0, double.infinity);
          final double ratio = limit > 0
              ? (spent / limit).clamp(0.0, 1.0)
              : 0.0;

          return tx.when(
            data: (List<TransactionEntity> transactions) {
              return ListView(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '₹${spent.toStringAsFixed(0)} spent',
                          style: AppTextStyles.amountDisplay,
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(99),
                          ),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 10,
                            backgroundColor: AppColors.surfaceElevated,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.accentGold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${remaining.toStringAsFixed(0)} remaining',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recent ${_titleCase(category)} transactions',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  if (transactions.isEmpty)
                    const Text(
                      'No transactions for this category yet.',
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                  else
                    ...transactions.take(10).map((TransactionEntity item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(AppDimensions.paddingM),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusL,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const CircleAvatar(
                              backgroundColor: AppColors.surfaceElevated,
                              child: Text('💸'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.title,
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat(
                                      'd MMM • hh:mm a',
                                    ).format(item.datetime),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${item.isDebit ? '-' : '+'}₹${item.amount.abs().toStringAsFixed(0)}',
                              style: TextStyle(
                                color: item.isDebit
                                    ? AppColors.debit
                                    : AppColors.credit,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, StackTrace stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Text(_friendlyError(error)),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Text(_friendlyError(error)),
          ),
        ),
      ),
    );
  }

  String _friendlyError(Object error) {
    final String message = error.toString();
    if (message.contains('failed-precondition') ||
        message.contains('Setting up budget data')) {
      return 'Setting up budget data... please wait';
    }
    return 'Could not load budget details right now.';
  }

  static String _titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }
}
