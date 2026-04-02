import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/learning_module.dart';
import '../providers/learn_provider.dart';
import '../widgets/module_card.dart';

class LearnHubScreen extends ConsumerWidget {
  const LearnHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LearningModule>> modules = ref.watch(
      learnModulesProvider,
    );

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
      body: modules.when(
        data: (List<LearningModule> items) {
          final int completedCount = items.where((LearningModule module) {
            return module.progressPercent >= 100;
          }).length;
          final double overallProgress = items.isEmpty
              ? 0
              : completedCount / items.length;

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$completedCount of ${items.length} modules complete',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(99)),
                      child: LinearProgressIndicator(
                        value: overallProgress,
                        minHeight: 8,
                        backgroundColor: AppColors.surfaceElevated,
                        valueColor: const AlwaysStoppedAnimation<Color>(
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
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.accentPurple,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        items.isEmpty
                            ? 'AI recommends: no module available yet'
                            : 'AI recommends: ${items.first.title}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Text(
                  'No learning content available.',
                  style: TextStyle(color: AppColors.textSecondary),
                )
              else
                ...items.map((LearningModule module) {
                  return ModuleCard(
                    module: module,
                    onTap: () =>
                        context.push('${AppRoutes.learn}/${module.id}'),
                  );
                }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Text(_friendlyError(error)),
          ),
        ),
      ),
    );
  }

  String _friendlyError(Object error) {
    final String message = error.toString();
    if (message.contains('failed-precondition') ||
        message.contains('Setting up learning content')) {
      return 'Setting up learning content… please wait';
    }
    return 'Could not load learning content right now.';
  }
}
