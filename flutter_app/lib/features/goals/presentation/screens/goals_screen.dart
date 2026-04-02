import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Goals'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          final List<_GoalCardData> goals = <_GoalCardData>[
            _GoalCardData(
              '🏠',
              'Home Down Payment',
              0.24,
              '₹2,40,000 of ₹10,00,000',
              '24 days left',
            ),
            _GoalCardData(
              '🚨',
              'Emergency Fund',
              0.61,
              '₹61,000 of ₹1,00,000',
              '18 days left',
            ),
            _GoalCardData(
              '✈️',
              'Vacation',
              0.43,
              '₹21,500 of ₹50,000',
              '40 days left',
            ),
            _GoalCardData(
              '📈',
              'Investing',
              0.79,
              '₹79,000 of ₹1,00,000',
              '12 days left',
            ),
            _GoalCardData(
              '💍',
              'Wedding Fund',
              0.12,
              '₹12,000 of ₹1,00,000',
              '90 days left',
            ),
          ];
          final _GoalCardData goal = goals[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(goal.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(goal.title, style: AppTextStyles.titleLarge),
                          const SizedBox(height: 4),
                          Text(goal.amount, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x22F4C96B),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull,
                        ),
                      ),
                      child: Text(
                        goal.daysLeft,
                        style: const TextStyle(
                          color: AppColors.accentGold,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: goal.progress,
                    minHeight: 8,
                    color: AppColors.primary,
                    backgroundColor: AppColors.surfaceElevated,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GoalCardData {
  const _GoalCardData(
    this.emoji,
    this.title,
    this.progress,
    this.amount,
    this.daysLeft,
  );

  final String emoji;
  final String title;
  final double progress;
  final String amount;
  final String daysLeft;
}
