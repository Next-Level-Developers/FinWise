import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/schemes_repository_impl.dart';
import '../../domain/entities/scheme_entity.dart';
import '../../domain/repositories/schemes_repository.dart';

final Provider<SchemesRepository> schemesRepositoryProvider =
    Provider<SchemesRepository>((Ref ref) {
      return SchemesRepositoryImpl();
    });

final FutureProvider<List<SchemeEntity>> schemesProvider =
    FutureProvider<List<SchemeEntity>>((Ref ref) {
      return ref.watch(schemesRepositoryProvider).getSchemesForCurrentUser();
    });
