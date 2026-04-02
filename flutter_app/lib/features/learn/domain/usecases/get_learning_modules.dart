import '../entities/learning_module.dart';
import '../repositories/learn_repository.dart';

class GetLearningModules {
  const GetLearningModules(this._repository);

  final LearnRepository _repository;

  Future<List<LearningModule>> call() {
    return _repository.getModules();
  }
}
