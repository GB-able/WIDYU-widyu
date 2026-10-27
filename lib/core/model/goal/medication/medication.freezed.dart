// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Medication {
  int get medicineScheduleId;
  int get takenCount;
  int get totalCount;
  int get nextDoseCount;
  String get nextAlarmTime;
  @JsonKey(name: 'proofImageUrl')
  String? get proofImage;
  bool? get isReward;

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationCopyWith<Medication> get copyWith =>
      _$MedicationCopyWithImpl<Medication>(this as Medication, _$identity);

  /// Serializes this Medication to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Medication &&
            (identical(other.medicineScheduleId, medicineScheduleId) ||
                other.medicineScheduleId == medicineScheduleId) &&
            (identical(other.takenCount, takenCount) ||
                other.takenCount == takenCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.nextDoseCount, nextDoseCount) ||
                other.nextDoseCount == nextDoseCount) &&
            (identical(other.nextAlarmTime, nextAlarmTime) ||
                other.nextAlarmTime == nextAlarmTime) &&
            (identical(other.proofImage, proofImage) ||
                other.proofImage == proofImage) &&
            (identical(other.isReward, isReward) ||
                other.isReward == isReward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, medicineScheduleId, takenCount,
      totalCount, nextDoseCount, nextAlarmTime, proofImage, isReward);

  @override
  String toString() {
    return 'Medication(medicineScheduleId: $medicineScheduleId, takenCount: $takenCount, totalCount: $totalCount, nextDoseCount: $nextDoseCount, nextAlarmTime: $nextAlarmTime, proofImage: $proofImage, isReward: $isReward)';
  }
}

/// @nodoc
abstract mixin class $MedicationCopyWith<$Res> {
  factory $MedicationCopyWith(
          Medication value, $Res Function(Medication) _then) =
      _$MedicationCopyWithImpl;
  @useResult
  $Res call(
      {int medicineScheduleId,
      int takenCount,
      int totalCount,
      int nextDoseCount,
      String nextAlarmTime,
      @JsonKey(name: 'proofImageUrl') String? proofImage,
      bool? isReward});
}

/// @nodoc
class _$MedicationCopyWithImpl<$Res> implements $MedicationCopyWith<$Res> {
  _$MedicationCopyWithImpl(this._self, this._then);

  final Medication _self;
  final $Res Function(Medication) _then;

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicineScheduleId = null,
    Object? takenCount = null,
    Object? totalCount = null,
    Object? nextDoseCount = null,
    Object? nextAlarmTime = null,
    Object? proofImage = freezed,
    Object? isReward = freezed,
  }) {
    return _then(_self.copyWith(
      medicineScheduleId: null == medicineScheduleId
          ? _self.medicineScheduleId
          : medicineScheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      takenCount: null == takenCount
          ? _self.takenCount
          : takenCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      nextDoseCount: null == nextDoseCount
          ? _self.nextDoseCount
          : nextDoseCount // ignore: cast_nullable_to_non_nullable
              as int,
      nextAlarmTime: null == nextAlarmTime
          ? _self.nextAlarmTime
          : nextAlarmTime // ignore: cast_nullable_to_non_nullable
              as String,
      proofImage: freezed == proofImage
          ? _self.proofImage
          : proofImage // ignore: cast_nullable_to_non_nullable
              as String?,
      isReward: freezed == isReward
          ? _self.isReward
          : isReward // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Medication].
extension MedicationPatterns on Medication {
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
    TResult Function(_Medication value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Medication() when $default != null:
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
    TResult Function(_Medication value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Medication():
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
    TResult? Function(_Medication value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Medication() when $default != null:
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
            int medicineScheduleId,
            int takenCount,
            int totalCount,
            int nextDoseCount,
            String nextAlarmTime,
            @JsonKey(name: 'proofImageUrl') String? proofImage,
            bool? isReward)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Medication() when $default != null:
        return $default(
            _that.medicineScheduleId,
            _that.takenCount,
            _that.totalCount,
            _that.nextDoseCount,
            _that.nextAlarmTime,
            _that.proofImage,
            _that.isReward);
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
            int medicineScheduleId,
            int takenCount,
            int totalCount,
            int nextDoseCount,
            String nextAlarmTime,
            @JsonKey(name: 'proofImageUrl') String? proofImage,
            bool? isReward)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Medication():
        return $default(
            _that.medicineScheduleId,
            _that.takenCount,
            _that.totalCount,
            _that.nextDoseCount,
            _that.nextAlarmTime,
            _that.proofImage,
            _that.isReward);
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
            int medicineScheduleId,
            int takenCount,
            int totalCount,
            int nextDoseCount,
            String nextAlarmTime,
            @JsonKey(name: 'proofImageUrl') String? proofImage,
            bool? isReward)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Medication() when $default != null:
        return $default(
            _that.medicineScheduleId,
            _that.takenCount,
            _that.totalCount,
            _that.nextDoseCount,
            _that.nextAlarmTime,
            _that.proofImage,
            _that.isReward);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Medication extends Medication {
  const _Medication(
      {required this.medicineScheduleId,
      required this.takenCount,
      required this.totalCount,
      required this.nextDoseCount,
      required this.nextAlarmTime,
      @JsonKey(name: 'proofImageUrl') required this.proofImage,
      this.isReward})
      : super._();
  factory _Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  @override
  final int medicineScheduleId;
  @override
  final int takenCount;
  @override
  final int totalCount;
  @override
  final int nextDoseCount;
  @override
  final String nextAlarmTime;
  @override
  @JsonKey(name: 'proofImageUrl')
  final String? proofImage;
  @override
  final bool? isReward;

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationCopyWith<_Medication> get copyWith =>
      __$MedicationCopyWithImpl<_Medication>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Medication &&
            (identical(other.medicineScheduleId, medicineScheduleId) ||
                other.medicineScheduleId == medicineScheduleId) &&
            (identical(other.takenCount, takenCount) ||
                other.takenCount == takenCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.nextDoseCount, nextDoseCount) ||
                other.nextDoseCount == nextDoseCount) &&
            (identical(other.nextAlarmTime, nextAlarmTime) ||
                other.nextAlarmTime == nextAlarmTime) &&
            (identical(other.proofImage, proofImage) ||
                other.proofImage == proofImage) &&
            (identical(other.isReward, isReward) ||
                other.isReward == isReward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, medicineScheduleId, takenCount,
      totalCount, nextDoseCount, nextAlarmTime, proofImage, isReward);

  @override
  String toString() {
    return 'Medication(medicineScheduleId: $medicineScheduleId, takenCount: $takenCount, totalCount: $totalCount, nextDoseCount: $nextDoseCount, nextAlarmTime: $nextAlarmTime, proofImage: $proofImage, isReward: $isReward)';
  }
}

/// @nodoc
abstract mixin class _$MedicationCopyWith<$Res>
    implements $MedicationCopyWith<$Res> {
  factory _$MedicationCopyWith(
          _Medication value, $Res Function(_Medication) _then) =
      __$MedicationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int medicineScheduleId,
      int takenCount,
      int totalCount,
      int nextDoseCount,
      String nextAlarmTime,
      @JsonKey(name: 'proofImageUrl') String? proofImage,
      bool? isReward});
}

/// @nodoc
class __$MedicationCopyWithImpl<$Res> implements _$MedicationCopyWith<$Res> {
  __$MedicationCopyWithImpl(this._self, this._then);

  final _Medication _self;
  final $Res Function(_Medication) _then;

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? medicineScheduleId = null,
    Object? takenCount = null,
    Object? totalCount = null,
    Object? nextDoseCount = null,
    Object? nextAlarmTime = null,
    Object? proofImage = freezed,
    Object? isReward = freezed,
  }) {
    return _then(_Medication(
      medicineScheduleId: null == medicineScheduleId
          ? _self.medicineScheduleId
          : medicineScheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      takenCount: null == takenCount
          ? _self.takenCount
          : takenCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      nextDoseCount: null == nextDoseCount
          ? _self.nextDoseCount
          : nextDoseCount // ignore: cast_nullable_to_non_nullable
              as int,
      nextAlarmTime: null == nextAlarmTime
          ? _self.nextAlarmTime
          : nextAlarmTime // ignore: cast_nullable_to_non_nullable
              as String,
      proofImage: freezed == proofImage
          ? _self.proofImage
          : proofImage // ignore: cast_nullable_to_non_nullable
              as String?,
      isReward: freezed == isReward
          ? _self.isReward
          : isReward // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
