// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecommendationEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  RecommendationType get type => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationEntityCopyWith<RecommendationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationEntityCopyWith<$Res> {
  factory $RecommendationEntityCopyWith(RecommendationEntity value,
          $Res Function(RecommendationEntity) then) =
      _$RecommendationEntityCopyWithImpl<$Res, RecommendationEntity>;
  @useResult
  $Res call(
      {String id, String title, String description, RecommendationType type});
}

/// @nodoc
class _$RecommendationEntityCopyWithImpl<$Res,
        $Val extends RecommendationEntity>
    implements $RecommendationEntityCopyWith<$Res> {
  _$RecommendationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RecommendationType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationEntityImplCopyWith<$Res>
    implements $RecommendationEntityCopyWith<$Res> {
  factory _$$RecommendationEntityImplCopyWith(_$RecommendationEntityImpl value,
          $Res Function(_$RecommendationEntityImpl) then) =
      __$$RecommendationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String title, String description, RecommendationType type});
}

/// @nodoc
class __$$RecommendationEntityImplCopyWithImpl<$Res>
    extends _$RecommendationEntityCopyWithImpl<$Res, _$RecommendationEntityImpl>
    implements _$$RecommendationEntityImplCopyWith<$Res> {
  __$$RecommendationEntityImplCopyWithImpl(_$RecommendationEntityImpl _value,
      $Res Function(_$RecommendationEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
  }) {
    return _then(_$RecommendationEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RecommendationType,
    ));
  }
}

/// @nodoc

class _$RecommendationEntityImpl implements _RecommendationEntity {
  const _$RecommendationEntityImpl(
      {required this.id,
      required this.title,
      required this.description,
      this.type = RecommendationType.general});

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey()
  final RecommendationType type;

  @override
  String toString() {
    return 'RecommendationEntity(id: $id, title: $title, description: $description, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, type);

  /// Create a copy of RecommendationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationEntityImplCopyWith<_$RecommendationEntityImpl>
      get copyWith =>
          __$$RecommendationEntityImplCopyWithImpl<_$RecommendationEntityImpl>(
              this, _$identity);
}

abstract class _RecommendationEntity implements RecommendationEntity {
  const factory _RecommendationEntity(
      {required final String id,
      required final String title,
      required final String description,
      final RecommendationType type}) = _$RecommendationEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  RecommendationType get type;

  /// Create a copy of RecommendationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationEntityImplCopyWith<_$RecommendationEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
