class MonthHelper {
  static String monthId(DateTime now) => '${now.year}-${now.month.toString().padLeft(2, '0')}';
}
