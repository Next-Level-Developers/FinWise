import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/learning_module.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.module, required this.onTap});

  final LearningModule module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final int safeProgress = module.progressPercent.clamp(0, 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceElevated,
          child: Text('${module.lessonCount == 0 ? 1 : module.lessonCount}'),
        ),
        title: Text(module.title, style: AppTextStyles.titleLarge),
        subtitle: Text(
          '${module.lessonCount} lessons • ${module.estimatedMins} min',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: Text(
          '$safeProgress%',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
