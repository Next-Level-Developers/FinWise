import '../entities/learning_module.dart';
import '../repositories/learn_repository.dart';

class GetModuleLessons {
  const GetModuleLessons(this._repository);

  final LearnRepository _repository;

  Future<List<LessonEntity>> call({required String moduleId}) {
    return _repository.getLessons(moduleId: moduleId);
  }
}
