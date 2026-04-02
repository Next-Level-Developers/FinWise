import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
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
          label: Text('Method ${index + 1}'),
          selected: selectedIndex == index,
          onSelected: (_) => onChanged(index),
        );
      }),
    );
  }
}
