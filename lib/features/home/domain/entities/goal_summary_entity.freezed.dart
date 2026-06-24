// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_summary_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GoalSummaryEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get savedAmount => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  /// Create a copy of GoalSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalSummaryEntityCopyWith<GoalSummaryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalSummaryEntityCopyWith<$Res> {
  factory $GoalSummaryEntityCopyWith(
          GoalSummaryEntity value, $Res Function(GoalSummaryEntity) then) =
      _$GoalSummaryEntityCopyWithImpl<$Res, GoalSummaryEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      double savedAmount,
      double targetAmount,
      String category});
}

/// @nodoc
class _$GoalSummaryEntityCopyWithImpl<$Res, $Val extends GoalSummaryEntity>
    implements $GoalSummaryEntityCopyWith<$Res> {
  _$GoalSummaryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? savedAmount = null,
    Object? targetAmount = null,
    Object? category = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      savedAmount: null == savedAmount
          ? _value.savedAmount
          : savedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalSummaryEntityImplCopyWith<$Res>
    implements $GoalSummaryEntityCopyWith<$Res> {
  factory _$$GoalSummaryEntityImplCopyWith(_$GoalSummaryEntityImpl value,
          $Res Function(_$GoalSummaryEntityImpl) then) =
      __$$GoalSummaryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      double savedAmount,
      double targetAmount,
      String category});
}

/// @nodoc
class __$$GoalSummaryEntityImplCopyWithImpl<$Res>
    extends _$GoalSummaryEntityCopyWithImpl<$Res, _$GoalSummaryEntityImpl>
    implements _$$GoalSummaryEntityImplCopyWith<$Res> {
  __$$GoalSummaryEntityImplCopyWithImpl(_$GoalSummaryEntityImpl _value,
      $Res Function(_$GoalSummaryEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? savedAmount = null,
    Object? targetAmount = null,
    Object? category = null,
  }) {
    return _then(_$GoalSummaryEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      savedAmount: null == savedAmount
          ? _value.savedAmount
          : savedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GoalSummaryEntityImpl extends _GoalSummaryEntity {
  const _$GoalSummaryEntityImpl(
      {required this.id,
      required this.title,
      required this.savedAmount,
      required this.targetAmount,
      required this.category})
      : super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final double savedAmount;
  @override
  final double targetAmount;
  @override
  final String category;

  @override
  String toString() {
    return 'GoalSummaryEntity(id: $id, title: $title, savedAmount: $savedAmount, targetAmount: $targetAmount, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalSummaryEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.savedAmount, savedAmount) ||
                other.savedAmount == savedAmount) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, savedAmount, targetAmount, category);

  /// Create a copy of GoalSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalSummaryEntityImplCopyWith<_$GoalSummaryEntityImpl> get copyWith =>
      __$$GoalSummaryEntityImplCopyWithImpl<_$GoalSummaryEntityImpl>(
          this, _$identity);
}

abstract class _GoalSummaryEntity extends GoalSummaryEntity {
  const factory _GoalSummaryEntity(
      {required final String id,
      required final String title,
      required final double savedAmount,
      required final double targetAmount,
      required final String category}) = _$GoalSummaryEntityImpl;
  const _GoalSummaryEntity._() : super._();

  @override
  String get id;
  @override
  String get title;
  @override
  double get savedAmount;
  @override
  double get targetAmount;
  @override
  String get category;

  /// Create a copy of GoalSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalSummaryEntityImplCopyWith<_$GoalSummaryEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
