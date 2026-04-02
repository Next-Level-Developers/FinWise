import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/learning_module.dart';
import '../providers/learn_provider.dart';

class ModuleDetailScreen extends ConsumerWidget {
  const ModuleDetailScreen({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<LearningModule?> module = ref.watch(
      moduleProvider(moduleId),
    );
    final AsyncValue<List<LessonEntity>> lessons = ref.watch(
      moduleLessonsProvider(moduleId),
    );
    final AsyncValue<LearningProgressEntity> progress = ref.watch(
      moduleProgressProvider(moduleId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          module.maybeWhen(
            data: (LearningModule? item) => item?.title ?? 'Module',
            orElse: () => 'Module',
          ),
        ),
      ),
      body: _buildBody(context, module, lessons, progress),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncValue<LearningModule?> module,
    AsyncValue<List<LessonEntity>> lessons,
    AsyncValue<LearningProgressEntity> progress,
  ) {
    if (module.hasError) {
      return _ErrorState(message: _friendlyError(module.error!));
    }
    if (lessons.hasError) {
      return _ErrorState(message: _friendlyError(lessons.error!));
    }
    if (progress.hasError) {
      return _ErrorState(message: _friendlyError(progress.error!));
    }

    if (module.isLoading || lessons.isLoading || progress.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final LearningModule? moduleData = module.value;
    final List<LessonEntity> lessonItems =
        lessons.value ?? const <LessonEntity>[];
    final LearningProgressEntity progressData =
        progress.value ??
        const LearningProgressEntity(
          moduleId: '',
          completedLessons: <String>[],
          totalLessons: 0,
          progressPercent: 0,
          status: 'not_started',
        );

    if (moduleData == null) {
      return const Center(
        child: Text(
          'No module found.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    final Set<String> completedIds = progressData.completedLessons.toSet();
    final double progressValue = (progressData.progressPercent / 100).clamp(
      0,
      1,
    );

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
                '${completedIds.length} of ${moduleData.lessonCount} lessons complete',
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                moduleData.description,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progressValue),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (lessonItems.isEmpty)
          const Text(
            'No lessons available.',
            style: TextStyle(color: AppColors.textSecondary),
          )
        else
          ...lessonItems.asMap().entries.map((
            MapEntry<int, LessonEntity> entry,
          ) {
            final int index = entry.key;
            final LessonEntity lesson = entry.value;
            final bool isCompleted = completedIds.contains(lesson.id);

            return InkWell(
              onTap: () => context.push(
                '${AppRoutes.learn}/$moduleId/lesson/${lesson.id}',
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              child: Container(
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
                      backgroundColor: isCompleted
                          ? AppColors.primary
                          : AppColors.surfaceElevated,
                      child: Text('${index + 1}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(lesson.title, style: AppTextStyles.bodyLarge),
                    ),
                    Text(
                      '${(lesson.readTimeSec / 60).ceil()} min',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }),
        if (moduleData.hasQuiz) ...<Widget>[
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () =>
                  context.push('${AppRoutes.learn}/$moduleId/quiz'),
              child: const Text('Take quiz'),
            ),
          ),
        ],
      ],
    );
  }

  String _friendlyError(Object error) {
    final String message = error.toString();
    if (message.contains('failed-precondition') ||
        message.contains('Setting up learning content')) {
      return 'Setting up learning content… please wait';
    }
    return 'Could not load module right now.';
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Text(message),
      ),
    );
  }
}
