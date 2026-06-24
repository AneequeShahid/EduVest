import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_spend_entity.freezed.dart';

@freezed
class CategorySpendEntity with _$CategorySpendEntity {
  const factory CategorySpendEntity({
    required String category,
    required double totalSpent,
    required double percentOfTotal,
    @Default('#C1622A') String colorHex,
  }) = _CategorySpendEntity;
}
