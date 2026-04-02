import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.datetime,
    required super.isDebit,
    required super.category,
    super.note,
    super.paymentMethod,
    super.source,
    super.isRecurring,
  });

  factory TransactionModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final Map<String, dynamic> data = doc.data();
    final Timestamp? rawDate = data['date'] as Timestamp?;
    final Timestamp? rawCreatedAt = data['createdAt'] as Timestamp?;
    final String type = (data['type'] as String?) ?? 'expense';

    return TransactionModel(
      id: doc.id,
      title:
          (data['title'] as String?) ??
          (data['merchantName'] as String?) ??
          'Transaction',
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      datetime: (rawDate ?? rawCreatedAt)?.toDate() ?? DateTime.now(),
      isDebit: type != 'income',
      category: (data['category'] as String?) ?? 'other',
      note: data['note'] as String?,
      paymentMethod: data['paymentMethod'] as String?,
      source: data['source'] as String?,
      isRecurring: (data['isRecurring'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toFirestore({required String id}) {
    final String month =
        '${datetime.year.toString().padLeft(4, '0')}-${datetime.month.toString().padLeft(2, '0')}';

    return <String, dynamic>{
      'id': id,
      'type': isDebit ? 'expense' : 'income',
      'amount': amount.abs(),
      'currency': 'INR',
      'category': category,
      'subCategory': null,
      'tags': <String>[],
      'title': title,
      'note': note,
      'merchantName': title,
      'source': source ?? 'manual',
      'receiptURL': null,
      'ocrRawText': null,
      'paymentMethod': paymentMethod ?? 'upi',
      'accountLabel': null,
      'date': Timestamp.fromDate(datetime),
      'month': month,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'aiCategorized': false,
      'isRecurring': isRecurring,
      'recurringId': null,
    };
  }
}
