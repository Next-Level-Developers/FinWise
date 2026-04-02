import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class BudgetDetailScreen extends StatelessWidget {
  const BudgetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Food Budget'),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
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
              children: <Widget>[
                Text('₹8,500 spent', style: AppTextStyles.amountDisplay),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                  child: LinearProgressIndicator(
                    value: 0.85,
                    minHeight: 10,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.accentGold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '₹1,500 remaining',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recent food transactions',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 10),
          ...List<Widget>.generate(3, (int index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: const Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Text('🍔'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Lunch at Cafe', style: AppTextStyles.bodyLarge),
                        SizedBox(height: 4),
                        Text(
                          'Today • 1:20 PM',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '-₹280',
                    style: TextStyle(
                      color: AppColors.debit,
                      fontWeight: FontWeight.w600,
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
