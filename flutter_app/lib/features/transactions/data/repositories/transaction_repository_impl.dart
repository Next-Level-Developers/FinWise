import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/transaction_model.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryException implements Exception {
  const TransactionRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl()
    : _firestore = FirebaseFirestore.instance,
      _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<void> add(TransactionEntity transaction) async {
    final User user = _currentUser();
    final CollectionReference<Map<String, dynamic>> txCollection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions');
    final DocumentReference<Map<String, dynamic>> txRef = txCollection.doc();

    final TransactionModel model = TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      datetime: transaction.datetime,
      isDebit: transaction.isDebit,
      category: transaction.category,
      note: transaction.note,
      paymentMethod: transaction.paymentMethod,
      source: transaction.source,
      isRecurring: transaction.isRecurring,
    );

    final String month =
        '${transaction.datetime.year.toString().padLeft(4, '0')}-${transaction.datetime.month.toString().padLeft(2, '0')}';
    final DocumentReference<Map<String, dynamic>> summaryRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('monthly_summaries')
        .doc(month);

    final double value = transaction.amount.abs();
    final String category = transaction.category.isEmpty
        ? 'other'
        : transaction.category.toLowerCase();

    final Map<String, dynamic> summaryUpdate = <String, dynamic>{
      'month': month,
      'year': transaction.datetime.year,
      'txnCount': FieldValue.increment(1),
      'categoryBreakdown.$category': FieldValue.increment(value),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (transaction.isDebit) {
      summaryUpdate['totalExpense'] = FieldValue.increment(value);
      summaryUpdate['totalSavings'] = FieldValue.increment(-value);
    } else {
      summaryUpdate['totalIncome'] = FieldValue.increment(value);
      summaryUpdate['totalSavings'] = FieldValue.increment(value);
    }

    try {
      final WriteBatch batch = _firestore.batch();
      batch.set(txRef, model.toFirestore(id: txRef.id));
      batch.set(summaryRef, summaryUpdate, SetOptions(merge: true));
      await batch.commit();
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Stream<List<TransactionEntity>> watchByMonth(String month) {
    final User user = _currentUser();
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .where('month', isEqualTo: month)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
          final List<TransactionEntity> items = snapshot.docs
              .map(TransactionModel.fromFirestore)
              .cast<TransactionEntity>()
              .toList();
          items.sort((a, b) => b.datetime.compareTo(a.datetime));
          return items;
        })
        .handleError((Object error) {
          if (error is FirebaseException) {
            throw _mapError(error);
          }
          throw error;
        });
  }

  User _currentUser() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw const TransactionRepositoryException('User is not signed in');
    }
    return user;
  }

  TransactionRepositoryException _mapError(FirebaseException error) {
    if (error.code == 'failed-precondition' ||
        (error.message ?? '').contains('failed-precondition')) {
      return const TransactionRepositoryException(
        'Setting up transactions data… please wait',
      );
    }
    return TransactionRepositoryException(
      error.message ?? 'Unable to load transactions right now.',
    );
  }
}
