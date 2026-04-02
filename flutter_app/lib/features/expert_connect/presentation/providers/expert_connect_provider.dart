import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/expert_connect_repository_impl.dart';
import '../../domain/entities/consultant.dart';
import '../../domain/repositories/expert_connect_repository.dart';

final Provider<ExpertConnectRepository> expertConnectRepositoryProvider =
    Provider<ExpertConnectRepository>((Ref ref) {
      return ExpertConnectRepositoryImpl();
    });

final FutureProvider<List<Consultant>> consultantsProvider =
    FutureProvider<List<Consultant>>((Ref ref) {
      return ref.watch(expertConnectRepositoryProvider).getConsultants();
    });
