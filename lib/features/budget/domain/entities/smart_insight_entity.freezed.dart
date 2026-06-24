// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_insight_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SmartInsightEntity {
  SmartInsightType get type => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool get isGroceryRelated => throw _privateConstructorUsedError;

  /// Create a copy of SmartInsightEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartInsightEntityCopyWith<SmartInsightEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartInsightEntityCopyWith<$Res> {
  factory $SmartInsightEntityCopyWith(
          SmartInsightEntity value, $Res Function(SmartInsightEntity) then) =
      _$SmartInsightEntityCopyWithImpl<$Res, SmartInsightEntity>;
  @useResult
  $Res call(
      {SmartInsightType type,
      String message,
      String? category,
      bool isGroceryRelated});
}

/// @nodoc
class _$SmartInsightEntityCopyWithImpl<$Res, $Val extends SmartInsightEntity>
    implements $SmartInsightEntityCopyWith<$Res> {
  _$SmartInsightEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartInsightEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = null,
    Object? category = freezed,
    Object? isGroceryRelated = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SmartInsightType,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isGroceryRelated: null == isGroceryRelated
          ? _value.isGroceryRelated
          : isGroceryRelated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmartInsightEntityImplCopyWith<$Res>
    implements $SmartInsightEntityCopyWith<$Res> {
  factory _$$SmartInsightEntityImplCopyWith(_$SmartInsightEntityImpl value,
          $Res Function(_$SmartInsightEntityImpl) then) =
      __$$SmartInsightEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SmartInsightType type,
      String message,
      String? category,
      bool isGroceryRelated});
}

/// @nodoc
class __$$SmartInsightEntityImplCopyWithImpl<$Res>
    extends _$SmartInsightEntityCopyWithImpl<$Res, _$SmartInsightEntityImpl>
    implements _$$SmartInsightEntityImplCopyWith<$Res> {
  __$$SmartInsightEntityImplCopyWithImpl(_$SmartInsightEntityImpl _value,
      $Res Function(_$SmartInsightEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of SmartInsightEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = null,
    Object? category = freezed,
    Object? isGroceryRelated = null,
  }) {
    return _then(_$SmartInsightEntityImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SmartInsightType,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isGroceryRelated: null == isGroceryRelated
          ? _value.isGroceryRelated
          : isGroceryRelated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SmartInsightEntityImpl implements _SmartInsightEntity {
  const _$SmartInsightEntityImpl(
      {required this.type,
      required this.message,
      this.category,
      this.isGroceryRelated = false});

  @override
  final SmartInsightType type;
  @override
  final String message;
  @override
  final String? category;
  @override
  @JsonKey()
  final bool isGroceryRelated;

  @override
  String toString() {
    return 'SmartInsightEntity(type: $type, message: $message, category: $category, isGroceryRelated: $isGroceryRelated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartInsightEntityImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isGroceryRelated, isGroceryRelated) ||
                other.isGroceryRelated == isGroceryRelated));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, type, message, category, isGroceryRelated);

  /// Create a copy of SmartInsightEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartInsightEntityImplCopyWith<_$SmartInsightEntityImpl> get copyWith =>
      __$$SmartInsightEntityImplCopyWithImpl<_$SmartInsightEntityImpl>(
          this, _$identity);
}

abstract class _SmartInsightEntity implements SmartInsightEntity {
  const factory _SmartInsightEntity(
      {required final SmartInsightType type,
      required final String message,
      final String? category,
      final bool isGroceryRelated}) = _$SmartInsightEntityImpl;

  @override
  SmartInsightType get type;
  @override
  String get message;
  @override
  String? get category;
  @override
  bool get isGroceryRelated;

  /// Create a copy of SmartInsightEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartInsightEntityImplCopyWith<_$SmartInsightEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
