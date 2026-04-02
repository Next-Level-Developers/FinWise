import 'package:flutter/material.dart';

class AppDecorations {
  static BoxDecoration roundedSurface(double radius) {
    return BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
