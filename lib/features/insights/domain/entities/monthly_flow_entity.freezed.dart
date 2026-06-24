// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_flow_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthlyFlowEntity {
  int get month => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  double get totalSpent => throw _privateConstructorUsedError;
  double get totalIncome => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyFlowEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyFlowEntityCopyWith<MonthlyFlowEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyFlowEntityCopyWith<$Res> {
  factory $MonthlyFlowEntityCopyWith(
          MonthlyFlowEntity value, $Res Function(MonthlyFlowEntity) then) =
      _$MonthlyFlowEntityCopyWithImpl<$Res, MonthlyFlowEntity>;
  @useResult
  $Res call({int month, int year, double totalSpent, double totalIncome});
}

/// @nodoc
class _$MonthlyFlowEntityCopyWithImpl<$Res, $Val extends MonthlyFlowEntity>
    implements $MonthlyFlowEntityCopyWith<$Res> {
  _$MonthlyFlowEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyFlowEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? year = null,
    Object? totalSpent = null,
    Object? totalIncome = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyFlowEntityImplCopyWith<$Res>
    implements $MonthlyFlowEntityCopyWith<$Res> {
  factory _$$MonthlyFlowEntityImplCopyWith(_$MonthlyFlowEntityImpl value,
          $Res Function(_$MonthlyFlowEntityImpl) then) =
      __$$MonthlyFlowEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int month, int year, double totalSpent, double totalIncome});
}

/// @nodoc
class __$$MonthlyFlowEntityImplCopyWithImpl<$Res>
    extends _$MonthlyFlowEntityCopyWithImpl<$Res, _$MonthlyFlowEntityImpl>
    implements _$$MonthlyFlowEntityImplCopyWith<$Res> {
  __$$MonthlyFlowEntityImplCopyWithImpl(_$MonthlyFlowEntityImpl _value,
      $Res Function(_$MonthlyFlowEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyFlowEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? year = null,
    Object? totalSpent = null,
    Object? totalIncome = null,
  }) {
    return _then(_$MonthlyFlowEntityImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$MonthlyFlowEntityImpl extends _MonthlyFlowEntity {
  const _$MonthlyFlowEntityImpl(
      {required this.month,
      required this.year,
      this.totalSpent = 0.0,
      this.totalIncome = 0.0})
      : super._();

  @override
  final int month;
  @override
  final int year;
  @override
  @JsonKey()
  final double totalSpent;
  @override
  @JsonKey()
  final double totalIncome;

  @override
  String toString() {
    return 'MonthlyFlowEntity(month: $month, year: $year, totalSpent: $totalSpent, totalIncome: $totalIncome)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyFlowEntityImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, month, year, totalSpent, totalIncome);

  /// Create a copy of MonthlyFlowEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyFlowEntityImplCopyWith<_$MonthlyFlowEntityImpl> get copyWith =>
      __$$MonthlyFlowEntityImplCopyWithImpl<_$MonthlyFlowEntityImpl>(
          this, _$identity);
}

abstract class _MonthlyFlowEntity extends MonthlyFlowEntity {
  const factory _MonthlyFlowEntity(
      {required final int month,
      required final int year,
      final double totalSpent,
      final double totalIncome}) = _$MonthlyFlowEntityImpl;
  const _MonthlyFlowEntity._() : super._();

  @override
  int get month;
  @override
  int get year;
  @override
  double get totalSpent;
  @override
  double get totalIncome;

  /// Create a copy of MonthlyFlowEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyFlowEntityImplCopyWith<_$MonthlyFlowEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
