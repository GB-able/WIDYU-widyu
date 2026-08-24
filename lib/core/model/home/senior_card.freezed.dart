// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'senior_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SeniorCard {
  SeniorHeartRate? get heartRate;
  MedicationSummary? get medicine;
  @JsonKey(defaultValue: [])
  List<Album> get albums;
  HealthSchedule? get healthSchedule;
  StepProgress? get walk;

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SeniorCardCopyWith<SeniorCard> get copyWith =>
      _$SeniorCardCopyWithImpl<SeniorCard>(this as SeniorCard, _$identity);

  /// Serializes this SeniorCard to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SeniorCard &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.medicine, medicine) ||
                other.medicine == medicine) &&
            const DeepCollectionEquality().equals(other.albums, albums) &&
            (identical(other.healthSchedule, healthSchedule) ||
                other.healthSchedule == healthSchedule) &&
            (identical(other.walk, walk) || other.walk == walk));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, heartRate, medicine,
      const DeepCollectionEquality().hash(albums), healthSchedule, walk);

  @override
  String toString() {
    return 'SeniorCard(heartRate: $heartRate, medicine: $medicine, albums: $albums, healthSchedule: $healthSchedule, walk: $walk)';
  }
}

/// @nodoc
abstract mixin class $SeniorCardCopyWith<$Res> {
  factory $SeniorCardCopyWith(
          SeniorCard value, $Res Function(SeniorCard) _then) =
      _$SeniorCardCopyWithImpl;
  @useResult
  $Res call(
      {SeniorHeartRate? heartRate,
      MedicationSummary? medicine,
      @JsonKey(defaultValue: []) List<Album> albums,
      HealthSchedule? healthSchedule,
      StepProgress? walk});

  $SeniorHeartRateCopyWith<$Res>? get heartRate;
  $MedicationSummaryCopyWith<$Res>? get medicine;
  $HealthScheduleCopyWith<$Res>? get healthSchedule;
  $StepProgressCopyWith<$Res>? get walk;
}

/// @nodoc
class _$SeniorCardCopyWithImpl<$Res> implements $SeniorCardCopyWith<$Res> {
  _$SeniorCardCopyWithImpl(this._self, this._then);

  final SeniorCard _self;
  final $Res Function(SeniorCard) _then;

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heartRate = freezed,
    Object? medicine = freezed,
    Object? albums = null,
    Object? healthSchedule = freezed,
    Object? walk = freezed,
  }) {
    return _then(_self.copyWith(
      heartRate: freezed == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as SeniorHeartRate?,
      medicine: freezed == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as MedicationSummary?,
      albums: null == albums
          ? _self.albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<Album>,
      healthSchedule: freezed == healthSchedule
          ? _self.healthSchedule
          : healthSchedule // ignore: cast_nullable_to_non_nullable
              as HealthSchedule?,
      walk: freezed == walk
          ? _self.walk
          : walk // ignore: cast_nullable_to_non_nullable
              as StepProgress?,
    ));
  }

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SeniorHeartRateCopyWith<$Res>? get heartRate {
    if (_self.heartRate == null) {
      return null;
    }

    return $SeniorHeartRateCopyWith<$Res>(_self.heartRate!, (value) {
      return _then(_self.copyWith(heartRate: value));
    });
  }

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationSummaryCopyWith<$Res>? get medicine {
    if (_self.medicine == null) {
      return null;
    }

    return $MedicationSummaryCopyWith<$Res>(_self.medicine!, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthScheduleCopyWith<$Res>? get healthSchedule {
    if (_self.healthSchedule == null) {
      return null;
    }

    return $HealthScheduleCopyWith<$Res>(_self.healthSchedule!, (value) {
      return _then(_self.copyWith(healthSchedule: value));
    });
  }

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StepProgressCopyWith<$Res>? get walk {
    if (_self.walk == null) {
      return null;
    }

    return $StepProgressCopyWith<$Res>(_self.walk!, (value) {
      return _then(_self.copyWith(walk: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SeniorCard].
extension SeniorCardPatterns on SeniorCard {
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
    TResult Function(_SeniorCard value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SeniorCard() when $default != null:
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
    TResult Function(_SeniorCard value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SeniorCard():
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
    TResult? Function(_SeniorCard value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SeniorCard() when $default != null:
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
            SeniorHeartRate? heartRate,
            MedicationSummary? medicine,
            @JsonKey(defaultValue: []) List<Album> albums,
            HealthSchedule? healthSchedule,
            StepProgress? walk)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SeniorCard() when $default != null:
        return $default(_that.heartRate, _that.medicine, _that.albums,
            _that.healthSchedule, _that.walk);
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
            SeniorHeartRate? heartRate,
            MedicationSummary? medicine,
            @JsonKey(defaultValue: []) List<Album> albums,
            HealthSchedule? healthSchedule,
            StepProgress? walk)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SeniorCard():
        return $default(_that.heartRate, _that.medicine, _that.albums,
            _that.healthSchedule, _that.walk);
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
            SeniorHeartRate? heartRate,
            MedicationSummary? medicine,
            @JsonKey(defaultValue: []) List<Album> albums,
            HealthSchedule? healthSchedule,
            StepProgress? walk)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SeniorCard() when $default != null:
        return $default(_that.heartRate, _that.medicine, _that.albums,
            _that.healthSchedule, _that.walk);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SeniorCard implements SeniorCard {
  const _SeniorCard(
      {required this.heartRate,
      required this.medicine,
      @JsonKey(defaultValue: []) required final List<Album> albums,
      required this.healthSchedule,
      required this.walk})
      : _albums = albums;
  factory _SeniorCard.fromJson(Map<String, dynamic> json) =>
      _$SeniorCardFromJson(json);

  @override
  final SeniorHeartRate? heartRate;
  @override
  final MedicationSummary? medicine;
  final List<Album> _albums;
  @override
  @JsonKey(defaultValue: [])
  List<Album> get albums {
    if (_albums is EqualUnmodifiableListView) return _albums;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_albums);
  }

  @override
  final HealthSchedule? healthSchedule;
  @override
  final StepProgress? walk;

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SeniorCardCopyWith<_SeniorCard> get copyWith =>
      __$SeniorCardCopyWithImpl<_SeniorCard>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SeniorCardToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SeniorCard &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.medicine, medicine) ||
                other.medicine == medicine) &&
            const DeepCollectionEquality().equals(other._albums, _albums) &&
            (identical(other.healthSchedule, healthSchedule) ||
                other.healthSchedule == healthSchedule) &&
            (identical(other.walk, walk) || other.walk == walk));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, heartRate, medicine,
      const DeepCollectionEquality().hash(_albums), healthSchedule, walk);

  @override
  String toString() {
    return 'SeniorCard(heartRate: $heartRate, medicine: $medicine, albums: $albums, healthSchedule: $healthSchedule, walk: $walk)';
  }
}

/// @nodoc
abstract mixin class _$SeniorCardCopyWith<$Res>
    implements $SeniorCardCopyWith<$Res> {
  factory _$SeniorCardCopyWith(
          _SeniorCard value, $Res Function(_SeniorCard) _then) =
      __$SeniorCardCopyWithImpl;
  @override
  @useResult
  $Res call(
      {SeniorHeartRate? heartRate,
      MedicationSummary? medicine,
      @JsonKey(defaultValue: []) List<Album> albums,
      HealthSchedule? healthSchedule,
      StepProgress? walk});

  @override
  $SeniorHeartRateCopyWith<$Res>? get heartRate;
  @override
  $MedicationSummaryCopyWith<$Res>? get medicine;
  @override
  $HealthScheduleCopyWith<$Res>? get healthSchedule;
  @override
  $StepProgressCopyWith<$Res>? get walk;
}

/// @nodoc
class __$SeniorCardCopyWithImpl<$Res> implements _$SeniorCardCopyWith<$Res> {
  __$SeniorCardCopyWithImpl(this._self, this._then);

  final _SeniorCard _self;
  final $Res Function(_SeniorCard) _then;

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? heartRate = freezed,
    Object? medicine = freezed,
    Object? albums = null,
    Object? healthSchedule = freezed,
    Object? walk = freezed,
  }) {
    return _then(_SeniorCard(
      heartRate: freezed == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as SeniorHeartRate?,
      medicine: freezed == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as MedicationSummary?,
      albums: null == albums
          ? _self._albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<Album>,
      healthSchedule: freezed == healthSchedule
          ? _self.healthSchedule
          : healthSchedule // ignore: cast_nullable_to_non_nullable
              as HealthSchedule?,
      walk: freezed == walk
          ? _self.walk
          : walk // ignore: cast_nullable_to_non_nullable
              as StepProgress?,
    ));
  }

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SeniorHeartRateCopyWith<$Res>? get heartRate {
    if (_self.heartRate == null) {
      return null;
    }

    return $SeniorHeartRateCopyWith<$Res>(_self.heartRate!, (value) {
      return _then(_self.copyWith(heartRate: value));
    });
  }

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationSummaryCopyWith<$Res>? get medicine {
    if (_self.medicine == null) {
      return null;
    }

    return $MedicationSummaryCopyWith<$Res>(_self.medicine!, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthScheduleCopyWith<$Res>? get healthSchedule {
    if (_self.healthSchedule == null) {
      return null;
    }

    return $HealthScheduleCopyWith<$Res>(_self.healthSchedule!, (value) {
      return _then(_self.copyWith(healthSchedule: value));
    });
  }

  /// Create a copy of SeniorCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StepProgressCopyWith<$Res>? get walk {
    if (_self.walk == null) {
      return null;
    }

    return $StepProgressCopyWith<$Res>(_self.walk!, (value) {
      return _then(_self.copyWith(walk: value));
    });
  }
}

/// @nodoc
mixin _$SeniorHeartRate {
  @JsonKey(defaultValue: false)
  bool get isWearing;
  String? get heartRateStatus;
  int? get bpm;

  /// Create a copy of SeniorHeartRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SeniorHeartRateCopyWith<SeniorHeartRate> get copyWith =>
      _$SeniorHeartRateCopyWithImpl<SeniorHeartRate>(
          this as SeniorHeartRate, _$identity);

  /// Serializes this SeniorHeartRate to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SeniorHeartRate &&
            (identical(other.isWearing, isWearing) ||
                other.isWearing == isWearing) &&
            (identical(other.heartRateStatus, heartRateStatus) ||
                other.heartRateStatus == heartRateStatus) &&
            (identical(other.bpm, bpm) || other.bpm == bpm));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isWearing, heartRateStatus, bpm);

  @override
  String toString() {
    return 'SeniorHeartRate(isWearing: $isWearing, heartRateStatus: $heartRateStatus, bpm: $bpm)';
  }
}

/// @nodoc
abstract mixin class $SeniorHeartRateCopyWith<$Res> {
  factory $SeniorHeartRateCopyWith(
          SeniorHeartRate value, $Res Function(SeniorHeartRate) _then) =
      _$SeniorHeartRateCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(defaultValue: false) bool isWearing,
      String? heartRateStatus,
      int? bpm});
}

/// @nodoc
class _$SeniorHeartRateCopyWithImpl<$Res>
    implements $SeniorHeartRateCopyWith<$Res> {
  _$SeniorHeartRateCopyWithImpl(this._self, this._then);

  final SeniorHeartRate _self;
  final $Res Function(SeniorHeartRate) _then;

  /// Create a copy of SeniorHeartRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isWearing = null,
    Object? heartRateStatus = freezed,
    Object? bpm = freezed,
  }) {
    return _then(_self.copyWith(
      isWearing: null == isWearing
          ? _self.isWearing
          : isWearing // ignore: cast_nullable_to_non_nullable
              as bool,
      heartRateStatus: freezed == heartRateStatus
          ? _self.heartRateStatus
          : heartRateStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      bpm: freezed == bpm
          ? _self.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SeniorHeartRate].
extension SeniorHeartRatePatterns on SeniorHeartRate {
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
    TResult Function(_SeniorHeartRate value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SeniorHeartRate() when $default != null:
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
    TResult Function(_SeniorHeartRate value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SeniorHeartRate():
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
    TResult? Function(_SeniorHeartRate value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SeniorHeartRate() when $default != null:
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
    TResult Function(@JsonKey(defaultValue: false) bool isWearing,
            String? heartRateStatus, int? bpm)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SeniorHeartRate() when $default != null:
        return $default(_that.isWearing, _that.heartRateStatus, _that.bpm);
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
    TResult Function(@JsonKey(defaultValue: false) bool isWearing,
            String? heartRateStatus, int? bpm)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SeniorHeartRate():
        return $default(_that.isWearing, _that.heartRateStatus, _that.bpm);
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
    TResult? Function(@JsonKey(defaultValue: false) bool isWearing,
            String? heartRateStatus, int? bpm)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SeniorHeartRate() when $default != null:
        return $default(_that.isWearing, _that.heartRateStatus, _that.bpm);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SeniorHeartRate implements SeniorHeartRate {
  const _SeniorHeartRate(
      {@JsonKey(defaultValue: false) required this.isWearing,
      required this.heartRateStatus,
      required this.bpm});
  factory _SeniorHeartRate.fromJson(Map<String, dynamic> json) =>
      _$SeniorHeartRateFromJson(json);

  @override
  @JsonKey(defaultValue: false)
  final bool isWearing;
  @override
  final String? heartRateStatus;
  @override
  final int? bpm;

  /// Create a copy of SeniorHeartRate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SeniorHeartRateCopyWith<_SeniorHeartRate> get copyWith =>
      __$SeniorHeartRateCopyWithImpl<_SeniorHeartRate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SeniorHeartRateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SeniorHeartRate &&
            (identical(other.isWearing, isWearing) ||
                other.isWearing == isWearing) &&
            (identical(other.heartRateStatus, heartRateStatus) ||
                other.heartRateStatus == heartRateStatus) &&
            (identical(other.bpm, bpm) || other.bpm == bpm));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isWearing, heartRateStatus, bpm);

  @override
  String toString() {
    return 'SeniorHeartRate(isWearing: $isWearing, heartRateStatus: $heartRateStatus, bpm: $bpm)';
  }
}

/// @nodoc
abstract mixin class _$SeniorHeartRateCopyWith<$Res>
    implements $SeniorHeartRateCopyWith<$Res> {
  factory _$SeniorHeartRateCopyWith(
          _SeniorHeartRate value, $Res Function(_SeniorHeartRate) _then) =
      __$SeniorHeartRateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(defaultValue: false) bool isWearing,
      String? heartRateStatus,
      int? bpm});
}

/// @nodoc
class __$SeniorHeartRateCopyWithImpl<$Res>
    implements _$SeniorHeartRateCopyWith<$Res> {
  __$SeniorHeartRateCopyWithImpl(this._self, this._then);

  final _SeniorHeartRate _self;
  final $Res Function(_SeniorHeartRate) _then;

  /// Create a copy of SeniorHeartRate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isWearing = null,
    Object? heartRateStatus = freezed,
    Object? bpm = freezed,
  }) {
    return _then(_SeniorHeartRate(
      isWearing: null == isWearing
          ? _self.isWearing
          : isWearing // ignore: cast_nullable_to_non_nullable
              as bool,
      heartRateStatus: freezed == heartRateStatus
          ? _self.heartRateStatus
          : heartRateStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      bpm: freezed == bpm
          ? _self.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$MedicationSummary {
  int? get medicineScheduleId;
  int? get todayTakenCount;
  int? get todayTotalCount;
  int? get nextDoseCount;
  String? get nextAlarmTime;
  @JsonKey(defaultValue: [])
  List<MedicationDoseStatus> get scheduleStatuses;

  /// Create a copy of MedicationSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationSummaryCopyWith<MedicationSummary> get copyWith =>
      _$MedicationSummaryCopyWithImpl<MedicationSummary>(
          this as MedicationSummary, _$identity);

  /// Serializes this MedicationSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationSummary &&
            (identical(other.medicineScheduleId, medicineScheduleId) ||
                other.medicineScheduleId == medicineScheduleId) &&
            (identical(other.todayTakenCount, todayTakenCount) ||
                other.todayTakenCount == todayTakenCount) &&
            (identical(other.todayTotalCount, todayTotalCount) ||
                other.todayTotalCount == todayTotalCount) &&
            (identical(other.nextDoseCount, nextDoseCount) ||
                other.nextDoseCount == nextDoseCount) &&
            (identical(other.nextAlarmTime, nextAlarmTime) ||
                other.nextAlarmTime == nextAlarmTime) &&
            const DeepCollectionEquality()
                .equals(other.scheduleStatuses, scheduleStatuses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      medicineScheduleId,
      todayTakenCount,
      todayTotalCount,
      nextDoseCount,
      nextAlarmTime,
      const DeepCollectionEquality().hash(scheduleStatuses));

  @override
  String toString() {
    return 'MedicationSummary(medicineScheduleId: $medicineScheduleId, todayTakenCount: $todayTakenCount, todayTotalCount: $todayTotalCount, nextDoseCount: $nextDoseCount, nextAlarmTime: $nextAlarmTime, scheduleStatuses: $scheduleStatuses)';
  }
}

/// @nodoc
abstract mixin class $MedicationSummaryCopyWith<$Res> {
  factory $MedicationSummaryCopyWith(
          MedicationSummary value, $Res Function(MedicationSummary) _then) =
      _$MedicationSummaryCopyWithImpl;
  @useResult
  $Res call(
      {int? medicineScheduleId,
      int? todayTakenCount,
      int? todayTotalCount,
      int? nextDoseCount,
      String? nextAlarmTime,
      @JsonKey(defaultValue: []) List<MedicationDoseStatus> scheduleStatuses});
}

/// @nodoc
class _$MedicationSummaryCopyWithImpl<$Res>
    implements $MedicationSummaryCopyWith<$Res> {
  _$MedicationSummaryCopyWithImpl(this._self, this._then);

  final MedicationSummary _self;
  final $Res Function(MedicationSummary) _then;

  /// Create a copy of MedicationSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicineScheduleId = freezed,
    Object? todayTakenCount = freezed,
    Object? todayTotalCount = freezed,
    Object? nextDoseCount = freezed,
    Object? nextAlarmTime = freezed,
    Object? scheduleStatuses = null,
  }) {
    return _then(_self.copyWith(
      medicineScheduleId: freezed == medicineScheduleId
          ? _self.medicineScheduleId
          : medicineScheduleId // ignore: cast_nullable_to_non_nullable
              as int?,
      todayTakenCount: freezed == todayTakenCount
          ? _self.todayTakenCount
          : todayTakenCount // ignore: cast_nullable_to_non_nullable
              as int?,
      todayTotalCount: freezed == todayTotalCount
          ? _self.todayTotalCount
          : todayTotalCount // ignore: cast_nullable_to_non_nullable
              as int?,
      nextDoseCount: freezed == nextDoseCount
          ? _self.nextDoseCount
          : nextDoseCount // ignore: cast_nullable_to_non_nullable
              as int?,
      nextAlarmTime: freezed == nextAlarmTime
          ? _self.nextAlarmTime
          : nextAlarmTime // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduleStatuses: null == scheduleStatuses
          ? _self.scheduleStatuses
          : scheduleStatuses // ignore: cast_nullable_to_non_nullable
              as List<MedicationDoseStatus>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicationSummary].
extension MedicationSummaryPatterns on MedicationSummary {
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
    TResult Function(_MedicationSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationSummary() when $default != null:
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
    TResult Function(_MedicationSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationSummary():
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
    TResult? Function(_MedicationSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationSummary() when $default != null:
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
            int? medicineScheduleId,
            int? todayTakenCount,
            int? todayTotalCount,
            int? nextDoseCount,
            String? nextAlarmTime,
            @JsonKey(defaultValue: [])
            List<MedicationDoseStatus> scheduleStatuses)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationSummary() when $default != null:
        return $default(
            _that.medicineScheduleId,
            _that.todayTakenCount,
            _that.todayTotalCount,
            _that.nextDoseCount,
            _that.nextAlarmTime,
            _that.scheduleStatuses);
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
            int? medicineScheduleId,
            int? todayTakenCount,
            int? todayTotalCount,
            int? nextDoseCount,
            String? nextAlarmTime,
            @JsonKey(defaultValue: [])
            List<MedicationDoseStatus> scheduleStatuses)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationSummary():
        return $default(
            _that.medicineScheduleId,
            _that.todayTakenCount,
            _that.todayTotalCount,
            _that.nextDoseCount,
            _that.nextAlarmTime,
            _that.scheduleStatuses);
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
            int? medicineScheduleId,
            int? todayTakenCount,
            int? todayTotalCount,
            int? nextDoseCount,
            String? nextAlarmTime,
            @JsonKey(defaultValue: [])
            List<MedicationDoseStatus> scheduleStatuses)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationSummary() when $default != null:
        return $default(
            _that.medicineScheduleId,
            _that.todayTakenCount,
            _that.todayTotalCount,
            _that.nextDoseCount,
            _that.nextAlarmTime,
            _that.scheduleStatuses);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MedicationSummary implements MedicationSummary {
  const _MedicationSummary(
      {required this.medicineScheduleId,
      required this.todayTakenCount,
      required this.todayTotalCount,
      required this.nextDoseCount,
      required this.nextAlarmTime,
      @JsonKey(defaultValue: [])
      required final List<MedicationDoseStatus> scheduleStatuses})
      : _scheduleStatuses = scheduleStatuses;
  factory _MedicationSummary.fromJson(Map<String, dynamic> json) =>
      _$MedicationSummaryFromJson(json);

  @override
  final int? medicineScheduleId;
  @override
  final int? todayTakenCount;
  @override
  final int? todayTotalCount;
  @override
  final int? nextDoseCount;
  @override
  final String? nextAlarmTime;
  final List<MedicationDoseStatus> _scheduleStatuses;
  @override
  @JsonKey(defaultValue: [])
  List<MedicationDoseStatus> get scheduleStatuses {
    if (_scheduleStatuses is EqualUnmodifiableListView)
      return _scheduleStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scheduleStatuses);
  }

  /// Create a copy of MedicationSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationSummaryCopyWith<_MedicationSummary> get copyWith =>
      __$MedicationSummaryCopyWithImpl<_MedicationSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicationSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationSummary &&
            (identical(other.medicineScheduleId, medicineScheduleId) ||
                other.medicineScheduleId == medicineScheduleId) &&
            (identical(other.todayTakenCount, todayTakenCount) ||
                other.todayTakenCount == todayTakenCount) &&
            (identical(other.todayTotalCount, todayTotalCount) ||
                other.todayTotalCount == todayTotalCount) &&
            (identical(other.nextDoseCount, nextDoseCount) ||
                other.nextDoseCount == nextDoseCount) &&
            (identical(other.nextAlarmTime, nextAlarmTime) ||
                other.nextAlarmTime == nextAlarmTime) &&
            const DeepCollectionEquality()
                .equals(other._scheduleStatuses, _scheduleStatuses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      medicineScheduleId,
      todayTakenCount,
      todayTotalCount,
      nextDoseCount,
      nextAlarmTime,
      const DeepCollectionEquality().hash(_scheduleStatuses));

  @override
  String toString() {
    return 'MedicationSummary(medicineScheduleId: $medicineScheduleId, todayTakenCount: $todayTakenCount, todayTotalCount: $todayTotalCount, nextDoseCount: $nextDoseCount, nextAlarmTime: $nextAlarmTime, scheduleStatuses: $scheduleStatuses)';
  }
}

/// @nodoc
abstract mixin class _$MedicationSummaryCopyWith<$Res>
    implements $MedicationSummaryCopyWith<$Res> {
  factory _$MedicationSummaryCopyWith(
          _MedicationSummary value, $Res Function(_MedicationSummary) _then) =
      __$MedicationSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? medicineScheduleId,
      int? todayTakenCount,
      int? todayTotalCount,
      int? nextDoseCount,
      String? nextAlarmTime,
      @JsonKey(defaultValue: []) List<MedicationDoseStatus> scheduleStatuses});
}

/// @nodoc
class __$MedicationSummaryCopyWithImpl<$Res>
    implements _$MedicationSummaryCopyWith<$Res> {
  __$MedicationSummaryCopyWithImpl(this._self, this._then);

  final _MedicationSummary _self;
  final $Res Function(_MedicationSummary) _then;

  /// Create a copy of MedicationSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? medicineScheduleId = freezed,
    Object? todayTakenCount = freezed,
    Object? todayTotalCount = freezed,
    Object? nextDoseCount = freezed,
    Object? nextAlarmTime = freezed,
    Object? scheduleStatuses = null,
  }) {
    return _then(_MedicationSummary(
      medicineScheduleId: freezed == medicineScheduleId
          ? _self.medicineScheduleId
          : medicineScheduleId // ignore: cast_nullable_to_non_nullable
              as int?,
      todayTakenCount: freezed == todayTakenCount
          ? _self.todayTakenCount
          : todayTakenCount // ignore: cast_nullable_to_non_nullable
              as int?,
      todayTotalCount: freezed == todayTotalCount
          ? _self.todayTotalCount
          : todayTotalCount // ignore: cast_nullable_to_non_nullable
              as int?,
      nextDoseCount: freezed == nextDoseCount
          ? _self.nextDoseCount
          : nextDoseCount // ignore: cast_nullable_to_non_nullable
              as int?,
      nextAlarmTime: freezed == nextAlarmTime
          ? _self.nextAlarmTime
          : nextAlarmTime // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduleStatuses: null == scheduleStatuses
          ? _self._scheduleStatuses
          : scheduleStatuses // ignore: cast_nullable_to_non_nullable
              as List<MedicationDoseStatus>,
    ));
  }
}

/// @nodoc
mixin _$MedicationDoseStatus {
  String? get doseTime;
  @JsonKey(defaultValue: false)
  bool get taken;

  /// Create a copy of MedicationDoseStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationDoseStatusCopyWith<MedicationDoseStatus> get copyWith =>
      _$MedicationDoseStatusCopyWithImpl<MedicationDoseStatus>(
          this as MedicationDoseStatus, _$identity);

  /// Serializes this MedicationDoseStatus to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationDoseStatus &&
            (identical(other.doseTime, doseTime) ||
                other.doseTime == doseTime) &&
            (identical(other.taken, taken) || other.taken == taken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, doseTime, taken);

  @override
  String toString() {
    return 'MedicationDoseStatus(doseTime: $doseTime, taken: $taken)';
  }
}

/// @nodoc
abstract mixin class $MedicationDoseStatusCopyWith<$Res> {
  factory $MedicationDoseStatusCopyWith(MedicationDoseStatus value,
          $Res Function(MedicationDoseStatus) _then) =
      _$MedicationDoseStatusCopyWithImpl;
  @useResult
  $Res call({String? doseTime, @JsonKey(defaultValue: false) bool taken});
}

/// @nodoc
class _$MedicationDoseStatusCopyWithImpl<$Res>
    implements $MedicationDoseStatusCopyWith<$Res> {
  _$MedicationDoseStatusCopyWithImpl(this._self, this._then);

  final MedicationDoseStatus _self;
  final $Res Function(MedicationDoseStatus) _then;

  /// Create a copy of MedicationDoseStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? doseTime = freezed,
    Object? taken = null,
  }) {
    return _then(_self.copyWith(
      doseTime: freezed == doseTime
          ? _self.doseTime
          : doseTime // ignore: cast_nullable_to_non_nullable
              as String?,
      taken: null == taken
          ? _self.taken
          : taken // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicationDoseStatus].
extension MedicationDoseStatusPatterns on MedicationDoseStatus {
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
    TResult Function(_MedicationDoseStatus value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationDoseStatus() when $default != null:
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
    TResult Function(_MedicationDoseStatus value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationDoseStatus():
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
    TResult? Function(_MedicationDoseStatus value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationDoseStatus() when $default != null:
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
            String? doseTime, @JsonKey(defaultValue: false) bool taken)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationDoseStatus() when $default != null:
        return $default(_that.doseTime, _that.taken);
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
    TResult Function(String? doseTime, @JsonKey(defaultValue: false) bool taken)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationDoseStatus():
        return $default(_that.doseTime, _that.taken);
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
            String? doseTime, @JsonKey(defaultValue: false) bool taken)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationDoseStatus() when $default != null:
        return $default(_that.doseTime, _that.taken);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MedicationDoseStatus implements MedicationDoseStatus {
  const _MedicationDoseStatus(
      {required this.doseTime,
      @JsonKey(defaultValue: false) required this.taken});
  factory _MedicationDoseStatus.fromJson(Map<String, dynamic> json) =>
      _$MedicationDoseStatusFromJson(json);

  @override
  final String? doseTime;
  @override
  @JsonKey(defaultValue: false)
  final bool taken;

  /// Create a copy of MedicationDoseStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationDoseStatusCopyWith<_MedicationDoseStatus> get copyWith =>
      __$MedicationDoseStatusCopyWithImpl<_MedicationDoseStatus>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicationDoseStatusToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationDoseStatus &&
            (identical(other.doseTime, doseTime) ||
                other.doseTime == doseTime) &&
            (identical(other.taken, taken) || other.taken == taken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, doseTime, taken);

  @override
  String toString() {
    return 'MedicationDoseStatus(doseTime: $doseTime, taken: $taken)';
  }
}

/// @nodoc
abstract mixin class _$MedicationDoseStatusCopyWith<$Res>
    implements $MedicationDoseStatusCopyWith<$Res> {
  factory _$MedicationDoseStatusCopyWith(_MedicationDoseStatus value,
          $Res Function(_MedicationDoseStatus) _then) =
      __$MedicationDoseStatusCopyWithImpl;
  @override
  @useResult
  $Res call({String? doseTime, @JsonKey(defaultValue: false) bool taken});
}

/// @nodoc
class __$MedicationDoseStatusCopyWithImpl<$Res>
    implements _$MedicationDoseStatusCopyWith<$Res> {
  __$MedicationDoseStatusCopyWithImpl(this._self, this._then);

  final _MedicationDoseStatus _self;
  final $Res Function(_MedicationDoseStatus) _then;

  /// Create a copy of MedicationDoseStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? doseTime = freezed,
    Object? taken = null,
  }) {
    return _then(_MedicationDoseStatus(
      doseTime: freezed == doseTime
          ? _self.doseTime
          : doseTime // ignore: cast_nullable_to_non_nullable
              as String?,
      taken: null == taken
          ? _self.taken
          : taken // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$Album {
  int? get albumId;
  String? get thumbnailUrl;

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AlbumCopyWith<Album> get copyWith =>
      _$AlbumCopyWithImpl<Album>(this as Album, _$identity);

  /// Serializes this Album to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Album &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, albumId, thumbnailUrl);

  @override
  String toString() {
    return 'Album(albumId: $albumId, thumbnailUrl: $thumbnailUrl)';
  }
}

/// @nodoc
abstract mixin class $AlbumCopyWith<$Res> {
  factory $AlbumCopyWith(Album value, $Res Function(Album) _then) =
      _$AlbumCopyWithImpl;
  @useResult
  $Res call({int? albumId, String? thumbnailUrl});
}

/// @nodoc
class _$AlbumCopyWithImpl<$Res> implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._self, this._then);

  final Album _self;
  final $Res Function(Album) _then;

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? albumId = freezed,
    Object? thumbnailUrl = freezed,
  }) {
    return _then(_self.copyWith(
      albumId: freezed == albumId
          ? _self.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Album].
extension AlbumPatterns on Album {
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
    TResult Function(_Album value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Album() when $default != null:
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
    TResult Function(_Album value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Album():
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
    TResult? Function(_Album value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Album() when $default != null:
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
    TResult Function(int? albumId, String? thumbnailUrl)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Album() when $default != null:
        return $default(_that.albumId, _that.thumbnailUrl);
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
    TResult Function(int? albumId, String? thumbnailUrl) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Album():
        return $default(_that.albumId, _that.thumbnailUrl);
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
    TResult? Function(int? albumId, String? thumbnailUrl)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Album() when $default != null:
        return $default(_that.albumId, _that.thumbnailUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Album implements Album {
  const _Album({required this.albumId, required this.thumbnailUrl});
  factory _Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  @override
  final int? albumId;
  @override
  final String? thumbnailUrl;

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AlbumCopyWith<_Album> get copyWith =>
      __$AlbumCopyWithImpl<_Album>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AlbumToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Album &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, albumId, thumbnailUrl);

  @override
  String toString() {
    return 'Album(albumId: $albumId, thumbnailUrl: $thumbnailUrl)';
  }
}

/// @nodoc
abstract mixin class _$AlbumCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$AlbumCopyWith(_Album value, $Res Function(_Album) _then) =
      __$AlbumCopyWithImpl;
  @override
  @useResult
  $Res call({int? albumId, String? thumbnailUrl});
}

/// @nodoc
class __$AlbumCopyWithImpl<$Res> implements _$AlbumCopyWith<$Res> {
  __$AlbumCopyWithImpl(this._self, this._then);

  final _Album _self;
  final $Res Function(_Album) _then;

  /// Create a copy of Album
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? albumId = freezed,
    Object? thumbnailUrl = freezed,
  }) {
    return _then(_Album(
      albumId: freezed == albumId
          ? _self.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$HealthSchedule {
  String? get scheduleName;
  int? get dday;
  DateTime? get scheduledAt;
  String? get placeAddress;
  double? get latitude;
  double? get longitude;

  /// Create a copy of HealthSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HealthScheduleCopyWith<HealthSchedule> get copyWith =>
      _$HealthScheduleCopyWithImpl<HealthSchedule>(
          this as HealthSchedule, _$identity);

  /// Serializes this HealthSchedule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HealthSchedule &&
            (identical(other.scheduleName, scheduleName) ||
                other.scheduleName == scheduleName) &&
            (identical(other.dday, dday) || other.dday == dday) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.placeAddress, placeAddress) ||
                other.placeAddress == placeAddress) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, scheduleName, dday, scheduledAt,
      placeAddress, latitude, longitude);

  @override
  String toString() {
    return 'HealthSchedule(scheduleName: $scheduleName, dday: $dday, scheduledAt: $scheduledAt, placeAddress: $placeAddress, latitude: $latitude, longitude: $longitude)';
  }
}

/// @nodoc
abstract mixin class $HealthScheduleCopyWith<$Res> {
  factory $HealthScheduleCopyWith(
          HealthSchedule value, $Res Function(HealthSchedule) _then) =
      _$HealthScheduleCopyWithImpl;
  @useResult
  $Res call(
      {String? scheduleName,
      int? dday,
      DateTime? scheduledAt,
      String? placeAddress,
      double? latitude,
      double? longitude});
}

/// @nodoc
class _$HealthScheduleCopyWithImpl<$Res>
    implements $HealthScheduleCopyWith<$Res> {
  _$HealthScheduleCopyWithImpl(this._self, this._then);

  final HealthSchedule _self;
  final $Res Function(HealthSchedule) _then;

  /// Create a copy of HealthSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleName = freezed,
    Object? dday = freezed,
    Object? scheduledAt = freezed,
    Object? placeAddress = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_self.copyWith(
      scheduleName: freezed == scheduleName
          ? _self.scheduleName
          : scheduleName // ignore: cast_nullable_to_non_nullable
              as String?,
      dday: freezed == dday
          ? _self.dday
          : dday // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledAt: freezed == scheduledAt
          ? _self.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      placeAddress: freezed == placeAddress
          ? _self.placeAddress
          : placeAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HealthSchedule].
extension HealthSchedulePatterns on HealthSchedule {
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
    TResult Function(_HealthSchedule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HealthSchedule() when $default != null:
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
    TResult Function(_HealthSchedule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthSchedule():
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
    TResult? Function(_HealthSchedule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthSchedule() when $default != null:
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
    TResult Function(String? scheduleName, int? dday, DateTime? scheduledAt,
            String? placeAddress, double? latitude, double? longitude)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HealthSchedule() when $default != null:
        return $default(_that.scheduleName, _that.dday, _that.scheduledAt,
            _that.placeAddress, _that.latitude, _that.longitude);
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
    TResult Function(String? scheduleName, int? dday, DateTime? scheduledAt,
            String? placeAddress, double? latitude, double? longitude)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthSchedule():
        return $default(_that.scheduleName, _that.dday, _that.scheduledAt,
            _that.placeAddress, _that.latitude, _that.longitude);
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
    TResult? Function(String? scheduleName, int? dday, DateTime? scheduledAt,
            String? placeAddress, double? latitude, double? longitude)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthSchedule() when $default != null:
        return $default(_that.scheduleName, _that.dday, _that.scheduledAt,
            _that.placeAddress, _that.latitude, _that.longitude);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HealthSchedule implements HealthSchedule {
  const _HealthSchedule(
      {required this.scheduleName,
      required this.dday,
      required this.scheduledAt,
      required this.placeAddress,
      required this.latitude,
      required this.longitude});
  factory _HealthSchedule.fromJson(Map<String, dynamic> json) =>
      _$HealthScheduleFromJson(json);

  @override
  final String? scheduleName;
  @override
  final int? dday;
  @override
  final DateTime? scheduledAt;
  @override
  final String? placeAddress;
  @override
  final double? latitude;
  @override
  final double? longitude;

  /// Create a copy of HealthSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HealthScheduleCopyWith<_HealthSchedule> get copyWith =>
      __$HealthScheduleCopyWithImpl<_HealthSchedule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HealthScheduleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HealthSchedule &&
            (identical(other.scheduleName, scheduleName) ||
                other.scheduleName == scheduleName) &&
            (identical(other.dday, dday) || other.dday == dday) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.placeAddress, placeAddress) ||
                other.placeAddress == placeAddress) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, scheduleName, dday, scheduledAt,
      placeAddress, latitude, longitude);

  @override
  String toString() {
    return 'HealthSchedule(scheduleName: $scheduleName, dday: $dday, scheduledAt: $scheduledAt, placeAddress: $placeAddress, latitude: $latitude, longitude: $longitude)';
  }
}

/// @nodoc
abstract mixin class _$HealthScheduleCopyWith<$Res>
    implements $HealthScheduleCopyWith<$Res> {
  factory _$HealthScheduleCopyWith(
          _HealthSchedule value, $Res Function(_HealthSchedule) _then) =
      __$HealthScheduleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? scheduleName,
      int? dday,
      DateTime? scheduledAt,
      String? placeAddress,
      double? latitude,
      double? longitude});
}

/// @nodoc
class __$HealthScheduleCopyWithImpl<$Res>
    implements _$HealthScheduleCopyWith<$Res> {
  __$HealthScheduleCopyWithImpl(this._self, this._then);

  final _HealthSchedule _self;
  final $Res Function(_HealthSchedule) _then;

  /// Create a copy of HealthSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? scheduleName = freezed,
    Object? dday = freezed,
    Object? scheduledAt = freezed,
    Object? placeAddress = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_HealthSchedule(
      scheduleName: freezed == scheduleName
          ? _self.scheduleName
          : scheduleName // ignore: cast_nullable_to_non_nullable
              as String?,
      dday: freezed == dday
          ? _self.dday
          : dday // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledAt: freezed == scheduledAt
          ? _self.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      placeAddress: freezed == placeAddress
          ? _self.placeAddress
          : placeAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
mixin _$StepProgress {
  int? get actual;
  int? get goal;

  /// Create a copy of StepProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StepProgressCopyWith<StepProgress> get copyWith =>
      _$StepProgressCopyWithImpl<StepProgress>(
          this as StepProgress, _$identity);

  /// Serializes this StepProgress to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StepProgress &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.goal, goal) || other.goal == goal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, actual, goal);

  @override
  String toString() {
    return 'StepProgress(actual: $actual, goal: $goal)';
  }
}

/// @nodoc
abstract mixin class $StepProgressCopyWith<$Res> {
  factory $StepProgressCopyWith(
          StepProgress value, $Res Function(StepProgress) _then) =
      _$StepProgressCopyWithImpl;
  @useResult
  $Res call({int? actual, int? goal});
}

/// @nodoc
class _$StepProgressCopyWithImpl<$Res> implements $StepProgressCopyWith<$Res> {
  _$StepProgressCopyWithImpl(this._self, this._then);

  final StepProgress _self;
  final $Res Function(StepProgress) _then;

  /// Create a copy of StepProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actual = freezed,
    Object? goal = freezed,
  }) {
    return _then(_self.copyWith(
      actual: freezed == actual
          ? _self.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as int?,
      goal: freezed == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [StepProgress].
extension StepProgressPatterns on StepProgress {
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
    TResult Function(_StepProgress value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StepProgress() when $default != null:
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
    TResult Function(_StepProgress value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StepProgress():
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
    TResult? Function(_StepProgress value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StepProgress() when $default != null:
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
    TResult Function(int? actual, int? goal)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StepProgress() when $default != null:
        return $default(_that.actual, _that.goal);
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
    TResult Function(int? actual, int? goal) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StepProgress():
        return $default(_that.actual, _that.goal);
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
    TResult? Function(int? actual, int? goal)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StepProgress() when $default != null:
        return $default(_that.actual, _that.goal);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StepProgress implements StepProgress {
  const _StepProgress({required this.actual, required this.goal});
  factory _StepProgress.fromJson(Map<String, dynamic> json) =>
      _$StepProgressFromJson(json);

  @override
  final int? actual;
  @override
  final int? goal;

  /// Create a copy of StepProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StepProgressCopyWith<_StepProgress> get copyWith =>
      __$StepProgressCopyWithImpl<_StepProgress>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StepProgressToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StepProgress &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.goal, goal) || other.goal == goal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, actual, goal);

  @override
  String toString() {
    return 'StepProgress(actual: $actual, goal: $goal)';
  }
}

/// @nodoc
abstract mixin class _$StepProgressCopyWith<$Res>
    implements $StepProgressCopyWith<$Res> {
  factory _$StepProgressCopyWith(
          _StepProgress value, $Res Function(_StepProgress) _then) =
      __$StepProgressCopyWithImpl;
  @override
  @useResult
  $Res call({int? actual, int? goal});
}

/// @nodoc
class __$StepProgressCopyWithImpl<$Res>
    implements _$StepProgressCopyWith<$Res> {
  __$StepProgressCopyWithImpl(this._self, this._then);

  final _StepProgress _self;
  final $Res Function(_StepProgress) _then;

  /// Create a copy of StepProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? actual = freezed,
    Object? goal = freezed,
  }) {
    return _then(_StepProgress(
      actual: freezed == actual
          ? _self.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as int?,
      goal: freezed == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
