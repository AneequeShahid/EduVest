import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_flow_entity.freezed.dart';

@freezed
class MonthlyFlowEntity with _$MonthlyFlowEntity {
  const MonthlyFlowEntity._();

  const factory MonthlyFlowEntity({
    required int month,
    required int year,
    @Default(0.0) double totalSpent,
    @Default(0.0) double totalIncome,
  }) = _MonthlyFlowEntity;

  double get net => totalIncome - totalSpent;
}
