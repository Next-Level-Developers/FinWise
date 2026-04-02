import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

final Provider<DashboardRepository> dashboardRepositoryProvider =
    Provider<DashboardRepository>((Ref ref) => DashboardRepositoryImpl());

final FutureProvider<DashboardSummary> dashboardSummaryProvider =
    FutureProvider<DashboardSummary>((Ref ref) {
      return ref.watch(dashboardRepositoryProvider).getDashboardSummary();
    });
