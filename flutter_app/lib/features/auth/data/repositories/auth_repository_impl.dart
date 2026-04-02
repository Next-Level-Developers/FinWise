import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<UserEntity?> signInWithEmail(String email, String password) {
    return _remoteDataSource.signIn(email, password);
  }

  @override
  Future<UserEntity?> signUpWithEmail(
    String name,
    String email,
    String password,
  ) {
    return _remoteDataSource.signUp(name, email, password);
  }

  @override
  Future<void> signOut() async {}

  @override
  Stream<UserEntity?> watchAuthState() => _remoteDataSource.watchAuthState();
}
