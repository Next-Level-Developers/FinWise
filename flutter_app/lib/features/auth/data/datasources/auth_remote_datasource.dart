import '../../domain/entities/user_entity.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<UserEntity?> signIn(String email, String password) async =>
      UserEntity(id: 'demo', email: email, displayName: 'Terry');

  Future<UserEntity?> signUp(
    String name,
    String email,
    String password,
  ) async => UserEntity(id: 'demo', email: email, displayName: name);

  Stream<UserEntity?> watchAuthState() async* {
    yield const UserEntity(
      id: 'demo',
      email: 'demo@finwise.app',
      displayName: 'Terry',
    );
  }
}
