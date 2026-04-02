import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl()
    : _firestore = FirebaseFirestore.instance,
      _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<List<AppNotification>> getNotifications() async {
    final User user = _currentUser();
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      final Map<String, dynamic> data = doc.data();
      return AppNotification(
        id: doc.id,
        title: (data['title'] as String?) ?? 'Notification',
        body: (data['body'] as String?) ?? '',
        type: (data['type'] as String?) ?? 'daily_tip',
        isRead: (data['isRead'] as bool?) ?? false,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  @override
  Future<void> markAllAsRead() async {
    final User user = _currentUser();
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    final WriteBatch batch = _firestore.batch();
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in snapshot.docs) {
      batch.update(doc.reference, <String, dynamic>{
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  User _currentUser() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw StateError('User not signed in');
    }
    return user;
  }
}
