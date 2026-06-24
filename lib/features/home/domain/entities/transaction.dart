class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final String status;
  final DateTime date;
  final String category;
  final String note;
  final DateTime? createdAt;

  const Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.status,
    required this.date,
    this.category = 'General',
    this.note = '',
    this.createdAt,
  });
}
