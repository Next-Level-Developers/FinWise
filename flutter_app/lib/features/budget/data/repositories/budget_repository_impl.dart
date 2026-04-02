import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

class BudgetRepositoryException implements Exception {
  const BudgetRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

class BudgetRepositoryImpl implements BudgetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<BudgetEntity?> watchCurrentBudget({required String month}) {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw const BudgetRepositoryException('User not signed in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('monthly_summaries')
        .doc(month)
        .snapshots()
        .asyncMap((DocumentSnapshot<Map<String, dynamic>> summaryDoc) async {
          try {
            final Map<String, dynamic>? summary = summaryDoc.data();

            final QuerySnapshot<Map<String, dynamic>> budgetSnapshot =
                await _firestore
                    .collection('users')
                    .doc(user.uid)
                    .collection('budgets')
                    .where('month', isEqualTo: month)
                    .limit(1)
                    .get();

            final Map<String, dynamic>? budgetDoc = budgetSnapshot.docs.isEmpty
                ? null
                : budgetSnapshot.docs.first.data();

            if (summary == null && budgetDoc == null) {
              return null;
            }

            final Map<String, double> categoryLimits = _toDoubleMap(
              budgetDoc?['categoryLimits'] as Map<String, dynamic>?,
            );
            final Map<String, double> categorySpent = _toDoubleMap(
              summary?['categoryBreakdown'] as Map<String, dynamic>?,
            );

            return BudgetEntity(
              total:
                  (budgetDoc?['totalBudget'] as num?)?.toDouble() ??
                  (summary?['budgetAmount'] as num?)?.toDouble() ??
                  0,
              spent: (summary?['totalExpense'] as num?)?.toDouble() ?? 0,
              month: month,
              categoryLimits: categoryLimits,
              categorySpent: categorySpent,
              aiInsightSummary:
                  (summary?['aiInsightSummary'] as String?) ??
                  'No budget insight yet.',
            );
          } on FirebaseException catch (error) {
            if (error.code == 'failed-precondition') {
              throw const BudgetRepositoryException(
                'Setting up budget data... please wait',
              );
            }
            throw BudgetRepositoryException(
              error.message ?? 'Unable to load budget data right now.',
            );
          }
        });
  }

  @override
  Stream<List<TransactionEntity>> watchCategoryTransactions({
    required String month,
    required String category,
  }) {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw const BudgetRepositoryException('User not signed in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .where('month', isEqualTo: month)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
          final List<TransactionEntity> transactions = snapshot.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                final Map<String, dynamic> data = doc.data();
                final DateTime date =
                    (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
                final double amount = (data['amount'] as num?)?.toDouble() ?? 0;
                final String type = (data['type'] as String?) ?? 'expense';
                return TransactionEntity(
                  id: doc.id,
                  title:
                      data['merchantName'] as String? ??
                      (data['title'] as String? ?? 'Transaction'),
                  amount: amount,
                  datetime: date,
                  isDebit: type != 'income',
                  category: (data['category'] as String?) ?? '',
                );
              })
              .where(
                (TransactionEntity tx) =>
                    tx.category.toLowerCase() == category.toLowerCase(),
              )
              .toList();

          transactions.sort((a, b) => b.datetime.compareTo(a.datetime));
          return transactions;
        })
        .handleError((Object error) {
          if (error is FirebaseException &&
              error.code == 'failed-precondition') {
            throw const BudgetRepositoryException(
              'Setting up budget data... please wait',
            );
          }
          if (error is FirebaseException) {
            throw BudgetRepositoryException(
              error.message ??
                  'Unable to load category transactions right now.',
            );
          }
        });
  }

  Map<String, double> _toDoubleMap(Map<String, dynamic>? input) {
    if (input == null) {
      return <String, double>{};
    }
    return input.map((String key, dynamic value) {
      return MapEntry<String, double>(key, (value as num?)?.toDouble() ?? 0);
    });
  }
}
