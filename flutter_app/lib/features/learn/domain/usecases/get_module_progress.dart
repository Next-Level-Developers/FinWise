import '../entities/learning_module.dart';
import '../repositories/learn_repository.dart';

class GetModuleProgress {
  const GetModuleProgress(this._repository);

  final LearnRepository _repository;

  Future<LearningProgressEntity> call({required String moduleId}) {
    return _repository.getProgress(moduleId: moduleId);
  }
}
