// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GoalEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  double get savedAmount => throw _privateConstructorUsedError;
  DateTime get targetDate => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  List<ContributionEntity> get contributions =>
      throw _privateConstructorUsedError;

  /// Create a copy of GoalEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalEntityCopyWith<GoalEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalEntityCopyWith<$Res> {
  factory $GoalEntityCopyWith(
          GoalEntity value, $Res Function(GoalEntity) then) =
      _$GoalEntityCopyWithImpl<$Res, GoalEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      double targetAmount,
      double savedAmount,
      DateTime targetDate,
      String category,
      String emoji,
      String colorHex,
      bool isCompleted,
      DateTime? completedAt,
      DateTime? createdAt,
      List<ContributionEntity> contributions});
}

/// @nodoc
class _$GoalEntityCopyWithImpl<$Res, $Val extends GoalEntity>
    implements $GoalEntityCopyWith<$Res> {
  _$GoalEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetAmount = null,
    Object? savedAmount = null,
    Object? targetDate = null,
    Object? category = null,
    Object? emoji = null,
    Object? colorHex = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? contributions = null,
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
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      savedAmount: null == savedAmount
          ? _value.savedAmount
          : savedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contributions: null == contributions
          ? _value.contributions
          : contributions // ignore: cast_nullable_to_non_nullable
              as List<ContributionEntity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalEntityImplCopyWith<$Res>
    implements $GoalEntityCopyWith<$Res> {
  factory _$$GoalEntityImplCopyWith(
          _$GoalEntityImpl value, $Res Function(_$GoalEntityImpl) then) =
      __$$GoalEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      double targetAmount,
      double savedAmount,
      DateTime targetDate,
      String category,
      String emoji,
      String colorHex,
      bool isCompleted,
      DateTime? completedAt,
      DateTime? createdAt,
      List<ContributionEntity> contributions});
}

/// @nodoc
class __$$GoalEntityImplCopyWithImpl<$Res>
    extends _$GoalEntityCopyWithImpl<$Res, _$GoalEntityImpl>
    implements _$$GoalEntityImplCopyWith<$Res> {
  __$$GoalEntityImplCopyWithImpl(
      _$GoalEntityImpl _value, $Res Function(_$GoalEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetAmount = null,
    Object? savedAmount = null,
    Object? targetDate = null,
    Object? category = null,
    Object? emoji = null,
    Object? colorHex = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? contributions = null,
  }) {
    return _then(_$GoalEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      savedAmount: null == savedAmount
          ? _value.savedAmount
          : savedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contributions: null == contributions
          ? _value._contributions
          : contributions // ignore: cast_nullable_to_non_nullable
              as List<ContributionEntity>,
    ));
  }
}

/// @nodoc

class _$GoalEntityImpl extends _GoalEntity {
  const _$GoalEntityImpl(
      {required this.id,
      required this.title,
      required this.targetAmount,
      this.savedAmount = 0.0,
      required this.targetDate,
      this.category = 'Other',
      this.emoji = '🎯',
      this.colorHex = '#C1622A',
      this.isCompleted = false,
      this.completedAt,
      this.createdAt,
      final List<ContributionEntity> contributions =
          const <ContributionEntity>[]})
      : _contributions = contributions,
        super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final double targetAmount;
  @override
  @JsonKey()
  final double savedAmount;
  @override
  final DateTime targetDate;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String emoji;
  @override
  @JsonKey()
  final String colorHex;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? createdAt;
  final List<ContributionEntity> _contributions;
  @override
  @JsonKey()
  List<ContributionEntity> get contributions {
    if (_contributions is EqualUnmodifiableListView) return _contributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contributions);
  }

  @override
  String toString() {
    return 'GoalEntity(id: $id, title: $title, targetAmount: $targetAmount, savedAmount: $savedAmount, targetDate: $targetDate, category: $category, emoji: $emoji, colorHex: $colorHex, isCompleted: $isCompleted, completedAt: $completedAt, createdAt: $createdAt, contributions: $contributions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.savedAmount, savedAmount) ||
                other.savedAmount == savedAmount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._contributions, _contributions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      targetAmount,
      savedAmount,
      targetDate,
      category,
      emoji,
      colorHex,
      isCompleted,
      completedAt,
      createdAt,
      const DeepCollectionEquality().hash(_contributions));

  /// Create a copy of GoalEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalEntityImplCopyWith<_$GoalEntityImpl> get copyWith =>
      __$$GoalEntityImplCopyWithImpl<_$GoalEntityImpl>(this, _$identity);
}

abstract class _GoalEntity extends GoalEntity {
  const factory _GoalEntity(
      {required final String id,
      required final String title,
      required final double targetAmount,
      final double savedAmount,
      required final DateTime targetDate,
      final String category,
      final String emoji,
      final String colorHex,
      final bool isCompleted,
      final DateTime? completedAt,
      final DateTime? createdAt,
      final List<ContributionEntity> contributions}) = _$GoalEntityImpl;
  const _GoalEntity._() : super._();

  @override
  String get id;
  @override
  String get title;
  @override
  double get targetAmount;
  @override
  double get savedAmount;
  @override
  DateTime get targetDate;
  @override
  String get category;
  @override
  String get emoji;
  @override
  String get colorHex;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get createdAt;
  @override
  List<ContributionEntity> get contributions;

  /// Create a copy of GoalEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalEntityImplCopyWith<_$GoalEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
