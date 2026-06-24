// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insights_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InsightsEntity {
  int get healthScore => throw _privateConstructorUsedError;
  String get healthLabel => throw _privateConstructorUsedError;
  double get monthlyYieldPercent => throw _privateConstructorUsedError;
  String get riskProfile => throw _privateConstructorUsedError;
  List<MonthlyFlowEntity> get capitalFlowData =>
      throw _privateConstructorUsedError;
  List<CategorySpendEntity> get categoryBreakdown =>
      throw _privateConstructorUsedError;
  List<RecommendationEntity> get recommendations =>
      throw _privateConstructorUsedError;

  /// Create a copy of InsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightsEntityCopyWith<InsightsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsEntityCopyWith<$Res> {
  factory $InsightsEntityCopyWith(
          InsightsEntity value, $Res Function(InsightsEntity) then) =
      _$InsightsEntityCopyWithImpl<$Res, InsightsEntity>;
  @useResult
  $Res call(
      {int healthScore,
      String healthLabel,
      double monthlyYieldPercent,
      String riskProfile,
      List<MonthlyFlowEntity> capitalFlowData,
      List<CategorySpendEntity> categoryBreakdown,
      List<RecommendationEntity> recommendations});
}

/// @nodoc
class _$InsightsEntityCopyWithImpl<$Res, $Val extends InsightsEntity>
    implements $InsightsEntityCopyWith<$Res> {
  _$InsightsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? healthScore = null,
    Object? healthLabel = null,
    Object? monthlyYieldPercent = null,
    Object? riskProfile = null,
    Object? capitalFlowData = null,
    Object? categoryBreakdown = null,
    Object? recommendations = null,
  }) {
    return _then(_value.copyWith(
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as int,
      healthLabel: null == healthLabel
          ? _value.healthLabel
          : healthLabel // ignore: cast_nullable_to_non_nullable
              as String,
      monthlyYieldPercent: null == monthlyYieldPercent
          ? _value.monthlyYieldPercent
          : monthlyYieldPercent // ignore: cast_nullable_to_non_nullable
              as double,
      riskProfile: null == riskProfile
          ? _value.riskProfile
          : riskProfile // ignore: cast_nullable_to_non_nullable
              as String,
      capitalFlowData: null == capitalFlowData
          ? _value.capitalFlowData
          : capitalFlowData // ignore: cast_nullable_to_non_nullable
              as List<MonthlyFlowEntity>,
      categoryBreakdown: null == categoryBreakdown
          ? _value.categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategorySpendEntity>,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<RecommendationEntity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsightsEntityImplCopyWith<$Res>
    implements $InsightsEntityCopyWith<$Res> {
  factory _$$InsightsEntityImplCopyWith(_$InsightsEntityImpl value,
          $Res Function(_$InsightsEntityImpl) then) =
      __$$InsightsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int healthScore,
      String healthLabel,
      double monthlyYieldPercent,
      String riskProfile,
      List<MonthlyFlowEntity> capitalFlowData,
      List<CategorySpendEntity> categoryBreakdown,
      List<RecommendationEntity> recommendations});
}

/// @nodoc
class __$$InsightsEntityImplCopyWithImpl<$Res>
    extends _$InsightsEntityCopyWithImpl<$Res, _$InsightsEntityImpl>
    implements _$$InsightsEntityImplCopyWith<$Res> {
  __$$InsightsEntityImplCopyWithImpl(
      _$InsightsEntityImpl _value, $Res Function(_$InsightsEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of InsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? healthScore = null,
    Object? healthLabel = null,
    Object? monthlyYieldPercent = null,
    Object? riskProfile = null,
    Object? capitalFlowData = null,
    Object? categoryBreakdown = null,
    Object? recommendations = null,
  }) {
    return _then(_$InsightsEntityImpl(
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as int,
      healthLabel: null == healthLabel
          ? _value.healthLabel
          : healthLabel // ignore: cast_nullable_to_non_nullable
              as String,
      monthlyYieldPercent: null == monthlyYieldPercent
          ? _value.monthlyYieldPercent
          : monthlyYieldPercent // ignore: cast_nullable_to_non_nullable
              as double,
      riskProfile: null == riskProfile
          ? _value.riskProfile
          : riskProfile // ignore: cast_nullable_to_non_nullable
              as String,
      capitalFlowData: null == capitalFlowData
          ? _value._capitalFlowData
          : capitalFlowData // ignore: cast_nullable_to_non_nullable
              as List<MonthlyFlowEntity>,
      categoryBreakdown: null == categoryBreakdown
          ? _value._categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategorySpendEntity>,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<RecommendationEntity>,
    ));
  }
}

/// @nodoc

class _$InsightsEntityImpl implements _InsightsEntity {
  const _$InsightsEntityImpl(
      {required this.healthScore,
      required this.healthLabel,
      required this.monthlyYieldPercent,
      required this.riskProfile,
      final List<MonthlyFlowEntity> capitalFlowData =
          const <MonthlyFlowEntity>[],
      final List<CategorySpendEntity> categoryBreakdown =
          const <CategorySpendEntity>[],
      final List<RecommendationEntity> recommendations =
          const <RecommendationEntity>[]})
      : _capitalFlowData = capitalFlowData,
        _categoryBreakdown = categoryBreakdown,
        _recommendations = recommendations;

  @override
  final int healthScore;
  @override
  final String healthLabel;
  @override
  final double monthlyYieldPercent;
  @override
  final String riskProfile;
  final List<MonthlyFlowEntity> _capitalFlowData;
  @override
  @JsonKey()
  List<MonthlyFlowEntity> get capitalFlowData {
    if (_capitalFlowData is EqualUnmodifiableListView) return _capitalFlowData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capitalFlowData);
  }

  final List<CategorySpendEntity> _categoryBreakdown;
  @override
  @JsonKey()
  List<CategorySpendEntity> get categoryBreakdown {
    if (_categoryBreakdown is EqualUnmodifiableListView)
      return _categoryBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryBreakdown);
  }

  final List<RecommendationEntity> _recommendations;
  @override
  @JsonKey()
  List<RecommendationEntity> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  String toString() {
    return 'InsightsEntity(healthScore: $healthScore, healthLabel: $healthLabel, monthlyYieldPercent: $monthlyYieldPercent, riskProfile: $riskProfile, capitalFlowData: $capitalFlowData, categoryBreakdown: $categoryBreakdown, recommendations: $recommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsEntityImpl &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore) &&
            (identical(other.healthLabel, healthLabel) ||
                other.healthLabel == healthLabel) &&
            (identical(other.monthlyYieldPercent, monthlyYieldPercent) ||
                other.monthlyYieldPercent == monthlyYieldPercent) &&
            (identical(other.riskProfile, riskProfile) ||
                other.riskProfile == riskProfile) &&
            const DeepCollectionEquality()
                .equals(other._capitalFlowData, _capitalFlowData) &&
            const DeepCollectionEquality()
                .equals(other._categoryBreakdown, _categoryBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      healthScore,
      healthLabel,
      monthlyYieldPercent,
      riskProfile,
      const DeepCollectionEquality().hash(_capitalFlowData),
      const DeepCollectionEquality().hash(_categoryBreakdown),
      const DeepCollectionEquality().hash(_recommendations));

  /// Create a copy of InsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsEntityImplCopyWith<_$InsightsEntityImpl> get copyWith =>
      __$$InsightsEntityImplCopyWithImpl<_$InsightsEntityImpl>(
          this, _$identity);
}

abstract class _InsightsEntity implements InsightsEntity {
  const factory _InsightsEntity(
      {required final int healthScore,
      required final String healthLabel,
      required final double monthlyYieldPercent,
      required final String riskProfile,
      final List<MonthlyFlowEntity> capitalFlowData,
      final List<CategorySpendEntity> categoryBreakdown,
      final List<RecommendationEntity> recommendations}) = _$InsightsEntityImpl;

  @override
  int get healthScore;
  @override
  String get healthLabel;
  @override
  double get monthlyYieldPercent;
  @override
  String get riskProfile;
  @override
  List<MonthlyFlowEntity> get capitalFlowData;
  @override
  List<CategorySpendEntity> get categoryBreakdown;
  @override
  List<RecommendationEntity> get recommendations;

  /// Create a copy of InsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightsEntityImplCopyWith<_$InsightsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
