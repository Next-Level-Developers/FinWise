import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/greeting_header.dart';
import '../widgets/monthly_spend_card.dart';
import '../widgets/recent_transactions_list.dart';

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
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: _CategoryBreakdownCard(
                      totalSpentLabel: spentLabel,
                      totalBudgetLabel: budgetLabel,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: _AiInsightCard(),
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
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: _GoalSnapshotCard(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: _ForecastCard(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(child: RecentTransactionsList()),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppDimensions.paddingL,
                      16,
                      AppDimensions.paddingL,
                      0,
                    ),
                    child: _DailyTipBanner(),
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
  });

  final String totalSpentLabel;
  final String totalBudgetLabel;

  @override
  Widget build(BuildContext context) {
    const List<_BarData> bars = <_BarData>[
      _BarData(label: 'Food', value: 0.85, color: AppColors.accentGold),
      _BarData(label: 'Transport', value: 0.45, color: AppColors.accentBlue),
      _BarData(label: 'Shopping', value: 0.65, color: AppColors.accentPurple),
      _BarData(label: 'Health', value: 0.30, color: AppColors.primary),
    ];

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

class _AiInsightCard extends StatefulWidget {
  const _AiInsightCard();

  @override
  State<_AiInsightCard> createState() => _AiInsightCardState();
}

class _AiInsightCardState extends State<_AiInsightCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: const Color(0x261A1433),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.auto_awesome, color: AppColors.accentPurple),
              const SizedBox(width: 8),
              const Text(
                'AI Insight',
                style: TextStyle(
                  color: AppColors.accentPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            _expanded
                ? 'Your food and transport categories are carrying most of the month’s spend. Shift one weekly dine-out into a home meal and you will free up room for goals without hurting your routine.'
                : 'Food and transport are driving most of this month’s spend. A small routine change could free up room for your goals.',
            style: const TextStyle(color: AppColors.textPrimary, height: 1.45),
          ),
          const SizedBox(height: 10),
          const Text(
            'See Full Analysis →',
            style: TextStyle(
              color: AppColors.accentPurple,
              fontWeight: FontWeight.w600,
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
  const _GoalSnapshotCard();

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
        children: const <Widget>[
          Text(
            'Your Goals',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14),
          _GoalRow(
            emoji: '🎯',
            title: 'Emergency Fund',
            amount: '₹42,000 of ₹1,00,000',
            progress: 0.42,
          ),
          SizedBox(height: 14),
          _GoalRow(
            emoji: '🏠',
            title: 'Home Down Payment',
            amount: '₹2,40,000 of ₹10,00,000',
            progress: 0.24,
          ),
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

class _ForecastCard extends StatelessWidget {
  const _ForecastCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x22F4C96B),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: const Icon(Icons.trending_up, color: AppColors.accentGold),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Next Month Forecast',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Predicted spend: ₹26,900',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Text(
            '84%',
            style: TextStyle(
              color: AppColors.accentGold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyTipBanner extends StatelessWidget {
  const _DailyTipBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: const Border(
          left: BorderSide(color: AppColors.primary, width: 4),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tip of the day',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          SizedBox(height: 6),
          Text(
            'Try setting one weekly spending cap for food delivery. Small rules make budgets easier to keep.',
            style: TextStyle(color: AppColors.textPrimary, height: 1.4),
          ),
        ],
      ),
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
