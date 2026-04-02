import '../entities/learning_module.dart';

abstract class LearnRepository {
  Future<List<LearningModule>> getModules();
  Future<LearningModule?> getModuleById({required String moduleId});
  Future<List<LessonEntity>> getLessons({required String moduleId});
  Future<QuizEntity?> getQuiz({required String moduleId});
  Future<Map<String, LearningProgressEntity>> getAllProgress();
  Future<LearningProgressEntity> getProgress({required String moduleId});
  Future<void> completeLesson({
    required String moduleId,
    required String lessonId,
    required int totalLessons,
  });
}
