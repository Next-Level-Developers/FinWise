import '../entities/learning_module.dart';
import '../repositories/learn_repository.dart';

class GetModuleQuiz {
  const GetModuleQuiz(this._repository);

  final LearnRepository _repository;

  Future<QuizEntity?> call({required String moduleId}) {
    return _repository.getQuiz(moduleId: moduleId);
  }
}
