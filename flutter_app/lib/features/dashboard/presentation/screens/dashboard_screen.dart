import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../../goals/domain/entities/goal_entity.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/greeting_header.dart';
import '../widgets/monthly_spend_card.dart';
import '../widgets/recent_transactions_list.dart';
import '../../../../shared/widgets/finwise_advanced_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DashboardSummary> summary = ref.watch(
      dashboardSummaryProvider,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: summary.when(
          data: (DashboardSummary data) {
            final String spentLabel = _currency.format(data.spent);
            final String budgetLabel = _currency.format(data.budget);

            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.paddingL,
                      AppDimensions.paddingM,
                      AppDimensions.paddingL,
                      0,
                    ),
                    child: GreetingHeader(userName: data.userName),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: MonthlySpendCard(
                      spent: data.spent,
                      budget: data.budget,
                      deltaLabel: data.deltaLabel,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: BudgetProgressRing(
                      spent: data.spent,
                      budget: data.budget,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: _CategoryBreakdownCard(
                      totalSpentLabel: spentLabel,
                      totalBudgetLabel: budgetLabel,
                      breakdown: data.categoryBreakdown,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: DashboardInsightCard(
                      summary:
                          'Food and transport are driving most of this month\'s spend. A small routine change could free up room for your goals without feeling restrictive.',
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: _QuickActionRow(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: _GoalSnapshotCard(goals: data.goals),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: NextMonthForecastCard(
                      predictedSpend: 26900,
                      confidence: 84,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: RecentTransactionsList(
                    transactions: data.recentTransactions,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppDimensions.paddingL,
                      16,
                      AppDimensions.paddingL,
                      0,
                    ),
                    child: DailyTipBanner(
                      tip:
                          'Try setting one weekly spending cap for food delivery. Small rules make budgets easier to keep.',
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Text('Could not load dashboard: $error'),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryBreakdownCard extends StatelessWidget {
  const _CategoryBreakdownCard({
    required this.totalSpentLabel,
    required this.totalBudgetLabel,
    required this.breakdown,
  });

  final String totalSpentLabel;
  final String totalBudgetLabel;
  final Map<String, double> breakdown;

  @override
  Widget build(BuildContext context) {
    const List<Color> palette = <Color>[
      AppColors.accentGold,
      AppColors.accentBlue,
      AppColors.accentPurple,
      AppColors.primary,
      AppColors.accentCoral,
    ];

    final double total = breakdown.values.fold(
      0.0,
      (double a, double b) => a + b,
    );

    final List<_BarData> bars = breakdown.entries.toList().asMap().entries.map((
      MapEntry<int, MapEntry<String, double>> entry,
    ) {
      final int idx = entry.key;
      final String label = entry.value.key;
      final double value = entry.value.value;
      final double ratio = total > 0 ? (value / total).clamp(0.0, 1.0) : 0.0;
      return _BarData(
        label: label,
        value: ratio,
        color: palette[idx % palette.length],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Spending by Category',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$totalSpentLabel spent of $totalBudgetLabel budget',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ...bars.map(
            (_BarData bar) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        bar.label,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      Text(
                        '${(bar.value * 100).round()}%',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: bar.value,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: AlwaysStoppedAnimation<Color>(bar.color),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow();

  @override
  Widget build(BuildContext context) {
    final List<_ActionData> actions = <_ActionData>[
      _ActionData(
        label: 'Add Expense',
        icon: Icons.add,
        color: AppColors.primary,
      ),
      _ActionData(
        label: 'Scan Receipt',
        icon: Icons.photo_camera_outlined,
        color: AppColors.accentGold,
      ),
      _ActionData(
        label: 'AI Chat',
        icon: Icons.auto_awesome,
        color: AppColors.accentPurple,
      ),
      _ActionData(
        label: 'Budget',
        icon: Icons.pie_chart_outline,
        color: AppColors.accentCoral,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Row(
        children: actions
            .map(
              (_ActionData action) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Column(
                    children: <Widget>[
                      Icon(action.icon, color: action.color),
                      const SizedBox(height: 8),
                      Text(
                        action.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _GoalSnapshotCard extends StatelessWidget {
  const _GoalSnapshotCard({required this.goals});

  final List<GoalEntity> goals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Your Goals',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          if (goals.isEmpty)
            const Text(
              'No active goals yet.',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            ...goals.map((GoalEntity goal) {
              final double progress =
                  (goal.target > 0 ? (goal.target / (goal.target + 1)) : 0.0)
                      .clamp(0.0, 1.0);
              return Column(
                children: <Widget>[
                  _GoalRow(
                    emoji: '🎯',
                    title: goal.title,
                    amount: '₹${goal.target.toStringAsFixed(0)}',
                    progress: progress,
                  ),
                  const SizedBox(height: 14),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({
    required this.emoji,
    required this.title,
    required this.amount,
    required this.progress,
  });

  final String emoji;
  final String title;
  final String amount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 2),
                  Text(amount, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0x22F4C96B),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: const Text(
                '24 days left',
                style: TextStyle(
                  color: AppColors.accentGold,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _BarData {
  const _BarData({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;
}

class _ActionData {
  const _ActionData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

final NumberFormat _currency = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);
