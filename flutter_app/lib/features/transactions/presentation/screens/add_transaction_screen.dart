import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/transactions_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  static const List<String> _categories = <String>[
    'food',
    'transport',
    'shopping',
    'health',
    'entertainment',
    'bills',
    'salary',
    'investment',
  ];

  static const List<String> _paymentMethods = <String>[
    'upi',
    'cash',
    'card_debit',
    'netbanking',
  ];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _selectedCategory = 0;
  int _selectedMethod = 0;
  bool _isRecurring = false;
  bool _isIncome = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd MMM yyyy').format(_selectedDate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _selectedDate = picked;
      _dateController.text = DateFormat('dd MMM yyyy').format(picked);
    });
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }

    final double? parsedAmount = double.tryParse(_amountController.text.trim());
    if (parsedAmount == null ||
        parsedAmount <= 0 ||
        _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid title and amount.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final TransactionEntity transaction = TransactionEntity(
        id: '',
        title: _titleController.text.trim(),
        amount: parsedAmount,
        datetime: _selectedDate,
        isDebit: !_isIncome,
        category: _categories[_selectedCategory],
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        paymentMethod: _paymentMethods[_selectedMethod],
        source: 'manual',
        isRecurring: _isRecurring,
      );

      await ref.read(addTransactionUseCaseProvider).call(transaction);
      if (!mounted) {
        return;
      }
      context.pop(true);
    } catch (error) {
      final String message =
          error.toString().contains('Setting up transactions data')
          ? 'Setting up transactions data… please wait'
          : 'Unable to save transaction right now.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Transaction'),
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                ChoiceChip(
                  label: const Text('Expense'),
                  selected: !_isIncome,
                  onSelected: (_) => setState(() => _isIncome = false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Income'),
                  selected: _isIncome,
                  onSelected: (_) => setState(() => _isIncome = true),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Amount', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                hintText: '0.00',
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            Text('Title', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            TextField(controller: _titleController),
            const SizedBox(height: 20),
            Text('Category', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List<Widget>.generate(8, (int index) {
                final bool selected = _selectedCategory == index;
                return ChoiceChip(
                  label: Text(_categories[index]),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCategory = index),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text('Payment method', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List<Widget>.generate(4, (int index) {
                final bool selected = _selectedMethod == index;
                return ChoiceChip(
                  label: Text(_paymentMethods[index]),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedMethod = index),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text('Date', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Recurring?'),
              value: _isRecurring,
              onChanged: (bool value) => setState(() => _isRecurring = value),
            ),
            const SizedBox(height: 20),
            Text('Note', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            TextField(controller: _noteController, maxLines: 3),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving...' : 'Save transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
