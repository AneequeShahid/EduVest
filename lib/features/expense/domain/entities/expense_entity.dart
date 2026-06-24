import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_entity.freezed.dart';

@freezed
class ExpenseEntity with _$ExpenseEntity {
  const factory ExpenseEntity({
    required String id,
    required double amount,
    required String description,
    required String category,
    required DateTime date,
    required int month,
    required int year,
    String? receiptUrl,
    @Default(false) bool isIncome,
    DateTime? createdAt,
  }) = _ExpenseEntity;
}
