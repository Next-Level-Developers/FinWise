import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/ai_insight.dart';

final FutureProvider<AiInsight> aiInsightProvider = FutureProvider<AiInsight>((
  Ref ref,
) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw StateError('User not signed in');
  }

  final String month = DateFormat('yyyy-MM').format(DateTime.now());
  final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
      .instance
      .collection('users')
      .doc(user.uid)
      .collection('monthly_summaries')
      .doc(month)
      .get();

  final String summary =
      (doc.data()?['aiInsightSummary'] as String?) ??
      'No insights generated for this month yet.';

  return AiInsight(summary: summary);
});
