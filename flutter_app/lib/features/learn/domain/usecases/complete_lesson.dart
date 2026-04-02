import '../repositories/learn_repository.dart';

class CompleteLesson {
  const CompleteLesson(this._repository);

  final LearnRepository _repository;

  Future<void> call({
    required String moduleId,
    required String lessonId,
    required int totalLessons,
  }) {
    return _repository.completeLesson(
      moduleId: moduleId,
      lessonId: lessonId,
      totalLessons: totalLessons,
    );
  }
}
