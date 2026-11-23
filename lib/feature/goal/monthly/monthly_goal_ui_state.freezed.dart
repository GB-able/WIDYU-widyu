// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_goal_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyGoalDay {
  DateTime get date;
  List<DailyMedicineSchedule> get medicines;
  List<DailyHealthSchedule>
      get healthSchedules; // 걷기 조회에 실패했거나 목표가 없던 날은 null이다.
  WalkDaily? get walk;

  /// Create a copy of MonthlyGoalDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthlyGoalDayCopyWith<MonthlyGoalDay> get copyWith =>
      _$MonthlyGoalDayCopyWithImpl<MonthlyGoalDay>(
          this as MonthlyGoalDay, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthlyGoalDay &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other.medicines, medicines) &&
            const DeepCollectionEquality()
                .equals(other.healthSchedules, healthSchedules) &&
            (identical(other.walk, walk) || other.walk == walk));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      const DeepCollectionEquality().hash(medicines),
      const DeepCollectionEquality().hash(healthSchedules),
      walk);

  @override
  String toString() {
    return 'MonthlyGoalDay(date: $date, medicines: $medicines, healthSchedules: $healthSchedules, walk: $walk)';
  }
}

/// @nodoc
abstract mixin class $MonthlyGoalDayCopyWith<$Res> {
  factory $MonthlyGoalDayCopyWith(
          MonthlyGoalDay value, $Res Function(MonthlyGoalDay) _then) =
      _$MonthlyGoalDayCopyWithImpl;
  @useResult
  $Res call(
      {DateTime date,
      List<DailyMedicineSchedule> medicines,
      List<DailyHealthSchedule> healthSchedules,
      WalkDaily? walk});

  $WalkDailyCopyWith<$Res>? get walk;
}

/// @nodoc
class _$MonthlyGoalDayCopyWithImpl<$Res>
    implements $MonthlyGoalDayCopyWith<$Res> {
  _$MonthlyGoalDayCopyWithImpl(this._self, this._then);

  final MonthlyGoalDay _self;
  final $Res Function(MonthlyGoalDay) _then;

  /// Create a copy of MonthlyGoalDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? medicines = null,
    Object? healthSchedules = null,
    Object? walk = freezed,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      medicines: null == medicines
          ? _self.medicines
          : medicines // ignore: cast_nullable_to_non_nullable
              as List<DailyMedicineSchedule>,
      healthSchedules: null == healthSchedules
          ? _self.healthSchedules
          : healthSchedules // ignore: cast_nullable_to_non_nullable
              as List<DailyHealthSchedule>,
      walk: freezed == walk
          ? _self.walk
          : walk // ignore: cast_nullable_to_non_nullable
              as WalkDaily?,
    ));
  }

  /// Create a copy of MonthlyGoalDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalkDailyCopyWith<$Res>? get walk {
    if (_self.walk == null) {
      return null;
    }

    return $WalkDailyCopyWith<$Res>(_self.walk!, (value) {
      return _then(_self.copyWith(walk: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MonthlyGoalDay].
extension MonthlyGoalDayPatterns on MonthlyGoalDay {
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
    TResult Function(_MonthlyGoalDay value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalDay() when $default != null:
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
    TResult Function(_MonthlyGoalDay value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalDay():
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
    TResult? Function(_MonthlyGoalDay value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalDay() when $default != null:
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
    TResult Function(DateTime date, List<DailyMedicineSchedule> medicines,
            List<DailyHealthSchedule> healthSchedules, WalkDaily? walk)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalDay() when $default != null:
        return $default(
            _that.date, _that.medicines, _that.healthSchedules, _that.walk);
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
    TResult Function(DateTime date, List<DailyMedicineSchedule> medicines,
            List<DailyHealthSchedule> healthSchedules, WalkDaily? walk)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalDay():
        return $default(
            _that.date, _that.medicines, _that.healthSchedules, _that.walk);
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
    TResult? Function(DateTime date, List<DailyMedicineSchedule> medicines,
            List<DailyHealthSchedule> healthSchedules, WalkDaily? walk)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalDay() when $default != null:
        return $default(
            _that.date, _that.medicines, _that.healthSchedules, _that.walk);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MonthlyGoalDay implements MonthlyGoalDay {
  const _MonthlyGoalDay(
      {required this.date,
      final List<DailyMedicineSchedule> medicines = const [],
      final List<DailyHealthSchedule> healthSchedules = const [],
      this.walk})
      : _medicines = medicines,
        _healthSchedules = healthSchedules;

  @override
  final DateTime date;
  final List<DailyMedicineSchedule> _medicines;
  @override
  @JsonKey()
  List<DailyMedicineSchedule> get medicines {
    if (_medicines is EqualUnmodifiableListView) return _medicines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medicines);
  }

  final List<DailyHealthSchedule> _healthSchedules;
  @override
  @JsonKey()
  List<DailyHealthSchedule> get healthSchedules {
    if (_healthSchedules is EqualUnmodifiableListView) return _healthSchedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthSchedules);
  }

// 걷기 조회에 실패했거나 목표가 없던 날은 null이다.
  @override
  final WalkDaily? walk;

  /// Create a copy of MonthlyGoalDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MonthlyGoalDayCopyWith<_MonthlyGoalDay> get copyWith =>
      __$MonthlyGoalDayCopyWithImpl<_MonthlyGoalDay>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthlyGoalDay &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._medicines, _medicines) &&
            const DeepCollectionEquality()
                .equals(other._healthSchedules, _healthSchedules) &&
            (identical(other.walk, walk) || other.walk == walk));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      const DeepCollectionEquality().hash(_medicines),
      const DeepCollectionEquality().hash(_healthSchedules),
      walk);

  @override
  String toString() {
    return 'MonthlyGoalDay(date: $date, medicines: $medicines, healthSchedules: $healthSchedules, walk: $walk)';
  }
}

/// @nodoc
abstract mixin class _$MonthlyGoalDayCopyWith<$Res>
    implements $MonthlyGoalDayCopyWith<$Res> {
  factory _$MonthlyGoalDayCopyWith(
          _MonthlyGoalDay value, $Res Function(_MonthlyGoalDay) _then) =
      __$MonthlyGoalDayCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime date,
      List<DailyMedicineSchedule> medicines,
      List<DailyHealthSchedule> healthSchedules,
      WalkDaily? walk});

  @override
  $WalkDailyCopyWith<$Res>? get walk;
}

/// @nodoc
class __$MonthlyGoalDayCopyWithImpl<$Res>
    implements _$MonthlyGoalDayCopyWith<$Res> {
  __$MonthlyGoalDayCopyWithImpl(this._self, this._then);

  final _MonthlyGoalDay _self;
  final $Res Function(_MonthlyGoalDay) _then;

  /// Create a copy of MonthlyGoalDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? medicines = null,
    Object? healthSchedules = null,
    Object? walk = freezed,
  }) {
    return _then(_MonthlyGoalDay(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      medicines: null == medicines
          ? _self._medicines
          : medicines // ignore: cast_nullable_to_non_nullable
              as List<DailyMedicineSchedule>,
      healthSchedules: null == healthSchedules
          ? _self._healthSchedules
          : healthSchedules // ignore: cast_nullable_to_non_nullable
              as List<DailyHealthSchedule>,
      walk: freezed == walk
          ? _self.walk
          : walk // ignore: cast_nullable_to_non_nullable
              as WalkDaily?,
    ));
  }

  /// Create a copy of MonthlyGoalDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalkDailyCopyWith<$Res>? get walk {
    if (_self.walk == null) {
      return null;
    }

    return $WalkDailyCopyWith<$Res>(_self.walk!, (value) {
      return _then(_self.copyWith(walk: value));
    });
  }
}

/// @nodoc
mixin _$MonthlyGoalUiState {
  DateTime get today;
  DateTime get focusedMonth;
  DateTime get selectedDay;
  Set<int> get healthDays; // 새 날짜를 불러오는 동안에는 이전 날짜를 그대로 보여 준다.
  MonthlyGoalDay? get day;
  bool get isDayLoading;
  bool get hasDayError;

  /// Create a copy of MonthlyGoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthlyGoalUiStateCopyWith<MonthlyGoalUiState> get copyWith =>
      _$MonthlyGoalUiStateCopyWithImpl<MonthlyGoalUiState>(
          this as MonthlyGoalUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthlyGoalUiState &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.focusedMonth, focusedMonth) ||
                other.focusedMonth == focusedMonth) &&
            (identical(other.selectedDay, selectedDay) ||
                other.selectedDay == selectedDay) &&
            const DeepCollectionEquality()
                .equals(other.healthDays, healthDays) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.isDayLoading, isDayLoading) ||
                other.isDayLoading == isDayLoading) &&
            (identical(other.hasDayError, hasDayError) ||
                other.hasDayError == hasDayError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      today,
      focusedMonth,
      selectedDay,
      const DeepCollectionEquality().hash(healthDays),
      day,
      isDayLoading,
      hasDayError);

  @override
  String toString() {
    return 'MonthlyGoalUiState(today: $today, focusedMonth: $focusedMonth, selectedDay: $selectedDay, healthDays: $healthDays, day: $day, isDayLoading: $isDayLoading, hasDayError: $hasDayError)';
  }
}

/// @nodoc
abstract mixin class $MonthlyGoalUiStateCopyWith<$Res> {
  factory $MonthlyGoalUiStateCopyWith(
          MonthlyGoalUiState value, $Res Function(MonthlyGoalUiState) _then) =
      _$MonthlyGoalUiStateCopyWithImpl;
  @useResult
  $Res call(
      {DateTime today,
      DateTime focusedMonth,
      DateTime selectedDay,
      Set<int> healthDays,
      MonthlyGoalDay? day,
      bool isDayLoading,
      bool hasDayError});

  $MonthlyGoalDayCopyWith<$Res>? get day;
}

/// @nodoc
class _$MonthlyGoalUiStateCopyWithImpl<$Res>
    implements $MonthlyGoalUiStateCopyWith<$Res> {
  _$MonthlyGoalUiStateCopyWithImpl(this._self, this._then);

  final MonthlyGoalUiState _self;
  final $Res Function(MonthlyGoalUiState) _then;

  /// Create a copy of MonthlyGoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? focusedMonth = null,
    Object? selectedDay = null,
    Object? healthDays = null,
    Object? day = freezed,
    Object? isDayLoading = null,
    Object? hasDayError = null,
  }) {
    return _then(_self.copyWith(
      today: null == today
          ? _self.today
          : today // ignore: cast_nullable_to_non_nullable
              as DateTime,
      focusedMonth: null == focusedMonth
          ? _self.focusedMonth
          : focusedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDay: null == selectedDay
          ? _self.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      healthDays: null == healthDays
          ? _self.healthDays
          : healthDays // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      day: freezed == day
          ? _self.day
          : day // ignore: cast_nullable_to_non_nullable
              as MonthlyGoalDay?,
      isDayLoading: null == isDayLoading
          ? _self.isDayLoading
          : isDayLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDayError: null == hasDayError
          ? _self.hasDayError
          : hasDayError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of MonthlyGoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MonthlyGoalDayCopyWith<$Res>? get day {
    if (_self.day == null) {
      return null;
    }

    return $MonthlyGoalDayCopyWith<$Res>(_self.day!, (value) {
      return _then(_self.copyWith(day: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MonthlyGoalUiState].
extension MonthlyGoalUiStatePatterns on MonthlyGoalUiState {
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
    TResult Function(_MonthlyGoalUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalUiState() when $default != null:
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
    TResult Function(_MonthlyGoalUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalUiState():
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
    TResult? Function(_MonthlyGoalUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalUiState() when $default != null:
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
            DateTime today,
            DateTime focusedMonth,
            DateTime selectedDay,
            Set<int> healthDays,
            MonthlyGoalDay? day,
            bool isDayLoading,
            bool hasDayError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalUiState() when $default != null:
        return $default(_that.today, _that.focusedMonth, _that.selectedDay,
            _that.healthDays, _that.day, _that.isDayLoading, _that.hasDayError);
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
            DateTime today,
            DateTime focusedMonth,
            DateTime selectedDay,
            Set<int> healthDays,
            MonthlyGoalDay? day,
            bool isDayLoading,
            bool hasDayError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalUiState():
        return $default(_that.today, _that.focusedMonth, _that.selectedDay,
            _that.healthDays, _that.day, _that.isDayLoading, _that.hasDayError);
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
            DateTime today,
            DateTime focusedMonth,
            DateTime selectedDay,
            Set<int> healthDays,
            MonthlyGoalDay? day,
            bool isDayLoading,
            bool hasDayError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlyGoalUiState() when $default != null:
        return $default(_that.today, _that.focusedMonth, _that.selectedDay,
            _that.healthDays, _that.day, _that.isDayLoading, _that.hasDayError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MonthlyGoalUiState extends MonthlyGoalUiState {
  const _MonthlyGoalUiState(
      {required this.today,
      required this.focusedMonth,
      required this.selectedDay,
      final Set<int> healthDays = const {},
      this.day,
      this.isDayLoading = true,
      this.hasDayError = false})
      : _healthDays = healthDays,
        super._();

  @override
  final DateTime today;
  @override
  final DateTime focusedMonth;
  @override
  final DateTime selectedDay;
  final Set<int> _healthDays;
  @override
  @JsonKey()
  Set<int> get healthDays {
    if (_healthDays is EqualUnmodifiableSetView) return _healthDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_healthDays);
  }

// 새 날짜를 불러오는 동안에는 이전 날짜를 그대로 보여 준다.
  @override
  final MonthlyGoalDay? day;
  @override
  @JsonKey()
  final bool isDayLoading;
  @override
  @JsonKey()
  final bool hasDayError;

  /// Create a copy of MonthlyGoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MonthlyGoalUiStateCopyWith<_MonthlyGoalUiState> get copyWith =>
      __$MonthlyGoalUiStateCopyWithImpl<_MonthlyGoalUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthlyGoalUiState &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.focusedMonth, focusedMonth) ||
                other.focusedMonth == focusedMonth) &&
            (identical(other.selectedDay, selectedDay) ||
                other.selectedDay == selectedDay) &&
            const DeepCollectionEquality()
                .equals(other._healthDays, _healthDays) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.isDayLoading, isDayLoading) ||
                other.isDayLoading == isDayLoading) &&
            (identical(other.hasDayError, hasDayError) ||
                other.hasDayError == hasDayError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      today,
      focusedMonth,
      selectedDay,
      const DeepCollectionEquality().hash(_healthDays),
      day,
      isDayLoading,
      hasDayError);

  @override
  String toString() {
    return 'MonthlyGoalUiState(today: $today, focusedMonth: $focusedMonth, selectedDay: $selectedDay, healthDays: $healthDays, day: $day, isDayLoading: $isDayLoading, hasDayError: $hasDayError)';
  }
}

/// @nodoc
abstract mixin class _$MonthlyGoalUiStateCopyWith<$Res>
    implements $MonthlyGoalUiStateCopyWith<$Res> {
  factory _$MonthlyGoalUiStateCopyWith(
          _MonthlyGoalUiState value, $Res Function(_MonthlyGoalUiState) _then) =
      __$MonthlyGoalUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime today,
      DateTime focusedMonth,
      DateTime selectedDay,
      Set<int> healthDays,
      MonthlyGoalDay? day,
      bool isDayLoading,
      bool hasDayError});

  @override
  $MonthlyGoalDayCopyWith<$Res>? get day;
}

/// @nodoc
class __$MonthlyGoalUiStateCopyWithImpl<$Res>
    implements _$MonthlyGoalUiStateCopyWith<$Res> {
  __$MonthlyGoalUiStateCopyWithImpl(this._self, this._then);

  final _MonthlyGoalUiState _self;
  final $Res Function(_MonthlyGoalUiState) _then;

  /// Create a copy of MonthlyGoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? today = null,
    Object? focusedMonth = null,
    Object? selectedDay = null,
    Object? healthDays = null,
    Object? day = freezed,
    Object? isDayLoading = null,
    Object? hasDayError = null,
  }) {
    return _then(_MonthlyGoalUiState(
      today: null == today
          ? _self.today
          : today // ignore: cast_nullable_to_non_nullable
              as DateTime,
      focusedMonth: null == focusedMonth
          ? _self.focusedMonth
          : focusedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDay: null == selectedDay
          ? _self.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      healthDays: null == healthDays
          ? _self._healthDays
          : healthDays // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      day: freezed == day
          ? _self.day
          : day // ignore: cast_nullable_to_non_nullable
              as MonthlyGoalDay?,
      isDayLoading: null == isDayLoading
          ? _self.isDayLoading
          : isDayLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDayError: null == hasDayError
          ? _self.hasDayError
          : hasDayError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of MonthlyGoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MonthlyGoalDayCopyWith<$Res>? get day {
    if (_self.day == null) {
      return null;
    }

    return $MonthlyGoalDayCopyWith<$Res>(_self.day!, (value) {
      return _then(_self.copyWith(day: value));
    });
  }
}

// dart format on
