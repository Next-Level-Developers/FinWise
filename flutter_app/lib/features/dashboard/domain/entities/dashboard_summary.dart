class DashboardSummary {
  const DashboardSummary({
    required this.userName,
    required this.spent,
    required this.budget,
    required this.deltaLabel,
  });

  final String userName;
  final double spent;
  final double budget;
  final String deltaLabel;
}
