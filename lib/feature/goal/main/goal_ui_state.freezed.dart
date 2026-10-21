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
mixin _$GoalCardsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GoalCardsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoalCardsState()';
  }
}

/// @nodoc
class $GoalCardsStateCopyWith<$Res> {
  $GoalCardsStateCopyWith(GoalCardsState _, $Res Function(GoalCardsState) __);
}

/// Adds pattern-matching-related methods to [GoalCardsState].
extension GoalCardsStatePatterns on GoalCardsState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoalCardsLoading value)? loading,
    TResult Function(GoalCardsError value)? error,
    TResult Function(GoalCardsData value)? data,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GoalCardsLoading() when loading != null:
        return loading(_that);
      case GoalCardsError() when error != null:
        return error(_that);
      case GoalCardsData() when data != null:
        return data(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(GoalCardsLoading value) loading,
    required TResult Function(GoalCardsError value) error,
    required TResult Function(GoalCardsData value) data,
  }) {
    final _that = this;
    switch (_that) {
      case GoalCardsLoading():
        return loading(_that);
      case GoalCardsError():
        return error(_that);
      case GoalCardsData():
        return data(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoalCardsLoading value)? loading,
    TResult? Function(GoalCardsError value)? error,
    TResult? Function(GoalCardsData value)? data,
  }) {
    final _that = this;
    switch (_that) {
      case GoalCardsLoading() when loading != null:
        return loading(_that);
      case GoalCardsError() when error != null:
        return error(_that);
      case GoalCardsData() when data != null:
        return data(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function(
            Medication? medicine,
            Walk? walk,
            Hospital? hospital,
            Duration verifyRemaining,
            MedicationVerifyStatus verifyStatus,
            File? proofPhoto)?
        data,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GoalCardsLoading() when loading != null:
        return loading();
      case GoalCardsError() when error != null:
        return error();
      case GoalCardsData() when data != null:
        return data(_that.medicine, _that.walk, _that.hospital,
            _that.verifyRemaining, _that.verifyStatus, _that.proofPhoto);
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
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function(
            Medication? medicine,
            Walk? walk,
            Hospital? hospital,
            Duration verifyRemaining,
            MedicationVerifyStatus verifyStatus,
            File? proofPhoto)
        data,
  }) {
    final _that = this;
    switch (_that) {
      case GoalCardsLoading():
        return loading();
      case GoalCardsError():
        return error();
      case GoalCardsData():
        return data(_that.medicine, _that.walk, _that.hospital,
            _that.verifyRemaining, _that.verifyStatus, _that.proofPhoto);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function(
            Medication? medicine,
            Walk? walk,
            Hospital? hospital,
            Duration verifyRemaining,
            MedicationVerifyStatus verifyStatus,
            File? proofPhoto)?
        data,
  }) {
    final _that = this;
    switch (_that) {
      case GoalCardsLoading() when loading != null:
        return loading();
      case GoalCardsError() when error != null:
        return error();
      case GoalCardsData() when data != null:
        return data(_that.medicine, _that.walk, _that.hospital,
            _that.verifyRemaining, _that.verifyStatus, _that.proofPhoto);
      case _:
        return null;
    }
  }
}

/// @nodoc

class GoalCardsLoading implements GoalCardsState {
  const GoalCardsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GoalCardsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoalCardsState.loading()';
  }
}

/// @nodoc

class GoalCardsError implements GoalCardsState {
  const GoalCardsError();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GoalCardsError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoalCardsState.error()';
  }
}

/// @nodoc

class GoalCardsData implements GoalCardsState {
  const GoalCardsData(
      {this.medicine,
      this.walk,
      this.hospital,
      this.verifyRemaining = Duration.zero,
      this.verifyStatus = MedicationVerifyStatus.pending,
      this.proofPhoto});

  final Medication? medicine;
  final Walk? walk;
  final Hospital? hospital;
  @JsonKey()
  final Duration verifyRemaining;
  @JsonKey()
  final MedicationVerifyStatus verifyStatus;
  final File? proofPhoto;

  /// Create a copy of GoalCardsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalCardsDataCopyWith<GoalCardsData> get copyWith =>
      _$GoalCardsDataCopyWithImpl<GoalCardsData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalCardsData &&
            (identical(other.medicine, medicine) ||
                other.medicine == medicine) &&
            (identical(other.walk, walk) || other.walk == walk) &&
            (identical(other.hospital, hospital) ||
                other.hospital == hospital) &&
            (identical(other.verifyRemaining, verifyRemaining) ||
                other.verifyRemaining == verifyRemaining) &&
            (identical(other.verifyStatus, verifyStatus) ||
                other.verifyStatus == verifyStatus) &&
            (identical(other.proofPhoto, proofPhoto) ||
                other.proofPhoto == proofPhoto));
  }

  @override
  int get hashCode => Object.hash(runtimeType, medicine, walk, hospital,
      verifyRemaining, verifyStatus, proofPhoto);

  @override
  String toString() {
    return 'GoalCardsState.data(medicine: $medicine, walk: $walk, hospital: $hospital, verifyRemaining: $verifyRemaining, verifyStatus: $verifyStatus, proofPhoto: $proofPhoto)';
  }
}

/// @nodoc
abstract mixin class $GoalCardsDataCopyWith<$Res>
    implements $GoalCardsStateCopyWith<$Res> {
  factory $GoalCardsDataCopyWith(
          GoalCardsData value, $Res Function(GoalCardsData) _then) =
      _$GoalCardsDataCopyWithImpl;
  @useResult
  $Res call(
      {Medication? medicine,
      Walk? walk,
      Hospital? hospital,
      Duration verifyRemaining,
      MedicationVerifyStatus verifyStatus,
      File? proofPhoto});

  $MedicationCopyWith<$Res>? get medicine;
  $WalkCopyWith<$Res>? get walk;
  $HospitalCopyWith<$Res>? get hospital;
}

/// @nodoc
class _$GoalCardsDataCopyWithImpl<$Res>
    implements $GoalCardsDataCopyWith<$Res> {
  _$GoalCardsDataCopyWithImpl(this._self, this._then);

  final GoalCardsData _self;
  final $Res Function(GoalCardsData) _then;

  /// Create a copy of GoalCardsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? medicine = freezed,
    Object? walk = freezed,
    Object? hospital = freezed,
    Object? verifyRemaining = null,
    Object? verifyStatus = null,
    Object? proofPhoto = freezed,
  }) {
    return _then(GoalCardsData(
      medicine: freezed == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medication?,
      walk: freezed == walk
          ? _self.walk
          : walk // ignore: cast_nullable_to_non_nullable
              as Walk?,
      hospital: freezed == hospital
          ? _self.hospital
          : hospital // ignore: cast_nullable_to_non_nullable
              as Hospital?,
      verifyRemaining: null == verifyRemaining
          ? _self.verifyRemaining
          : verifyRemaining // ignore: cast_nullable_to_non_nullable
              as Duration,
      verifyStatus: null == verifyStatus
          ? _self.verifyStatus
          : verifyStatus // ignore: cast_nullable_to_non_nullable
              as MedicationVerifyStatus,
      proofPhoto: freezed == proofPhoto
          ? _self.proofPhoto
          : proofPhoto // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }

  /// Create a copy of GoalCardsState
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

  /// Create a copy of GoalCardsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalkCopyWith<$Res>? get walk {
    if (_self.walk == null) {
      return null;
    }

    return $WalkCopyWith<$Res>(_self.walk!, (value) {
      return _then(_self.copyWith(walk: value));
    });
  }

  /// Create a copy of GoalCardsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HospitalCopyWith<$Res>? get hospital {
    if (_self.hospital == null) {
      return null;
    }

    return $HospitalCopyWith<$Res>(_self.hospital!, (value) {
      return _then(_self.copyWith(hospital: value));
    });
  }
}

/// @nodoc
mixin _$GoalUiState {
  GoalCardsState get cards;
  bool get isWeeklyLoading;
  List<GoalRateStatus> get weeklyStatuses;

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
            (identical(other.cards, cards) || other.cards == cards) &&
            (identical(other.isWeeklyLoading, isWeeklyLoading) ||
                other.isWeeklyLoading == isWeeklyLoading) &&
            const DeepCollectionEquality()
                .equals(other.weeklyStatuses, weeklyStatuses));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cards, isWeeklyLoading,
      const DeepCollectionEquality().hash(weeklyStatuses));

  @override
  String toString() {
    return 'GoalUiState(cards: $cards, isWeeklyLoading: $isWeeklyLoading, weeklyStatuses: $weeklyStatuses)';
  }
}

/// @nodoc
abstract mixin class $GoalUiStateCopyWith<$Res> {
  factory $GoalUiStateCopyWith(
          GoalUiState value, $Res Function(GoalUiState) _then) =
      _$GoalUiStateCopyWithImpl;
  @useResult
  $Res call(
      {GoalCardsState cards,
      bool isWeeklyLoading,
      List<GoalRateStatus> weeklyStatuses});

  $GoalCardsStateCopyWith<$Res> get cards;
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
    Object? cards = null,
    Object? isWeeklyLoading = null,
    Object? weeklyStatuses = null,
  }) {
    return _then(_self.copyWith(
      cards: null == cards
          ? _self.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as GoalCardsState,
      isWeeklyLoading: null == isWeeklyLoading
          ? _self.isWeeklyLoading
          : isWeeklyLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      weeklyStatuses: null == weeklyStatuses
          ? _self.weeklyStatuses
          : weeklyStatuses // ignore: cast_nullable_to_non_nullable
              as List<GoalRateStatus>,
    ));
  }

  /// Create a copy of GoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GoalCardsStateCopyWith<$Res> get cards {
    return $GoalCardsStateCopyWith<$Res>(_self.cards, (value) {
      return _then(_self.copyWith(cards: value));
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
    TResult Function(GoalCardsState cards, bool isWeeklyLoading,
            List<GoalRateStatus> weeklyStatuses)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalUiState() when $default != null:
        return $default(
            _that.cards, _that.isWeeklyLoading, _that.weeklyStatuses);
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
    TResult Function(GoalCardsState cards, bool isWeeklyLoading,
            List<GoalRateStatus> weeklyStatuses)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalUiState():
        return $default(
            _that.cards, _that.isWeeklyLoading, _that.weeklyStatuses);
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
    TResult? Function(GoalCardsState cards, bool isWeeklyLoading,
            List<GoalRateStatus> weeklyStatuses)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalUiState() when $default != null:
        return $default(
            _that.cards, _that.isWeeklyLoading, _that.weeklyStatuses);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GoalUiState extends GoalUiState {
  const _GoalUiState(
      {this.cards = const GoalCardsState.loading(),
      this.isWeeklyLoading = true,
      final List<GoalRateStatus> weeklyStatuses = const []})
      : _weeklyStatuses = weeklyStatuses,
        super._();

  @override
  @JsonKey()
  final GoalCardsState cards;
  @override
  @JsonKey()
  final bool isWeeklyLoading;
  final List<GoalRateStatus> _weeklyStatuses;
  @override
  @JsonKey()
  List<GoalRateStatus> get weeklyStatuses {
    if (_weeklyStatuses is EqualUnmodifiableListView) return _weeklyStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyStatuses);
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
            (identical(other.cards, cards) || other.cards == cards) &&
            (identical(other.isWeeklyLoading, isWeeklyLoading) ||
                other.isWeeklyLoading == isWeeklyLoading) &&
            const DeepCollectionEquality()
                .equals(other._weeklyStatuses, _weeklyStatuses));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cards, isWeeklyLoading,
      const DeepCollectionEquality().hash(_weeklyStatuses));

  @override
  String toString() {
    return 'GoalUiState(cards: $cards, isWeeklyLoading: $isWeeklyLoading, weeklyStatuses: $weeklyStatuses)';
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
      {GoalCardsState cards,
      bool isWeeklyLoading,
      List<GoalRateStatus> weeklyStatuses});

  @override
  $GoalCardsStateCopyWith<$Res> get cards;
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
    Object? cards = null,
    Object? isWeeklyLoading = null,
    Object? weeklyStatuses = null,
  }) {
    return _then(_GoalUiState(
      cards: null == cards
          ? _self.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as GoalCardsState,
      isWeeklyLoading: null == isWeeklyLoading
          ? _self.isWeeklyLoading
          : isWeeklyLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      weeklyStatuses: null == weeklyStatuses
          ? _self._weeklyStatuses
          : weeklyStatuses // ignore: cast_nullable_to_non_nullable
              as List<GoalRateStatus>,
    ));
  }

  /// Create a copy of GoalUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GoalCardsStateCopyWith<$Res> get cards {
    return $GoalCardsStateCopyWith<$Res>(_self.cards, (value) {
      return _then(_self.copyWith(cards: value));
    });
  }
}

// dart format on
