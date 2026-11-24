// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoalUiState {
  bool get isLoading; // 약·걸음·일정이 모두 비어 있어도 정상 응답이라, 실패는 따로 표시한다.
  bool get hasError;
  int? get point;
  Medication? get medicine;
  int get stepGoal;
  List<DailyHealthSchedule> get visits;

  /// Create a copy of GoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalUiStateCopyWith<GoalUiState> get copyWith =>
      _$GoalUiStateCopyWithImpl<GoalUiState>(this as GoalUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasError, hasError) ||
                other.hasError == hasError) &&
            (identical(other.point, point) || other.point == point) &&
            (identical(other.medicine, medicine) ||
                other.medicine == medicine) &&
            (identical(other.stepGoal, stepGoal) ||
                other.stepGoal == stepGoal) &&
            const DeepCollectionEquality().equals(other.visits, visits));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, hasError, point,
      medicine, stepGoal, const DeepCollectionEquality().hash(visits));

  @override
  String toString() {
    return 'GoalUiState(isLoading: $isLoading, hasError: $hasError, point: $point, medicine: $medicine, stepGoal: $stepGoal, visits: $visits)';
  }
}

/// @nodoc
abstract mixin class $GoalUiStateCopyWith<$Res> {
  factory $GoalUiStateCopyWith(
          GoalUiState value, $Res Function(GoalUiState) _then) =
      _$GoalUiStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      bool hasError,
      int? point,
      Medication? medicine,
      int stepGoal,
      List<DailyHealthSchedule> visits});

  $MedicationCopyWith<$Res>? get medicine;
}

/// @nodoc
class _$GoalUiStateCopyWithImpl<$Res> implements $GoalUiStateCopyWith<$Res> {
  _$GoalUiStateCopyWithImpl(this._self, this._then);

  final GoalUiState _self;
  final $Res Function(GoalUiState) _then;

  /// Create a copy of GoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? hasError = null,
    Object? point = freezed,
    Object? medicine = freezed,
    Object? stepGoal = null,
    Object? visits = null,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasError: null == hasError
          ? _self.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
      point: freezed == point
          ? _self.point
          : point // ignore: cast_nullable_to_non_nullable
              as int?,
      medicine: freezed == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medication?,
      stepGoal: null == stepGoal
          ? _self.stepGoal
          : stepGoal // ignore: cast_nullable_to_non_nullable
              as int,
      visits: null == visits
          ? _self.visits
          : visits // ignore: cast_nullable_to_non_nullable
              as List<DailyHealthSchedule>,
    ));
  }

  /// Create a copy of GoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationCopyWith<$Res>? get medicine {
    if (_self.medicine == null) {
      return null;
    }

    return $MedicationCopyWith<$Res>(_self.medicine!, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GoalUiState].
extension GoalUiStatePatterns on GoalUiState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GoalUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalUiState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GoalUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalUiState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GoalUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalUiState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            bool isLoading,
            bool hasError,
            int? point,
            Medication? medicine,
            int stepGoal,
            List<DailyHealthSchedule> visits)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalUiState() when $default != null:
        return $default(_that.isLoading, _that.hasError, _that.point,
            _that.medicine, _that.stepGoal, _that.visits);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            bool isLoading,
            bool hasError,
            int? point,
            Medication? medicine,
            int stepGoal,
            List<DailyHealthSchedule> visits)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalUiState():
        return $default(_that.isLoading, _that.hasError, _that.point,
            _that.medicine, _that.stepGoal, _that.visits);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            bool isLoading,
            bool hasError,
            int? point,
            Medication? medicine,
            int stepGoal,
            List<DailyHealthSchedule> visits)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalUiState() when $default != null:
        return $default(_that.isLoading, _that.hasError, _that.point,
            _that.medicine, _that.stepGoal, _that.visits);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GoalUiState extends GoalUiState {
  const _GoalUiState(
      {this.isLoading = true,
      this.hasError = false,
      this.point,
      this.medicine,
      this.stepGoal = 0,
      final List<DailyHealthSchedule> visits = const []})
      : _visits = visits,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
// 약·걸음·일정이 모두 비어 있어도 정상 응답이라, 실패는 따로 표시한다.
  @override
  @JsonKey()
  final bool hasError;
  @override
  final int? point;
  @override
  final Medication? medicine;
  @override
  @JsonKey()
  final int stepGoal;
  final List<DailyHealthSchedule> _visits;
  @override
  @JsonKey()
  List<DailyHealthSchedule> get visits {
    if (_visits is EqualUnmodifiableListView) return _visits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_visits);
  }

  /// Create a copy of GoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalUiStateCopyWith<_GoalUiState> get copyWith =>
      __$GoalUiStateCopyWithImpl<_GoalUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoalUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasError, hasError) ||
                other.hasError == hasError) &&
            (identical(other.point, point) || other.point == point) &&
            (identical(other.medicine, medicine) ||
                other.medicine == medicine) &&
            (identical(other.stepGoal, stepGoal) ||
                other.stepGoal == stepGoal) &&
            const DeepCollectionEquality().equals(other._visits, _visits));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, hasError, point,
      medicine, stepGoal, const DeepCollectionEquality().hash(_visits));

  @override
  String toString() {
    return 'GoalUiState(isLoading: $isLoading, hasError: $hasError, point: $point, medicine: $medicine, stepGoal: $stepGoal, visits: $visits)';
  }
}

/// @nodoc
abstract mixin class _$GoalUiStateCopyWith<$Res>
    implements $GoalUiStateCopyWith<$Res> {
  factory _$GoalUiStateCopyWith(
          _GoalUiState value, $Res Function(_GoalUiState) _then) =
      __$GoalUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool hasError,
      int? point,
      Medication? medicine,
      int stepGoal,
      List<DailyHealthSchedule> visits});

  @override
  $MedicationCopyWith<$Res>? get medicine;
}

/// @nodoc
class __$GoalUiStateCopyWithImpl<$Res> implements _$GoalUiStateCopyWith<$Res> {
  __$GoalUiStateCopyWithImpl(this._self, this._then);

  final _GoalUiState _self;
  final $Res Function(_GoalUiState) _then;

  /// Create a copy of GoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? hasError = null,
    Object? point = freezed,
    Object? medicine = freezed,
    Object? stepGoal = null,
    Object? visits = null,
  }) {
    return _then(_GoalUiState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasError: null == hasError
          ? _self.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
      point: freezed == point
          ? _self.point
          : point // ignore: cast_nullable_to_non_nullable
              as int?,
      medicine: freezed == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medication?,
      stepGoal: null == stepGoal
          ? _self.stepGoal
          : stepGoal // ignore: cast_nullable_to_non_nullable
              as int,
      visits: null == visits
          ? _self._visits
          : visits // ignore: cast_nullable_to_non_nullable
              as List<DailyHealthSchedule>,
    ));
  }

  /// Create a copy of GoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationCopyWith<$Res>? get medicine {
    if (_self.medicine == null) {
      return null;
    }

    return $MedicationCopyWith<$Res>(_self.medicine!, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }
}

// dart format on
