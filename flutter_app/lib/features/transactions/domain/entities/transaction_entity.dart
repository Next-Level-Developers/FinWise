class TransactionEntity {
  TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    DateTime? datetime,
    bool? isDebit,
    this.category = '',
    this.note,
    this.paymentMethod,
    this.source,
    this.isRecurring = false,
  }) : datetime = datetime ?? DateTime.fromMillisecondsSinceEpoch(0),
       isDebit = isDebit ?? true;

  final String id;
  final String title;
  final double amount;
  final DateTime datetime;
  final bool isDebit;
  final String category;
  final String? note;
  final String? paymentMethod;
  final String? source;
  final bool isRecurring;
}
