import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
    text: 'Today',
  );
  int _selectedCategory = 0;
  int _selectedMethod = 0;
  bool _isRecurring = false;

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add transaction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: context.pop,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  label: Text('C${index + 1}'),
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
                  label: Text('M${index + 1}'),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedMethod = index),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text('Date', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            TextField(controller: _dateController),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Recurring transaction'),
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
                onPressed: () {},
                child: const Text('Save transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
