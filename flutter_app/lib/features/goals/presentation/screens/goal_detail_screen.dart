import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emergency Fund'),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text(
              'Active',
              style: TextStyle(color: AppColors.primary),
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
              children: <Widget>[
                Text('61%', style: AppTextStyles.amountDisplay),
                SizedBox(height: 10),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.surfaceElevated,
                  child: Text('🚨'),
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(value: 0.61, minHeight: 10),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('AI Advice', style: AppTextStyles.titleLarge),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: const Color(0x261A1433),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Your emergency fund is on track. Keeping one no-spend weekend each month will keep momentum without forcing a hard cut.',
              style: TextStyle(color: AppColors.textPrimary, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Add Contribution'),
          ),
        ],
      ),
    );
  }
}
