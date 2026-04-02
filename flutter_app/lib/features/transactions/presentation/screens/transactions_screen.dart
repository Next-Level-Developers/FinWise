import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/add_transaction_fab.dart';
import '../widgets/month_selector.dart';
import '../widgets/transaction_filter_bar.dart';
import '../widgets/transaction_list_item.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      floatingActionButton: AddTransactionFab(
        onPressed: () => context.push(AppRoutes.addTransaction),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: <Widget>[
          MonthSelector(
            monthLabel: 'October 2024',
            onPrevious: () {},
            onNext: () {},
          ),
          const SizedBox(height: 14),
          TransactionFilterBar(
            selectedIndex: _selectedFilter,
            onChanged: (int value) => setState(() => _selectedFilter = value),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total In: +₹32,000',
                  style: TextStyle(color: AppColors.credit),
                ),
                Text(
                  'Total Out: -₹24,575',
                  style: TextStyle(color: AppColors.debit),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Today', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          const TransactionListItem(
            emoji: '🍔',
            merchant: 'Lunch',
            datetime: '2:40 PM',
            amount: '-₹280',
            isDebit: true,
          ),
          const SizedBox(height: 8),
          const TransactionListItem(
            emoji: '💼',
            merchant: 'Salary Credit',
            datetime: '10:00 AM',
            amount: '+₹32,000',
            isDebit: false,
          ),
          const SizedBox(height: 8),
          const TransactionListItem(
            emoji: '🚕',
            merchant: 'Cab Ride',
            datetime: 'Yesterday',
            amount: '-₹190',
            isDebit: true,
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}
