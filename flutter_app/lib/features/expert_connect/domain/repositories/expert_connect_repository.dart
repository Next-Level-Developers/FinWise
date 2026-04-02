import '../entities/consultant.dart';

abstract class ExpertConnectRepository {
  Future<List<Consultant>> getConsultants();
}
