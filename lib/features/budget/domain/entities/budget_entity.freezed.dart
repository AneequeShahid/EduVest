// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetEntity {
  int get month => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  double get totalLimit => throw _privateConstructorUsedError;
  double get totalSpent => throw _privateConstructorUsedError;
  int get daysInMonth => throw _privateConstructorUsedError;
  List<BudgetCategoryEntity> get categories =>
      throw _privateConstructorUsedError;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetEntityCopyWith<BudgetEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetEntityCopyWith<$Res> {
  factory $BudgetEntityCopyWith(
          BudgetEntity value, $Res Function(BudgetEntity) then) =
      _$BudgetEntityCopyWithImpl<$Res, BudgetEntity>;
  @useResult
  $Res call(
      {int month,
      int year,
      double totalLimit,
      double totalSpent,
      int daysInMonth,
      List<BudgetCategoryEntity> categories});
}

/// @nodoc
class _$BudgetEntityCopyWithImpl<$Res, $Val extends BudgetEntity>
    implements $BudgetEntityCopyWith<$Res> {
  _$BudgetEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? year = null,
    Object? totalLimit = null,
    Object? totalSpent = null,
    Object? daysInMonth = null,
    Object? categories = null,
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
      totalLimit: null == totalLimit
          ? _value.totalLimit
          : totalLimit // ignore: cast_nullable_to_non_nullable
              as double,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      daysInMonth: null == daysInMonth
          ? _value.daysInMonth
          : daysInMonth // ignore: cast_nullable_to_non_nullable
              as int,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<BudgetCategoryEntity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetEntityImplCopyWith<$Res>
    implements $BudgetEntityCopyWith<$Res> {
  factory _$$BudgetEntityImplCopyWith(
          _$BudgetEntityImpl value, $Res Function(_$BudgetEntityImpl) then) =
      __$$BudgetEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int month,
      int year,
      double totalLimit,
      double totalSpent,
      int daysInMonth,
      List<BudgetCategoryEntity> categories});
}

/// @nodoc
class __$$BudgetEntityImplCopyWithImpl<$Res>
    extends _$BudgetEntityCopyWithImpl<$Res, _$BudgetEntityImpl>
    implements _$$BudgetEntityImplCopyWith<$Res> {
  __$$BudgetEntityImplCopyWithImpl(
      _$BudgetEntityImpl _value, $Res Function(_$BudgetEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? year = null,
    Object? totalLimit = null,
    Object? totalSpent = null,
    Object? daysInMonth = null,
    Object? categories = null,
  }) {
    return _then(_$BudgetEntityImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      totalLimit: null == totalLimit
          ? _value.totalLimit
          : totalLimit // ignore: cast_nullable_to_non_nullable
              as double,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      daysInMonth: null == daysInMonth
          ? _value.daysInMonth
          : daysInMonth // ignore: cast_nullable_to_non_nullable
              as int,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<BudgetCategoryEntity>,
    ));
  }
}

/// @nodoc

class _$BudgetEntityImpl extends _BudgetEntity {
  const _$BudgetEntityImpl(
      {required this.month,
      required this.year,
      required this.totalLimit,
      required this.totalSpent,
      required this.daysInMonth,
      final List<BudgetCategoryEntity> categories =
          const <BudgetCategoryEntity>[]})
      : _categories = categories,
        super._();

  @override
  final int month;
  @override
  final int year;
  @override
  final double totalLimit;
  @override
  final double totalSpent;
  @override
  final int daysInMonth;
  final List<BudgetCategoryEntity> _categories;
  @override
  @JsonKey()
  List<BudgetCategoryEntity> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'BudgetEntity(month: $month, year: $year, totalLimit: $totalLimit, totalSpent: $totalSpent, daysInMonth: $daysInMonth, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetEntityImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.totalLimit, totalLimit) ||
                other.totalLimit == totalLimit) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.daysInMonth, daysInMonth) ||
                other.daysInMonth == daysInMonth) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      month,
      year,
      totalLimit,
      totalSpent,
      daysInMonth,
      const DeepCollectionEquality().hash(_categories));

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetEntityImplCopyWith<_$BudgetEntityImpl> get copyWith =>
      __$$BudgetEntityImplCopyWithImpl<_$BudgetEntityImpl>(this, _$identity);
}

abstract class _BudgetEntity extends BudgetEntity {
  const factory _BudgetEntity(
      {required final int month,
      required final int year,
      required final double totalLimit,
      required final double totalSpent,
      required final int daysInMonth,
      final List<BudgetCategoryEntity> categories}) = _$BudgetEntityImpl;
  const _BudgetEntity._() : super._();

  @override
  int get month;
  @override
  int get year;
  @override
  double get totalLimit;
  @override
  double get totalSpent;
  @override
  int get daysInMonth;
  @override
  List<BudgetCategoryEntity> get categories;

  /// Create a copy of BudgetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetEntityImplCopyWith<_$BudgetEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
