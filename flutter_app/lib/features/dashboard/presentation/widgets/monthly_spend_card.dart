import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class MonthlySpendCard extends StatelessWidget {
  const MonthlySpendCard({
    super.key,
    required this.spent,
    required this.budget,
    required this.deltaLabel,
  });

  final double spent;
  final double budget;
  final String deltaLabel;

  @override
  Widget build(BuildContext context) {
    final double ratio = budget == 0 ? 0 : (spent / budget).clamp(0, 1);
    final String spentLabel = _currency.format(spent);
    final String budgetLabel = _currency.format(budget);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF1A1A1A), Color(0xFF141414)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Total Spent', style: AppTextStyles.bodySmall),
                const SizedBox(height: 6),
                Text(spentLabel, style: AppTextStyles.amountDisplay),
                const SizedBox(height: 10),
                _DeltaPill(label: deltaLabel, isPositive: spent <= budget),
                const SizedBox(height: 12),
                Text(
                  '$spentLabel spent of $budgetLabel budget',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 92,
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 88,
                      width: 88,
                      child: CircularProgressIndicator(
                        value: ratio,
                        strokeWidth: 10,
                        backgroundColor: AppColors.surfaceElevated,
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
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'used',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(4, (int index) {
                    final double height = [16.0, 28.0, 20.0, 34.0][index];
                    final bool active = index <= (ratio * 3).round();
                    return Container(
                      width: 6,
                      height: height,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );
}

class _DeltaPill extends StatelessWidget {
  const _DeltaPill({required this.label, required this.isPositive});

  final String label;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final Color background = isPositive
        ? const Color(0x224ADE80)
        : const Color(0x22F7A8B8);
    final Color foreground = isPositive
        ? AppColors.credit
        : AppColors.accentCoral;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
