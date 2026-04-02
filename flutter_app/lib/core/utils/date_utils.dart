class DateUtilsX {
  static String currentYearMonth(DateTime now) => '${now.year}-${now.month.toString().padLeft(2, '0')}';
}
