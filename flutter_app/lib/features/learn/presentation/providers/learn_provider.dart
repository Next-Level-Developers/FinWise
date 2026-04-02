import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/learn_repository_impl.dart';
import '../../domain/entities/learning_module.dart';
import '../../domain/repositories/learn_repository.dart';
import '../../domain/usecases/complete_lesson.dart';
import '../../domain/usecases/get_all_learning_progress.dart';
import '../../domain/usecases/get_learning_modules.dart';
import '../../domain/usecases/get_module_lessons.dart';
import '../../domain/usecases/get_module_progress.dart';
import '../../domain/usecases/get_module_quiz.dart';

final Provider<LearnRepository> learnRepositoryProvider =
    Provider<LearnRepository>((Ref ref) => LearnRepositoryImpl());

final Provider<GetLearningModules> getLearningModulesProvider =
    Provider<GetLearningModules>((Ref ref) {
      return GetLearningModules(ref.watch(learnRepositoryProvider));
    });

final Provider<GetModuleLessons> getModuleLessonsProvider =
    Provider<GetModuleLessons>((Ref ref) {
      return GetModuleLessons(ref.watch(learnRepositoryProvider));
    });

final Provider<GetModuleQuiz> getModuleQuizProvider = Provider<GetModuleQuiz>((
  Ref ref,
) {
  return GetModuleQuiz(ref.watch(learnRepositoryProvider));
});

final Provider<GetModuleProgress> getModuleProgressProvider =
    Provider<GetModuleProgress>((Ref ref) {
      return GetModuleProgress(ref.watch(learnRepositoryProvider));
    });

final Provider<GetAllLearningProgress> getAllLearningProgressProvider =
    Provider<GetAllLearningProgress>((Ref ref) {
      return GetAllLearningProgress(ref.watch(learnRepositoryProvider));
    });

final Provider<CompleteLesson> completeLessonProvider =
    Provider<CompleteLesson>((Ref ref) {
      return CompleteLesson(ref.watch(learnRepositoryProvider));
    });

final FutureProvider<List<LearningModule>> learnModulesProvider =
    FutureProvider<List<LearningModule>>((Ref ref) async {
      final List<LearningModule> modules = await ref
          .watch(getLearningModulesProvider)
          .call();
      final Map<String, LearningProgressEntity> progressByModule = await ref
          .watch(getAllLearningProgressProvider)
          .call();

      return modules.map((LearningModule module) {
        final LearningProgressEntity? progress = progressByModule[module.id];
        return module.copyWith(progressPercent: progress?.progressPercent ?? 0);
      }).toList();
    });

final FutureProviderFamily<LearningModule?, String> moduleProvider =
    FutureProvider.family<LearningModule?, String>((Ref ref, String moduleId) {
      return ref
          .watch(learnRepositoryProvider)
          .getModuleById(moduleId: moduleId);
    });

final FutureProviderFamily<List<LessonEntity>, String> moduleLessonsProvider =
    FutureProvider.family<List<LessonEntity>, String>((
      Ref ref,
      String moduleId,
    ) {
      return ref.watch(getModuleLessonsProvider).call(moduleId: moduleId);
    });

final FutureProviderFamily<QuizEntity?, String> moduleQuizProvider =
    FutureProvider.family<QuizEntity?, String>((Ref ref, String moduleId) {
      return ref.watch(getModuleQuizProvider).call(moduleId: moduleId);
    });

final FutureProviderFamily<LearningProgressEntity, String>
moduleProgressProvider = FutureProvider.family<LearningProgressEntity, String>((
  Ref ref,
  String moduleId,
) {
  return ref.watch(getModuleProgressProvider).call(moduleId: moduleId);
});

final StateProvider<int> completedLessonsProvider = StateProvider<int>(
  (Ref ref) => 0,
);
