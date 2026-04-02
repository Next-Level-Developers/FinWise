import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Budget'),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'October 2024',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '₹13,425 remaining',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '₹24,575 spent of ₹38,000 budget',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 10,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: const Color(0x261A1433),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.auto_awesome, color: AppColors.accentPurple),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Generate AI Budget',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...List<Widget>.generate(8, (int i) {
            final List<String> categories = <String>[
              'Food',
              'Transport',
              'Shopping',
              'Health',
              'Bills',
              'Education',
              'Entertainment',
              'Savings',
            ];
            final List<double> values = <double>[
              0.88,
              0.43,
              0.66,
              0.31,
              0.55,
              0.22,
              0.37,
              0.48,
            ];
            final List<Color> colors = <Color>[
              AppColors.accentGold,
              AppColors.accentBlue,
              AppColors.accentCoral,
              AppColors.primary,
              AppColors.warning,
              AppColors.accentPurple,
              AppColors.accentBlue,
              AppColors.primary,
            ];

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: colors[i].withValues(alpha: 0.16),
                    child: Text(
                      categories[i].substring(0, 1),
                      style: TextStyle(color: colors[i]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(categories[i], style: AppTextStyles.bodyLarge),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: values[i],
                            minHeight: 8,
                            backgroundColor: AppColors.surfaceElevated,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colors[i],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '₹3,200 / ₹5,000',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
