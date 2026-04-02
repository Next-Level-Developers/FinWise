import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/profile_info.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<ProfileInfo> getProfileInfo() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw StateError('User not signed in');
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    final Map<String, dynamic> data = snapshot.data() ?? <String, dynamic>{};

    final DateTime? createdAt = (data['createdAt'] as Timestamp?)?.toDate();
    final String memberSince = createdAt == null
        ? 'Not available'
        : DateFormat('MMMM yyyy').format(createdAt);

    return ProfileInfo(
      name:
          (data['displayName'] as String?) ??
          user.displayName ??
          user.email?.split('@').first ??
          'User',
      email: (data['email'] as String?) ?? user.email ?? '',
      phone: (data['phoneNumber'] as String?) ?? user.phoneNumber ?? '-',
      address: (data['address'] as String?) ?? '-',
      accountType: (data['isOnboardingComplete'] as bool?) == true
          ? 'FinWise Verified'
          : 'FinWise Basic',
      memberSince: memberSince,
      eligibilityTags:
          ((data['eligibilityTags'] as List<dynamic>?) ?? <dynamic>[])
              .map((dynamic item) => item.toString())
              .toList(),
    );
  }
}
