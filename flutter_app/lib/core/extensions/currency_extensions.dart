extension CurrencyFormatting on num {
  String get inr => '₹${toStringAsFixed(2)}';
}
