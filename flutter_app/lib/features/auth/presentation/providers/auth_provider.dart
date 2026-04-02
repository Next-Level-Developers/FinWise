import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
      (Ref ref) => AuthRepositoryImpl(const AuthRemoteDataSource()),
    );

final StreamProvider<dynamic> authStateProvider = StreamProvider<dynamic>((
  Ref ref,
) {
  return ref.watch(authRepositoryProvider).watchAuthState();
});
