import 'package:flutter/material.dart';

class OcrResultPreviewCard extends StatelessWidget {
  const OcrResultPreviewCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(text)),
    );
  }
}
