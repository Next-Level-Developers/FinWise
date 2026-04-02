import 'package:flutter/material.dart';

class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.selectedType,
    required this.onTypeChanged,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final int selectedType;
  final ValueChanged<int> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final List<String> allCategories = <String>['All', ...categories];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allCategories.map((String category) {
            final String normalized = category.toLowerCase();
            final bool isSelected =
                (normalized == 'all' && selectedCategory == 'all') ||
                normalized == selectedCategory;

            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => onCategoryChanged(normalized),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            ChoiceChip(
              label: const Text('All'),
              selected: selectedType == 0,
              onSelected: (_) => onTypeChanged(0),
            ),
            ChoiceChip(
              label: const Text('Income'),
              selected: selectedType == 1,
              onSelected: (_) => onTypeChanged(1),
            ),
            ChoiceChip(
              label: const Text('Expense'),
              selected: selectedType == 2,
              onSelected: (_) => onTypeChanged(2),
            ),
          ],
        ),
      ],
    );
  }
}
