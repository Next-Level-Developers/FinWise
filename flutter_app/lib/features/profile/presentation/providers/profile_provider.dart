import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_info.dart';
import '../../domain/repositories/profile_repository.dart';

final Provider<ProfileRepository> profileRepositoryProvider =
    Provider<ProfileRepository>((Ref ref) => ProfileRepositoryImpl());

final FutureProvider<ProfileInfo> profileInfoProvider =
    FutureProvider<ProfileInfo>((Ref ref) {
      return ref.watch(profileRepositoryProvider).getProfileInfo();
    });
