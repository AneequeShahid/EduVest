import 'package:freezed_annotation/freezed_annotation.dart';

part 'contribution_entity.freezed.dart';

@freezed
class ContributionEntity with _$ContributionEntity {
  const factory ContributionEntity({
    required String id,
    required double amount,
    @Default('') String note,
    required DateTime date,
  }) = _ContributionEntity;
}
