import '../entities/learning_module.dart';
import '../repositories/learn_repository.dart';

class GetAllLearningProgress {
  const GetAllLearningProgress(this._repository);

  final LearnRepository _repository;

  Future<Map<String, LearningProgressEntity>> call() {
    return _repository.getAllProgress();
  }
}
