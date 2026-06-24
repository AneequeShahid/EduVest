import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required double amount,
    required String description,
    required String category,
    required DateTime date,
    @Default(false) bool isIncome,
  }) = _TransactionEntity;
}
