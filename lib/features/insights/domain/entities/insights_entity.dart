import 'package:freezed_annotation/freezed_annotation.dart';

import 'category_spend_entity.dart';
import 'monthly_flow_entity.dart';
import 'recommendation_entity.dart';

part 'insights_entity.freezed.dart';

@freezed
class InsightsEntity with _$InsightsEntity {
  const factory InsightsEntity({
    required int healthScore,
    required String healthLabel,
    required double monthlyYieldPercent,
    required String riskProfile,
    @Default(<MonthlyFlowEntity>[]) List<MonthlyFlowEntity> capitalFlowData,
    @Default(<CategorySpendEntity>[])
    List<CategorySpendEntity> categoryBreakdown,
    @Default(<RecommendationEntity>[])
    List<RecommendationEntity> recommendations,
  }) = _InsightsEntity;
}
