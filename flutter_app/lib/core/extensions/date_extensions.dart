extension DateFormatting on DateTime {
  String get yearMonth => '$year-${month.toString().padLeft(2, '0')}';
}
