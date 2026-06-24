import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.amount,
    required super.isIncome,
    required super.status,
    required super.date,
    super.category,
    super.note,
    super.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime date;
    final rawDate = json['date'];
    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is String) {
      date = DateTime.parse(rawDate);
    } else {
      date = DateTime.now();
    }

    DateTime? createdAt;
    final rawCreatedAt = json['createdAt'];
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      createdAt = DateTime.parse(rawCreatedAt);
    }

    final type = json['type'] as String?;
    final isIncome = type == 'income' || (json['isIncome'] as bool? ?? false);
    final note = json['note'] as String? ?? json['title'] as String? ?? '';
    final category = json['category'] as String? ?? 'General';
    final id = json['id'] as String? ?? '';
    final subtitle = json['subtitle'] as String? ?? '';
    final status = json['status'] as String? ?? 'SUCCESS';
    final amount = (json['amount'] as num?)?.toDouble() ?? 0.0;

    return TransactionModel(
      id: id,
      title: note,
      subtitle: subtitle,
      amount: amount,
      isIncome: isIncome,
      status: status,
      date: date,
      category: category,
      note: note,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': isIncome ? 'income' : 'expense',
      'isIncome': isIncome, // for backward compatibility
      'category': category,
      'date': Timestamp.fromDate(date),
      'note': title,
      'title': title, // for backward compatibility
      'subtitle': subtitle,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
