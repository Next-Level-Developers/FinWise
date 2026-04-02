import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class BudgetSetupScreen extends StatelessWidget {
  const BudgetSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Set Up Budget — October 2024')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
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
                    'Generate with AI',
                    style: AppTextStyles.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: const Text('Set Manually', style: AppTextStyles.titleLarge),
          ),
          const SizedBox(height: 12),
          ...List<Widget>.generate(4, (int index) {
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
                    backgroundColor: AppColors.surfaceElevated,
                    child: Text('${index + 1}'),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Category budget',
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const SizedBox(
                    width: 96,
                    child: TextField(
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(prefixText: '₹ '),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Save Budget')),
        ],
      ),
    );
  }
}
