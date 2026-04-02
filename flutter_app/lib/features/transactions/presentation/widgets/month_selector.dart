import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.monthLabel,
    required this.onPrevious,
    required this.onNext,
  });

  final String monthLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(onPressed: onPrevious, icon: const Icon(Icons.chevron_left)),
        Text(monthLabel),
        IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
      ],
    );
  }
}
