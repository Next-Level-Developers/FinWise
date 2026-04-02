import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/learning_module.dart';
import '../providers/learn_provider.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<QuizEntity?> quiz = ref.watch(
      moduleQuizProvider(moduleId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Quiz')),
      body: quiz.when(
        data: (QuizEntity? data) {
          if (data == null || data.questions.isEmpty) {
            return const Center(
              child: Text(
                'No quiz available for this module.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            itemCount: data.questions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final QuizQuestionEntity question = data.questions[index];
              return Container(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Q${index + 1}. ${question.questionText}',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    ...question.options.map((String option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '• $option',
                          style: AppTextStyles.bodyLarge,
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
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
    return 'Could not load quiz right now.';
  }
}
