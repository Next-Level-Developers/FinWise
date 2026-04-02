import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/finwise_advanced_widgets.dart';
import '../../domain/entities/budget_entity.dart';
import '../providers/budget_provider.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  bool _loading = false;
  int? _expandedIndex;
  final DateTime _currentMonth = DateTime.now();

  String get _monthKey => DateFormat('yyyy-MM').format(_currentMonth);

  @override
  Widget build(BuildContext context) {
    final AsyncValue<BudgetEntity?> budget = ref.watch(
      currentBudgetProvider(_monthKey),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Budget'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                DateFormat('MMMM yyyy').format(_currentMonth),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      body: budget.when(
        data: (BudgetEntity? data) {
          if (data == null) {
            return const Center(
              child: Text(
                'No budget found for this month.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final List<String> categories = data.categoryLimits.keys.toList();
          const List<Color> colors = <Color>[
            AppColors.accentGold,
            AppColors.accentBlue,
            AppColors.accentCoral,
            AppColors.primary,
            AppColors.warning,
            AppColors.accentPurple,
            AppColors.accentBlue,
            AppColors.primary,
          ];

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            children: <Widget>[
              BudgetProgressRing(spent: data.spent, budget: data.total),
              const SizedBox(height: 16),
              AiBudgetButton(
                isLoading: _loading,
                onPressed: () => setState(() => _loading = true),
              ),
              const SizedBox(height: 16),
              if (categories.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'No category budgets available.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                ...List<Widget>.generate(categories.length, (int i) {
                  final String category = categories[i];
                  final double limit = data.categoryLimits[category] ?? 0;
                  final double spent = data.categorySpent[category] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CategoryBudgetBar(
                      category: category,
                      spent: spent,
                      limit: limit,
                      color: colors[i % colors.length],
                      expanded: _expandedIndex == i,
                      onTap: () => setState(
                        () => _expandedIndex = _expandedIndex == i ? null : i,
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 8),
              BudgetReasoningTile(reasoning: data.aiInsightSummary),
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
      ),
    );
  }

  String _friendlyError(Object error) {
    final String message = error.toString();
    if (message.contains('failed-precondition') ||
        message.contains('Setting up budget data')) {
      return 'Setting up budget data... please wait';
    }
    return 'Could not load budget right now.';
  }
}
