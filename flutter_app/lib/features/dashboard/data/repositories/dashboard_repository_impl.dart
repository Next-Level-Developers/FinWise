import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../goals/domain/entities/goal_entity.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw StateError('User not signed in');
    }

    final String userId = user.uid;
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .get();

    final String userName =
        (userSnapshot.data()?['displayName'] as String?) ??
        user.email?.split('@').first ??
        'User';

    final String monthKey = DateTime.now().toIso8601String().substring(0, 7);
    final DocumentSnapshot<Map<String, dynamic>> monthSnapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('monthly_summaries')
            .doc(monthKey)
            .get();

    final double spent =
        (monthSnapshot.data()?['totalExpense'] as num?)?.toDouble() ?? 0.0;
    final double budget =
        (monthSnapshot.data()?['budgetAmount'] as num?)?.toDouble() ?? 0.0;
    final String deltaLabel = (monthSnapshot.data()?['savingsRate'] != null)
        ? '${((monthSnapshot.data()?['savingsRate'] as num) * 100).toStringAsFixed(0)}% savings rate'
        : 'No change yet';

    // Category breakdown from transaction collection (current month)
    final QuerySnapshot<Map<String, dynamic>> txSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('month', isEqualTo: monthKey)
        .get();

    final Map<String, double> categoryBreakdown = <String, double>{};
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in txSnapshot.docs) {
      final String category =
          (doc.data()['category'] as String?) ?? 'Uncategorized';
      final double amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0.0;
      categoryBreakdown[category] =
          (categoryBreakdown[category] ?? 0) + amount.abs();
    }

    // Goals
    final QuerySnapshot<Map<String, dynamic>> goalsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .orderBy('createdAt', descending: true)
        .limit(3)
        .get();

    final List<GoalEntity> goals = goalsSnapshot.docs.map((doc) {
      final data = doc.data();
      final double targetAmount =
          (data['targetAmount'] as num?)?.toDouble() ?? 0.0;

      return GoalEntity(
        title: data['title'] as String? ?? 'Goal',
        target: targetAmount,
      );
    }).toList();

    // Recent transactions
    final QuerySnapshot<Map<String, dynamic>> recentTxSnapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .orderBy('createdAt', descending: true)
            .limit(4)
            .get();

    final List<TransactionEntity> recentTransactions = recentTxSnapshot.docs
        .map((doc) {
          final data = doc.data();
          final double amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
          final DateTime date =
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          return TransactionEntity(
            id: doc.id,
            title:
                data['merchantName'] as String? ??
                (data['category'] as String? ?? 'Transaction'),
            amount: amount,
            datetime: date,
            isDebit: amount < 0,
            category: (data['category'] as String?) ?? '',
          );
        })
        .toList();

    return DashboardSummary(
      userName: userName,
      spent: spent,
      budget: budget,
      deltaLabel: deltaLabel,
      categoryBreakdown: categoryBreakdown,
      goals: goals,
      recentTransactions: recentTransactions,
    );
  }
}
