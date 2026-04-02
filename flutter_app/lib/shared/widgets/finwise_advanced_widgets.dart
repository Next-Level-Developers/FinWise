import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

class FinwiseCard extends StatelessWidget {
  const FinwiseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.paddingL),
    this.gradient,
    this.border,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final BoxBorder? border;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? AppColors.surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: border,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class BudgetProgressRing extends StatelessWidget {
  const BudgetProgressRing({
    super.key,
    required this.spent,
    required this.budget,
  });

  final double spent;
  final double budget;

  @override
  Widget build(BuildContext context) {
    final double ratio = budget <= 0 ? 0 : (spent / budget).clamp(0, 1);
    final String remainingLabel = _currency.format(
      (budget - spent).clamp(0, budget),
    );

    return FinwiseCard(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: 118,
                width: 118,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 12,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.surfaceElevated,
                  ),
                ),
              ),
              SizedBox(
                height: 118,
                width: 118,
                child: CircularProgressIndicator(
                  value: ratio,
                  strokeWidth: 12,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${(ratio * 100).round()}%',
                    style: AppTextStyles.amountDisplay.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 2),
                  const Text('used', style: AppTextStyles.labelSmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$remainingLabel remaining',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${_currency.format(spent)} spent of ${_currency.format(budget)} budget',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class NextMonthForecastCard extends StatelessWidget {
  const NextMonthForecastCard({
    super.key,
    required this.predictedSpend,
    required this.confidence,
  });

  final double predictedSpend;
  final int confidence;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      gradient: const LinearGradient(
        colors: <Color>[Color(0x261A1433), AppColors.surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: AppColors.border),
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: AppColors.accentGold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.accentPurple,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Next Month Forecast',
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Predicted spend: ${_currency.format(predictedSpend)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _Pill(label: '$confidence%', color: AppColors.accentGold),
        ],
      ),
    );
  }
}

class DailyTipBanner extends StatelessWidget {
  const DailyTipBanner({super.key, required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      border: const Border(
        left: BorderSide(color: AppColors.primary, width: 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Tip of the day', style: AppTextStyles.labelSmall),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  tip,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardInsightCard extends StatefulWidget {
  const DashboardInsightCard({super.key, required this.summary});

  final String summary;

  @override
  State<DashboardInsightCard> createState() => _DashboardInsightCardState();
}

class _DashboardInsightCardState extends State<DashboardInsightCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      gradient: const LinearGradient(
        colors: <Color>[Color(0x261A1433), AppColors.surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: AppColors.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.auto_awesome, color: AppColors.accentPurple),
              const SizedBox(width: 8),
              Text(
                'AI Insight',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.accentPurple,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                icon: Icon(
                  _expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            _expanded ? widget.summary : _truncate(widget.summary, 96),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _expanded ? 'Collapse' : 'See Full Analysis →',
            style: const TextStyle(
              color: AppColors.accentPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class MonthlySummaryStrip extends StatelessWidget {
  const MonthlySummaryStrip({
    super.key,
    required this.totalIn,
    required this.totalOut,
  });

  final double totalIn;
  final double totalOut;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingM,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SummaryValue(
              label: 'Total In',
              value: _currency.format(totalIn),
              color: AppColors.credit,
            ),
          ),
          Container(width: 1, height: 44, color: AppColors.divider),
          Expanded(
            child: _SummaryValue(
              label: 'Total Out',
              value: _currency.format(totalOut),
              color: AppColors.debit,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableTransactionFab extends StatefulWidget {
  const ExpandableTransactionFab({
    super.key,
    required this.onManual,
    required this.onScan,
  });

  final VoidCallback onManual;
  final VoidCallback onScan;

  @override
  State<ExpandableTransactionFab> createState() =>
      _ExpandableTransactionFabState();
}

class _ExpandableTransactionFabState extends State<ExpandableTransactionFab> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (_expanded) ...<Widget>[
            _MiniAction(
              onTap: widget.onManual,
              icon: Icons.edit_note_rounded,
              label: 'Manual',
            ),
            const SizedBox(height: 10),
            _MiniAction(
              onTap: widget.onScan,
              icon: Icons.document_scanner_rounded,
              label: 'Scan',
            ),
            const SizedBox(height: 12),
          ],
          FloatingActionButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            child: Icon(_expanded ? Icons.close_rounded : Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class OcrScanOverlay extends StatelessWidget {
  const OcrScanOverlay({super.key, required this.instruction});

  final String instruction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.32)),
              ),
              Center(
                child: Container(
                  width: 280,
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      _CornerGuide(top: 0, left: 0, alignTopLeft: true),
                      _CornerGuide(top: 0, right: 0, alignTopLeft: false),
                      _CornerGuide(
                        bottom: 0,
                        left: 0,
                        alignTopLeft: false,
                        alignBottomLeft: true,
                      ),
                      _CornerGuide(
                        bottom: 0,
                        right: 0,
                        alignTopLeft: false,
                        alignBottomRight: true,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 28,
                child: Column(
                  children: <Widget>[
                    Text(
                      instruction,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The scan zone will auto-capture totals and merchant data.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OcrResultPreviewCard extends StatelessWidget {
  const OcrResultPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: const <Widget>[
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.credit,
                size: 20,
              ),
              SizedBox(width: 8),
              Text('Extracted Info', style: AppTextStyles.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          const _InlineEditField(label: 'Amount', value: '₹280'),
          const SizedBox(height: 10),
          const _InlineEditField(label: 'Merchant', value: 'Cafe Bistro'),
          const SizedBox(height: 10),
          const _InlineEditField(label: 'Date', value: 'Today'),
          const SizedBox(height: 10),
          const _InlineEditField(label: 'Category', value: 'Food'),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                  child: const Text('Confirm & Save'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                ),
                child: const Text('Retake'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BudgetVarianceChip extends StatelessWidget {
  const BudgetVarianceChip({
    super.key,
    required this.isUnderBudget,
    this.label,
  });

  final bool isUnderBudget;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final Color color = isUnderBudget ? AppColors.credit : AppColors.debit;
    final String resolvedLabel =
        label ?? (isUnderBudget ? 'Under Budget ✓' : 'Over Budget ✗');

    return _Pill(
      label: resolvedLabel,
      color: color,
      background: color.withValues(alpha: 0.16),
    );
  }
}

class AiBudgetButton extends StatelessWidget {
  const AiBudgetButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      gradient: const LinearGradient(
        colors: <Color>[Color(0x261A1433), AppColors.surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: AppColors.border),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: Row(
          children: <Widget>[
            const Icon(Icons.auto_awesome, color: AppColors.accentPurple),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isLoading ? 'Analyzing your spending...' : 'Generate AI Budget',
                style: AppTextStyles.titleLarge.copyWith(fontSize: 16),
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accentPurple,
                ),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

class CategoryBudgetBar extends StatelessWidget {
  const CategoryBudgetBar({
    super.key,
    required this.category,
    required this.spent,
    required this.limit,
    required this.color,
    this.expanded = false,
    this.onTap,
  });

  final String category;
  final double spent;
  final double limit;
  final Color color;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double ratio = limit <= 0 ? 0 : (spent / limit).clamp(0, 1.25);
    final bool isOver = spent > limit;
    final Color fillColor = isOver
        ? AppColors.debit
        : ratio > 0.8
        ? AppColors.accentGold
        : AppColors.credit;

    return FinwiseCard(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color.withValues(alpha: 0.16),
                  child: Text(
                    category.characters.first,
                    style: TextStyle(color: color, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(category, style: AppTextStyles.bodyLarge)),
                BudgetVarianceChip(isUnderBudget: !isOver),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: ratio.clamp(0, 1),
                backgroundColor: AppColors.surfaceElevated,
                valueColor: AlwaysStoppedAnimation<Color>(fillColor),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${_currency.format(spent)} / ${_currency.format(limit)}',
                  style: AppTextStyles.bodySmall,
                ),
                if (expanded)
                  _InlineEditor(limit: limit)
                else
                  const Icon(
                    Icons.edit_rounded,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
              ],
            ),
            if (expanded) ...<Widget>[
              const SizedBox(height: 10),
              const _InlineEditField(
                label: 'Override limit',
                value: '₹${1500}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BudgetReasoningTile extends StatefulWidget {
  const BudgetReasoningTile({super.key, required this.reasoning});

  final String reasoning;

  @override
  State<BudgetReasoningTile> createState() => _BudgetReasoningTileState();
}

class _BudgetReasoningTileState extends State<BudgetReasoningTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      gradient: const LinearGradient(
        colors: <Color>[Color(0x261A1433), AppColors.surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: AppColors.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: <Widget>[
                const Icon(Icons.auto_awesome, color: AppColors.accentPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI Reasoning ✨',
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 16),
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          if (_expanded) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              widget.reasoning,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class GoalProgressArc extends StatelessWidget {
  const GoalProgressArc({
    super.key,
    required this.progress,
    required this.emoji,
    required this.label,
  });

  final double progress;
  final String emoji;
  final String label;

  @override
  Widget build(BuildContext context) {
    final double ratio = progress.clamp(0, 1);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          height: 152,
          width: 152,
          child: CircularProgressIndicator(
            value: 1,
            strokeWidth: 14,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.surfaceElevated,
            ),
          ),
        ),
        SizedBox(
          height: 152,
          width: 152,
          child: CircularProgressIndicator(
            value: ratio,
            strokeWidth: 14,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 6),
            Text(
              '${(ratio * 100).round()}%',
              style: AppTextStyles.amountDisplay.copyWith(fontSize: 30),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.labelSmall),
          ],
        ),
      ],
    );
  }
}

class MilestoneTimeline extends StatelessWidget {
  const MilestoneTimeline({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    const List<int> steps = <int>[25, 50, 75, 100];
    return Column(
      children: steps.map((int step) {
        final bool completed = progress * 100 >= step;
        final bool current = !completed && progress * 100 + 25 >= step;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: completed
                          ? AppColors.primary
                          : current
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.surfaceElevated,
                      border: Border.all(
                        color: completed || current
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: completed
                        ? const Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: AppColors.onPrimary,
                          )
                        : null,
                  ),
                  if (step != 100)
                    Container(width: 2, height: 28, color: AppColors.divider),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$step% milestone',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: completed
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class AiGoalAdviceCard extends StatelessWidget {
  const AiGoalAdviceCard({
    super.key,
    required this.advice,
    required this.onRefresh,
  });

  final String advice;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      gradient: const LinearGradient(
        colors: <Color>[Color(0x261A1433), AppColors.surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: AppColors.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.auto_awesome, color: AppColors.accentPurple),
              const SizedBox(width: 8),
              Text(
                'AI Advice',
                style: AppTextStyles.titleLarge.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            advice,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onRefresh,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accentPurple,
              side: const BorderSide(color: AppColors.accentPurple),
            ),
            child: const Text('Refresh Advice'),
          ),
        ],
      ),
    );
  }
}

class ContributionBottomSheet extends StatelessWidget {
  const ContributionBottomSheet({super.key, required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingL,
        right: AppDimensions.paddingL,
        top: AppDimensions.paddingL,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Center(
            child: SizedBox(
              width: 44,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Add Contribution',
            style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          const _InlineEditField(label: 'Amount', value: '₹5,000'),
          const SizedBox(height: 10),
          const _InlineEditField(label: 'Note', value: 'Monthly top-up'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onConfirm,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Confirm Contribution'),
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(3, (int index) {
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index.isEven ? AppColors.accentPurple : AppColors.primary,
            ),
          ),
        );
      }),
    );
  }
}

class SuggestedActionChips extends StatelessWidget {
  const SuggestedActionChips({super.key, required this.actions});

  final List<String> actions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions
          .map(
            (String action) => _Pill(
              label: action,
              color: AppColors.primary,
              background: AppColors.primary.withValues(alpha: 0.14),
            ),
          )
          .toList(),
    );
  }
}

class FollowUpSuggestions extends StatelessWidget {
  const FollowUpSuggestions({super.key, required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return _Pill(
            label: suggestions[index],
            color: AppColors.textPrimary,
            background: AppColors.surfaceElevated,
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: suggestions.length,
      ),
    );
  }
}

class ChatModeSelector extends StatelessWidget {
  const ChatModeSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const List<String> modes = <String>['General', 'Budget', 'Investment'];
    const List<Color> colors = <Color>[
      AppColors.primary,
      AppColors.primary,
      AppColors.accentGold,
    ];
    return FinwiseCard(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: List<Widget>.generate(modes.length, (int index) {
          final bool selected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? colors[index].withValues(alpha: 0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Text(
                  modes[index],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: selected ? colors[index] : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({
    super.key,
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final double ratio = total == 0 ? 0 : completed / total;
    return FinwiseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$completed of $total modules complete',
            style: AppTextStyles.titleLarge.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AiRecommendationBanner extends StatelessWidget {
  const AiRecommendationBanner({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      gradient: const LinearGradient(
        colors: <Color>[Color(0x26A78BFA), AppColors.surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: AppColors.accentPurple.withValues(alpha: 0.35)),
      child: Row(
        children: <Widget>[
          const Icon(Icons.auto_awesome, color: AppColors.accentPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.titleLarge.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class StreakCounter extends StatelessWidget {
  const StreakCounter({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return _Pill(
      label: '🔥 $days day streak',
      color: AppColors.accentGold,
      background: AppColors.accentGold.withValues(alpha: 0.14),
    );
  }
}

class BadgeShelf extends StatelessWidget {
  const BadgeShelf({super.key, required this.badges});

  final List<String> badges;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: index.isEven
                      ? AppColors.accentGold
                      : AppColors.accentPurple,
                ),
              ),
              const SizedBox(height: 6),
              Text(badges[index], style: AppTextStyles.labelSmall),
            ],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: badges.length,
      ),
    );
  }
}

class VideoInsightsLoadingView extends StatelessWidget {
  const VideoInsightsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      child: Column(
        children: const <Widget>[
          Icon(
            Icons.psychology_alt_rounded,
            color: AppColors.accentPurple,
            size: 52,
          ),
          SizedBox(height: 12),
          Text(
            'Analyzing video with Gemini...',
            style: AppTextStyles.titleLarge,
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            minHeight: 8,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class KeyTipsList extends StatelessWidget {
  const KeyTipsList({super.key, required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tips
          .map(
            (String tip) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FinwiseCard(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                border: const Border(
                  left: BorderSide(color: AppColors.primary, width: 3),
                ),
                child: Text(
                  tip,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class ActionPointsCard extends StatelessWidget {
  const ActionPointsCard({super.key, required this.points});

  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: const <Widget>[
              Icon(Icons.check_circle_outline_rounded, color: AppColors.credit),
              SizedBox(width: 8),
              Text('Action Points', style: AppTextStyles.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          ...points.map(
            (String point) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.radio_button_unchecked_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      point,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
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

class MatchScoreBadge extends StatelessWidget {
  const MatchScoreBadge({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final Color color = score >= 75
        ? AppColors.credit
        : score >= 50
        ? AppColors.accentGold
        : AppColors.debit;
    return _Pill(
      label: '$score% Match',
      color: color,
      background: color.withValues(alpha: 0.16),
    );
  }
}

class BenefitTypeChip extends StatelessWidget {
  const BenefitTypeChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> colors = <String, Color>{
      'Loan': AppColors.accentBlue,
      'Subsidy': AppColors.accentGold,
      'Insurance': AppColors.accentPurple,
      'Savings': AppColors.primary,
    };
    final Color color = colors[label] ?? AppColors.textSecondary;
    return _Pill(
      label: label,
      color: color,
      background: color.withValues(alpha: 0.16),
    );
  }
}

class SpecializationChips extends StatelessWidget {
  const SpecializationChips({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (String item) => _Pill(
              label: item,
              color: AppColors.primary,
              background: AppColors.primary.withValues(alpha: 0.14),
            ),
          )
          .toList(),
    );
  }
}

class AvailabilityCalendar extends StatelessWidget {
  const AvailabilityCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    const List<int> days = <int>[27, 28, 29, 30, 31, 1, 2, 3, 4, 5, 6, 7];
    return FinwiseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Availability',
            style: AppTextStyles.titleLarge.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: days
                .map(
                  (int day) => Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: day == 3
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: day == 3
                          ? Border.all(color: AppColors.primary)
                          : null,
                    ),
                    child: Text(
                      '$day',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: day == 3
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class SlotPicker extends StatelessWidget {
  const SlotPicker({super.key, required this.slots});

  final List<String> slots;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: slots
          .map(
            (String slot) => _Pill(
              label: slot,
              color: AppColors.textPrimary,
              background: AppColors.surfaceElevated,
            ),
          )
          .toList(),
    );
  }
}

class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, this.color = AppColors.primary});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x33000000), blurRadius: 8),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    this.unread = true,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return FinwiseCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      border: Border(left: BorderSide(color: color, width: 3)),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.16),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (unread) const UnreadBadge(),
        ],
      ),
    );
  }
}

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const List<String> items = <String>['Light', 'Dark', 'System'];
    return Row(
      children: List<Widget>.generate(items.length, (int index) {
        final bool selected = index == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              margin: EdgeInsets.only(right: index == items.length - 1 ? 0 : 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.16)
                    : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Text(
                items[index],
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.languages,
    required this.selectedIndex,
  });

  final List<String> languages;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(languages.length, (int index) {
        final bool selected = index == selectedIndex;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: selected
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.35))
                : null,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 4,
                height: 42,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  languages[index],
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: selected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class IncomeEditBottomSheet extends StatelessWidget {
  const IncomeEditBottomSheet({super.key, required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingL,
        right: AppDimensions.paddingL,
        top: AppDimensions.paddingL,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Center(
            child: SizedBox(
              width: 44,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Edit Income Range',
            style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          const _InlineEditField(label: 'Current income', value: '₹50K - ₹1L'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Save Income'),
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.label,
    required this.value,
    required this.color,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.labelSmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(color: color, fontSize: 17),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color, this.background});

  final String label;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InlineEditField extends StatelessWidget {
  const _InlineEditField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        children: <Widget>[
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.fieldValue.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineEditor extends StatelessWidget {
  const _InlineEditor({required this.limit});

  final double limit;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Limit: ${_currency.format(limit)}',
      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          backgroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        icon: Icon(icon, size: 18, color: AppColors.primary),
        label: Text(label),
      ),
    );
  }
}

class _CornerGuide extends StatelessWidget {
  const _CornerGuide({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.alignTopLeft,
    this.alignBottomLeft = false,
    this.alignBottomRight = false,
  });

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final bool alignTopLeft;
  final bool alignBottomLeft;
  final bool alignBottomRight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.primary, width: 3),
            left: BorderSide(color: AppColors.primary, width: 3),
            right: BorderSide(color: AppColors.primary, width: 0),
            bottom: BorderSide(color: AppColors.primary, width: 0),
          ),
        ),
      ),
    );
  }
}

String _truncate(String value, int maxChars) {
  if (value.length <= maxChars) {
    return value;
  }
  return '${value.substring(0, maxChars - 1)}…';
}

final NumberFormat _currency = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);
