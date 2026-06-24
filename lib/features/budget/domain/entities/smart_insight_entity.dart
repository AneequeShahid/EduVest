import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_insight_entity.freezed.dart';

enum SmartInsightType { saved, warning, tightWeek }

@freezed
class SmartInsightEntity with _$SmartInsightEntity {
  const factory SmartInsightEntity({
    required SmartInsightType type,
    required String message,
    String? category,
    @Default(false) bool isGroceryRelated,
  }) = _SmartInsightEntity;
}
