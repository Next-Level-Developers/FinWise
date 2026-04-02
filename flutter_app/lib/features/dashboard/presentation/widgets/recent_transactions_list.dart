import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../transactions/presentation/widgets/transaction_list_item.dart';

import '../../../transactions/domain/entities/transaction_entity.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({super.key, required this.transactions});

  final List<TransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
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
          (TransactionEntity tx) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: 4,
            ),
            child: TransactionListItem(
              emoji: tx.title.isNotEmpty ? tx.title.characters.first : '💵',
              merchant: tx.title,
              datetime: 'Recent',
              amount: '₹${tx.amount.toStringAsFixed(2)}',
              cashback: '+₹0',
              isDebit: tx.amount < 0,
            ),
          ),
        ),
      ],
    );
  }
}
