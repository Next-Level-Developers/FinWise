import '../entities/scheme_entity.dart';

abstract class SchemesRepository {
  Future<List<SchemeEntity>> getSchemesForCurrentUser();
}
