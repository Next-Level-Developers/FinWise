import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../transactions/presentation/widgets/transaction_list_item.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    const List<_TxDemo> transactions = <_TxDemo>[
      _TxDemo(
        icon: '☕',
        merchant: 'Starbucks Coffee',
        datetime: 'October 17, 09:00 PM',
        amount: '-₹44.80',
        cashback: '+₹1.65',
        isDebit: true,
      ),
      _TxDemo(
        icon: '🛒',
        merchant: 'Whole Foods',
        datetime: 'October 17, 01:20 PM',
        amount: '-₹125.30',
        cashback: '+₹2.10',
        isDebit: true,
      ),
    ];

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Recent Transactions', style: AppTextStyles.titleLarge),
              GestureDetector(
                onTap: () => context.push('/app/transactions'),
                child: Text(
                  'See All →',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...transactions.map(
          (_TxDemo tx) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: 4,
            ),
            child: TransactionListItem(
              emoji: tx.icon,
              merchant: tx.merchant,
              datetime: tx.datetime,
              amount: tx.amount,
              cashback: tx.cashback,
              isDebit: tx.isDebit,
            ),
          ),
        ),
      ],
    );
  }
}

class _TxDemo {
  const _TxDemo({
    required this.icon,
    required this.merchant,
    required this.datetime,
    required this.amount,
    required this.cashback,
    required this.isDebit,
  });

  final String icon;
  final String merchant;
  final String datetime;
  final String amount;
  final String cashback;
  final bool isDebit;
}
