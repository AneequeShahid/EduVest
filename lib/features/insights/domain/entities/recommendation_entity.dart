import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_entity.freezed.dart';

enum RecommendationType { budget, savings, goal, spending, general }

@freezed
class RecommendationEntity with _$RecommendationEntity {
  const factory RecommendationEntity({
    required String id,
    required String title,
    required String description,
    @Default(RecommendationType.general) RecommendationType type,
  }) = _RecommendationEntity;
}
