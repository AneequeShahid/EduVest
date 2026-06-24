// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_category_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetCategoryEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get limit => throw _privateConstructorUsedError;
  double get spent => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  bool get isPaid => throw _privateConstructorUsedError;

  /// Create a copy of BudgetCategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetCategoryEntityCopyWith<BudgetCategoryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetCategoryEntityCopyWith<$Res> {
  factory $BudgetCategoryEntityCopyWith(BudgetCategoryEntity value,
          $Res Function(BudgetCategoryEntity) then) =
      _$BudgetCategoryEntityCopyWithImpl<$Res, BudgetCategoryEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      double limit,
      double spent,
      String icon,
      String color,
      bool isPaid});
}

/// @nodoc
class _$BudgetCategoryEntityCopyWithImpl<$Res,
        $Val extends BudgetCategoryEntity>
    implements $BudgetCategoryEntityCopyWith<$Res> {
  _$BudgetCategoryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetCategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? limit = null,
    Object? spent = null,
    Object? icon = null,
    Object? color = null,
    Object? isPaid = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      spent: null == spent
          ? _value.spent
          : spent // ignore: cast_nullable_to_non_nullable
              as double,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetCategoryEntityImplCopyWith<$Res>
    implements $BudgetCategoryEntityCopyWith<$Res> {
  factory _$$BudgetCategoryEntityImplCopyWith(_$BudgetCategoryEntityImpl value,
          $Res Function(_$BudgetCategoryEntityImpl) then) =
      __$$BudgetCategoryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double limit,
      double spent,
      String icon,
      String color,
      bool isPaid});
}

/// @nodoc
class __$$BudgetCategoryEntityImplCopyWithImpl<$Res>
    extends _$BudgetCategoryEntityCopyWithImpl<$Res, _$BudgetCategoryEntityImpl>
    implements _$$BudgetCategoryEntityImplCopyWith<$Res> {
  __$$BudgetCategoryEntityImplCopyWithImpl(_$BudgetCategoryEntityImpl _value,
      $Res Function(_$BudgetCategoryEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetCategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? limit = null,
    Object? spent = null,
    Object? icon = null,
    Object? color = null,
    Object? isPaid = null,
  }) {
    return _then(_$BudgetCategoryEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      spent: null == spent
          ? _value.spent
          : spent // ignore: cast_nullable_to_non_nullable
              as double,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BudgetCategoryEntityImpl extends _BudgetCategoryEntity {
  const _$BudgetCategoryEntityImpl(
      {required this.id,
      required this.name,
      required this.limit,
      this.spent = 0.0,
      this.icon = '',
      this.color = '#C1622A',
      this.isPaid = false})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final double limit;
  @override
  @JsonKey()
  final double spent;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final String color;
  @override
  @JsonKey()
  final bool isPaid;

  @override
  String toString() {
    return 'BudgetCategoryEntity(id: $id, name: $name, limit: $limit, spent: $spent, icon: $icon, color: $color, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetCategoryEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.spent, spent) || other.spent == spent) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, limit, spent, icon, color, isPaid);

  /// Create a copy of BudgetCategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetCategoryEntityImplCopyWith<_$BudgetCategoryEntityImpl>
      get copyWith =>
          __$$BudgetCategoryEntityImplCopyWithImpl<_$BudgetCategoryEntityImpl>(
              this, _$identity);
}

abstract class _BudgetCategoryEntity extends BudgetCategoryEntity {
  const factory _BudgetCategoryEntity(
      {required final String id,
      required final String name,
      required final double limit,
      final double spent,
      final String icon,
      final String color,
      final bool isPaid}) = _$BudgetCategoryEntityImpl;
  const _BudgetCategoryEntity._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  double get limit;
  @override
  double get spent;
  @override
  String get icon;
  @override
  String get color;
  @override
  bool get isPaid;

  /// Create a copy of BudgetCategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetCategoryEntityImplCopyWith<_$BudgetCategoryEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
