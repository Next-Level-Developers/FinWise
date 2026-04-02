import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmail {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  Future<UserEntity?> call(String email, String password) {
    return _repository.signInWithEmail(email, password);
  }
}
