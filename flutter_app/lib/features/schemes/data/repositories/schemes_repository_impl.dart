import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/scheme_entity.dart';
import '../../domain/repositories/schemes_repository.dart';

class SchemesRepositoryImpl implements SchemesRepository {
  SchemesRepositoryImpl()
    : _firestore = FirebaseFirestore.instance,
      _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<List<SchemeEntity>> getSchemesForCurrentUser() async {
    final User user = _currentUser();
    final DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    final List<String> eligibilityTags =
        ((userDoc.data()?['eligibilityTags'] as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic tag) => tag.toString())
            .toList();

    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('government_schemes')
        .where('isActive', isEqualTo: true)
        .get();

    final List<SchemeEntity> schemes = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data();
      final List<String> schemeTags =
          ((data['eligibilityTags'] as List<dynamic>?) ?? <dynamic>[])
              .map((dynamic tag) => tag.toString())
              .toList();

      final int overlap = schemeTags.where((String tag) {
        return eligibilityTags.contains(tag);
      }).length;
      final int score = schemeTags.isEmpty
          ? 0
          : ((overlap / schemeTags.length) * 100).round();

      return SchemeEntity(
        id: doc.id,
        name: (data['name'] as String?) ?? 'Scheme',
        tagline: (data['tagline'] as String?) ?? '',
        emoji: (data['emoji'] as String?) ?? '🏛️',
        matchScore: score,
      );
    }).toList();

    schemes.sort(
      (SchemeEntity a, SchemeEntity b) => b.matchScore.compareTo(a.matchScore),
    );
    return schemes;
  }

  User _currentUser() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw StateError('User not signed in');
    }
    return user;
  }
}
