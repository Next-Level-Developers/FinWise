import 'package:flutter/material.dart';

class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List<Widget>.generate(4, (int index) {
        return ChoiceChip(
          label: Text('F${index + 1}'),
          selected: selectedIndex == index,
          onSelected: (_) => onChanged(index),
        );
      }),
    );
  }
}
