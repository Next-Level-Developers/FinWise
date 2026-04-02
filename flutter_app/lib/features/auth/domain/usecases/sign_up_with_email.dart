import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmail {
  const SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  Future<UserEntity?> call(String email, String password) {
    return _repository.signUpWithEmail(email, password);
  }
}
