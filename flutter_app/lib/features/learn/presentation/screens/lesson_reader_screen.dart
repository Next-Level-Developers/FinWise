import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/learning_module.dart';
import '../providers/learn_provider.dart';

class LessonReaderScreen extends ConsumerWidget {
  const LessonReaderScreen({
    super.key,
    required this.moduleId,
    required this.lessonId,
  });

  final String moduleId;
  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LessonEntity>> lessons = ref.watch(
      moduleLessonsProvider(moduleId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Lesson')),
      body: lessons.when(
        data: (List<LessonEntity> items) {
          final LessonEntity? lesson = items.cast<LessonEntity?>().firstWhere(
            (LessonEntity? item) => item?.id == lessonId,
            orElse: () => null,
          );

          if (lesson == null) {
            return const Center(
              child: Text(
                'No lesson content available.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final int lessonIndex = items.indexWhere((LessonEntity item) {
            return item.id == lesson.id;
          });

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            children: <Widget>[
              Text(lesson.title, style: AppTextStyles.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Lesson ${lessonIndex + 1} of ${items.length}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                ),
                child: SelectableText(
                  lesson.content.isEmpty
                      ? 'No lesson content available.'
                      : lesson.content,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(completeLessonProvider)
                        .call(
                          moduleId: moduleId,
                          lessonId: lessonId,
                          totalLessons: items.length,
                        );

                    ref.invalidate(moduleProgressProvider(moduleId));
                    ref.invalidate(learnModulesProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lesson marked complete')),
                      );
                    }
                  },
                  child: const Text('Mark as completed'),
                ),
              ),
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
    return 'Could not load lesson right now.';
  }
}
