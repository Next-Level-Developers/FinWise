import 'package:flutter/material.dart';

class AmountInputField extends StatelessWidget {
  const AmountInputField({super.key, this.controller});

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(prefixText: '₹ ', hintText: '0.00'),
    );
  }
}
