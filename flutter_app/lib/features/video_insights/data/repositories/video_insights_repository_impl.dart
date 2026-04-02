import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/video_insight.dart';
import '../../domain/repositories/video_insights_repository.dart';

class VideoInsightsRepositoryImpl implements VideoInsightsRepository {
  VideoInsightsRepositoryImpl()
    : _firestore = FirebaseFirestore.instance,
      _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<List<VideoInsight>> getVideoInsights() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw StateError('User not signed in');
    }

    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('video_insights')
        .orderBy('analyzedAt', descending: true)
        .get();

    return snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      final Map<String, dynamic> data = doc.data();
      return VideoInsight(
        id: doc.id,
        title: (data['videoTitle'] as String?) ?? 'Video insight',
        channelName: (data['channelName'] as String?) ?? 'Unknown channel',
        relevanceScore: (data['relevanceScore'] as num?)?.toDouble() ?? 0,
      );
    }).toList();
  }
}
