import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ModuleDetailScreen extends StatelessWidget {
  const ModuleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('EPF and NPS basics')),
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
                Text('Module 1 of 5', style: AppTextStyles.titleLarge),
                SizedBox(height: 6),
                Text(
                  'Understand retirement basics in short lessons.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(value: 0.2),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                    backgroundColor: index == 0
                        ? AppColors.primary
                        : AppColors.surfaceElevated,
                    child: Text('${index + 1}'),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Lesson title', style: AppTextStyles.bodyLarge),
                  ),
                  const Text(
                    '5 min',
                    style: TextStyle(color: AppColors.textSecondary),
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
