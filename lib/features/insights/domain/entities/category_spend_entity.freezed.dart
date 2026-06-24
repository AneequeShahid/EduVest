// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_spend_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategorySpendEntity {
  String get category => throw _privateConstructorUsedError;
  double get totalSpent => throw _privateConstructorUsedError;
  double get percentOfTotal => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;

  /// Create a copy of CategorySpendEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorySpendEntityCopyWith<CategorySpendEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySpendEntityCopyWith<$Res> {
  factory $CategorySpendEntityCopyWith(
          CategorySpendEntity value, $Res Function(CategorySpendEntity) then) =
      _$CategorySpendEntityCopyWithImpl<$Res, CategorySpendEntity>;
  @useResult
  $Res call(
      {String category,
      double totalSpent,
      double percentOfTotal,
      String colorHex});
}

/// @nodoc
class _$CategorySpendEntityCopyWithImpl<$Res, $Val extends CategorySpendEntity>
    implements $CategorySpendEntityCopyWith<$Res> {
  _$CategorySpendEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategorySpendEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? totalSpent = null,
    Object? percentOfTotal = null,
    Object? colorHex = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      percentOfTotal: null == percentOfTotal
          ? _value.percentOfTotal
          : percentOfTotal // ignore: cast_nullable_to_non_nullable
              as double,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategorySpendEntityImplCopyWith<$Res>
    implements $CategorySpendEntityCopyWith<$Res> {
  factory _$$CategorySpendEntityImplCopyWith(_$CategorySpendEntityImpl value,
          $Res Function(_$CategorySpendEntityImpl) then) =
      __$$CategorySpendEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String category,
      double totalSpent,
      double percentOfTotal,
      String colorHex});
}

/// @nodoc
class __$$CategorySpendEntityImplCopyWithImpl<$Res>
    extends _$CategorySpendEntityCopyWithImpl<$Res, _$CategorySpendEntityImpl>
    implements _$$CategorySpendEntityImplCopyWith<$Res> {
  __$$CategorySpendEntityImplCopyWithImpl(_$CategorySpendEntityImpl _value,
      $Res Function(_$CategorySpendEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategorySpendEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? totalSpent = null,
    Object? percentOfTotal = null,
    Object? colorHex = null,
  }) {
    return _then(_$CategorySpendEntityImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      percentOfTotal: null == percentOfTotal
          ? _value.percentOfTotal
          : percentOfTotal // ignore: cast_nullable_to_non_nullable
              as double,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CategorySpendEntityImpl implements _CategorySpendEntity {
  const _$CategorySpendEntityImpl(
      {required this.category,
      required this.totalSpent,
      required this.percentOfTotal,
      this.colorHex = '#C1622A'});

  @override
  final String category;
  @override
  final double totalSpent;
  @override
  final double percentOfTotal;
  @override
  @JsonKey()
  final String colorHex;

  @override
  String toString() {
    return 'CategorySpendEntity(category: $category, totalSpent: $totalSpent, percentOfTotal: $percentOfTotal, colorHex: $colorHex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySpendEntityImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.percentOfTotal, percentOfTotal) ||
                other.percentOfTotal == percentOfTotal) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, category, totalSpent, percentOfTotal, colorHex);

  /// Create a copy of CategorySpendEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySpendEntityImplCopyWith<_$CategorySpendEntityImpl> get copyWith =>
      __$$CategorySpendEntityImplCopyWithImpl<_$CategorySpendEntityImpl>(
          this, _$identity);
}

abstract class _CategorySpendEntity implements CategorySpendEntity {
  const factory _CategorySpendEntity(
      {required final String category,
      required final double totalSpent,
      required final double percentOfTotal,
      final String colorHex}) = _$CategorySpendEntityImpl;

  @override
  String get category;
  @override
  double get totalSpent;
  @override
  double get percentOfTotal;
  @override
  String get colorHex;

  /// Create a copy of CategorySpendEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySpendEntityImplCopyWith<_$CategorySpendEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
