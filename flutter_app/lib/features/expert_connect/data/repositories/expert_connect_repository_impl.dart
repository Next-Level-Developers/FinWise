import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/consultant.dart';
import '../../domain/repositories/expert_connect_repository.dart';

class ExpertConnectRepositoryImpl implements ExpertConnectRepository {
  ExpertConnectRepositoryImpl() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<List<Consultant>> getConsultants() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('expert_consultants')
        .where('isActive', isEqualTo: true)
        .get();

    final List<Consultant> consultants = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data();
      final List<String> specializations =
          ((data['specializations'] as List<dynamic>?) ?? <dynamic>[])
              .map((dynamic item) => item.toString())
              .toList();

      return Consultant(
        id: doc.id,
        name: (data['name'] as String?) ?? 'Consultant',
        specializationLabel: specializations.isEmpty
            ? 'Financial planning'
            : specializations.take(2).join(' • '),
        sessionFeeInr: (data['sessionFeeINR'] as num?)?.toDouble() ?? 0,
      );
    }).toList();

    consultants.sort((Consultant a, Consultant b) {
      return a.sessionFeeInr.compareTo(b.sessionFeeInr);
    });

    return consultants;
  }
}
