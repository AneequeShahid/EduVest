// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardEntity {
  double get totalBalance => throw _privateConstructorUsedError;
  double get monthlyBudgetLimit => throw _privateConstructorUsedError;
  double get monthlySpent => throw _privateConstructorUsedError;
  List<TransactionEntity> get recentTransactions =>
      throw _privateConstructorUsedError;
  GoalSummaryEntity? get activeGoal => throw _privateConstructorUsedError;
  double get balanceChangePercent => throw _privateConstructorUsedError;

  /// Create a copy of DashboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardEntityCopyWith<DashboardEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardEntityCopyWith<$Res> {
  factory $DashboardEntityCopyWith(
          DashboardEntity value, $Res Function(DashboardEntity) then) =
      _$DashboardEntityCopyWithImpl<$Res, DashboardEntity>;
  @useResult
  $Res call(
      {double totalBalance,
      double monthlyBudgetLimit,
      double monthlySpent,
      List<TransactionEntity> recentTransactions,
      GoalSummaryEntity? activeGoal,
      double balanceChangePercent});

  $GoalSummaryEntityCopyWith<$Res>? get activeGoal;
}

/// @nodoc
class _$DashboardEntityCopyWithImpl<$Res, $Val extends DashboardEntity>
    implements $DashboardEntityCopyWith<$Res> {
  _$DashboardEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBalance = null,
    Object? monthlyBudgetLimit = null,
    Object? monthlySpent = null,
    Object? recentTransactions = null,
    Object? activeGoal = freezed,
    Object? balanceChangePercent = null,
  }) {
    return _then(_value.copyWith(
      totalBalance: null == totalBalance
          ? _value.totalBalance
          : totalBalance // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyBudgetLimit: null == monthlyBudgetLimit
          ? _value.monthlyBudgetLimit
          : monthlyBudgetLimit // ignore: cast_nullable_to_non_nullable
              as double,
      monthlySpent: null == monthlySpent
          ? _value.monthlySpent
          : monthlySpent // ignore: cast_nullable_to_non_nullable
              as double,
      recentTransactions: null == recentTransactions
          ? _value.recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionEntity>,
      activeGoal: freezed == activeGoal
          ? _value.activeGoal
          : activeGoal // ignore: cast_nullable_to_non_nullable
              as GoalSummaryEntity?,
      balanceChangePercent: null == balanceChangePercent
          ? _value.balanceChangePercent
          : balanceChangePercent // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of DashboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GoalSummaryEntityCopyWith<$Res>? get activeGoal {
    if (_value.activeGoal == null) {
      return null;
    }

    return $GoalSummaryEntityCopyWith<$Res>(_value.activeGoal!, (value) {
      return _then(_value.copyWith(activeGoal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardEntityImplCopyWith<$Res>
    implements $DashboardEntityCopyWith<$Res> {
  factory _$$DashboardEntityImplCopyWith(_$DashboardEntityImpl value,
          $Res Function(_$DashboardEntityImpl) then) =
      __$$DashboardEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double totalBalance,
      double monthlyBudgetLimit,
      double monthlySpent,
      List<TransactionEntity> recentTransactions,
      GoalSummaryEntity? activeGoal,
      double balanceChangePercent});

  @override
  $GoalSummaryEntityCopyWith<$Res>? get activeGoal;
}

/// @nodoc
class __$$DashboardEntityImplCopyWithImpl<$Res>
    extends _$DashboardEntityCopyWithImpl<$Res, _$DashboardEntityImpl>
    implements _$$DashboardEntityImplCopyWith<$Res> {
  __$$DashboardEntityImplCopyWithImpl(
      _$DashboardEntityImpl _value, $Res Function(_$DashboardEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBalance = null,
    Object? monthlyBudgetLimit = null,
    Object? monthlySpent = null,
    Object? recentTransactions = null,
    Object? activeGoal = freezed,
    Object? balanceChangePercent = null,
  }) {
    return _then(_$DashboardEntityImpl(
      totalBalance: null == totalBalance
          ? _value.totalBalance
          : totalBalance // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyBudgetLimit: null == monthlyBudgetLimit
          ? _value.monthlyBudgetLimit
          : monthlyBudgetLimit // ignore: cast_nullable_to_non_nullable
              as double,
      monthlySpent: null == monthlySpent
          ? _value.monthlySpent
          : monthlySpent // ignore: cast_nullable_to_non_nullable
              as double,
      recentTransactions: null == recentTransactions
          ? _value._recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionEntity>,
      activeGoal: freezed == activeGoal
          ? _value.activeGoal
          : activeGoal // ignore: cast_nullable_to_non_nullable
              as GoalSummaryEntity?,
      balanceChangePercent: null == balanceChangePercent
          ? _value.balanceChangePercent
          : balanceChangePercent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$DashboardEntityImpl extends _DashboardEntity {
  const _$DashboardEntityImpl(
      {required this.totalBalance,
      required this.monthlyBudgetLimit,
      required this.monthlySpent,
      final List<TransactionEntity> recentTransactions =
          const <TransactionEntity>[],
      this.activeGoal,
      this.balanceChangePercent = 0.0})
      : _recentTransactions = recentTransactions,
        super._();

  @override
  final double totalBalance;
  @override
  final double monthlyBudgetLimit;
  @override
  final double monthlySpent;
  final List<TransactionEntity> _recentTransactions;
  @override
  @JsonKey()
  List<TransactionEntity> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

  @override
  final GoalSummaryEntity? activeGoal;
  @override
  @JsonKey()
  final double balanceChangePercent;

  @override
  String toString() {
    return 'DashboardEntity(totalBalance: $totalBalance, monthlyBudgetLimit: $monthlyBudgetLimit, monthlySpent: $monthlySpent, recentTransactions: $recentTransactions, activeGoal: $activeGoal, balanceChangePercent: $balanceChangePercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardEntityImpl &&
            (identical(other.totalBalance, totalBalance) ||
                other.totalBalance == totalBalance) &&
            (identical(other.monthlyBudgetLimit, monthlyBudgetLimit) ||
                other.monthlyBudgetLimit == monthlyBudgetLimit) &&
            (identical(other.monthlySpent, monthlySpent) ||
                other.monthlySpent == monthlySpent) &&
            const DeepCollectionEquality()
                .equals(other._recentTransactions, _recentTransactions) &&
            (identical(other.activeGoal, activeGoal) ||
                other.activeGoal == activeGoal) &&
            (identical(other.balanceChangePercent, balanceChangePercent) ||
                other.balanceChangePercent == balanceChangePercent));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalBalance,
      monthlyBudgetLimit,
      monthlySpent,
      const DeepCollectionEquality().hash(_recentTransactions),
      activeGoal,
      balanceChangePercent);

  /// Create a copy of DashboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardEntityImplCopyWith<_$DashboardEntityImpl> get copyWith =>
      __$$DashboardEntityImplCopyWithImpl<_$DashboardEntityImpl>(
          this, _$identity);
}

abstract class _DashboardEntity extends DashboardEntity {
  const factory _DashboardEntity(
      {required final double totalBalance,
      required final double monthlyBudgetLimit,
      required final double monthlySpent,
      final List<TransactionEntity> recentTransactions,
      final GoalSummaryEntity? activeGoal,
      final double balanceChangePercent}) = _$DashboardEntityImpl;
  const _DashboardEntity._() : super._();

  @override
  double get totalBalance;
  @override
  double get monthlyBudgetLimit;
  @override
  double get monthlySpent;
  @override
  List<TransactionEntity> get recentTransactions;
  @override
  GoalSummaryEntity? get activeGoal;
  @override
  double get balanceChangePercent;

  /// Create a copy of DashboardEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardEntityImplCopyWith<_$DashboardEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
