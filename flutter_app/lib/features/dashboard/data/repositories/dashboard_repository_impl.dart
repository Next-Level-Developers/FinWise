import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<DashboardSummary> getDashboardSummary() async {
    return const DashboardSummary(
      userName: 'Terry',
      spent: 24575,
      budget: 38000,
      deltaLabel: '+23% vs last month',
    );
  }
}
