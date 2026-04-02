import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class LearnHubScreen extends StatelessWidget {
  const LearnHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Learn'),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '🔥 5 day streak',
                style: TextStyle(color: AppColors.accentGold, fontSize: 12),
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
                  '3 of 12 modules complete',
                  style: AppTextStyles.titleLarge,
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                  child: LinearProgressIndicator(
                    value: 0.25,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: const Color(0x26A78BFA),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(
                color: AppColors.accentPurple.withValues(alpha: 0.35),
              ),
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.auto_awesome, color: AppColors.accentPurple),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AI recommends: EPF and NPS basics',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...List<Widget>.generate(4, (int i) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Text('${i + 1}'),
                ),
                title: Text('Module ${i + 1}', style: AppTextStyles.titleLarge),
                subtitle: const Text(
                  '5 lessons • 18 min',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                trailing: const Text(
                  'Start',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
