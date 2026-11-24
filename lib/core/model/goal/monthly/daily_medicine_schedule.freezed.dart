// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_medicine_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyMedicineSchedule {
  int get medicineScheduleId; // 알약 수라 0.5정처럼 소수일 수 있다.
  double? get totalCount;
  String get alarmTime;
  MedicineDoseState get status;
  String? get proofImageUrl;

  /// Create a copy of DailyMedicineSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DailyMedicineScheduleCopyWith<DailyMedicineSchedule> get copyWith =>
      _$DailyMedicineScheduleCopyWithImpl<DailyMedicineSchedule>(
          this as DailyMedicineSchedule, _$identity);

  /// Serializes this DailyMedicineSchedule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DailyMedicineSchedule &&
            (identical(other.medicineScheduleId, medicineScheduleId) ||
                other.medicineScheduleId == medicineScheduleId) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.alarmTime, alarmTime) ||
                other.alarmTime == alarmTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.proofImageUrl, proofImageUrl) ||
                other.proofImageUrl == proofImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, medicineScheduleId, totalCount,
      alarmTime, status, proofImageUrl);

  @override
  String toString() {
    return 'DailyMedicineSchedule(medicineScheduleId: $medicineScheduleId, totalCount: $totalCount, alarmTime: $alarmTime, status: $status, proofImageUrl: $proofImageUrl)';
  }
}

/// @nodoc
abstract mixin class $DailyMedicineScheduleCopyWith<$Res> {
  factory $DailyMedicineScheduleCopyWith(DailyMedicineSchedule value,
          $Res Function(DailyMedicineSchedule) _then) =
      _$DailyMedicineScheduleCopyWithImpl;
  @useResult
  $Res call(
      {int medicineScheduleId,
      double? totalCount,
      String alarmTime,
      MedicineDoseState status,
      String? proofImageUrl});
}

/// @nodoc
class _$DailyMedicineScheduleCopyWithImpl<$Res>
    implements $DailyMedicineScheduleCopyWith<$Res> {
  _$DailyMedicineScheduleCopyWithImpl(this._self, this._then);

  final DailyMedicineSchedule _self;
  final $Res Function(DailyMedicineSchedule) _then;

  /// Create a copy of DailyMedicineSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicineScheduleId = null,
    Object? totalCount = freezed,
    Object? alarmTime = null,
    Object? status = null,
    Object? proofImageUrl = freezed,
  }) {
    return _then(_self.copyWith(
      medicineScheduleId: null == medicineScheduleId
          ? _self.medicineScheduleId
          : medicineScheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: freezed == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as double?,
      alarmTime: null == alarmTime
          ? _self.alarmTime
          : alarmTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MedicineDoseState,
      proofImageUrl: freezed == proofImageUrl
          ? _self.proofImageUrl
          : proofImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DailyMedicineSchedule].
extension DailyMedicineSchedulePatterns on DailyMedicineSchedule {
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
    TResult Function(_DailyMedicineSchedule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailyMedicineSchedule() when $default != null:
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
    TResult Function(_DailyMedicineSchedule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyMedicineSchedule():
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
    TResult? Function(_DailyMedicineSchedule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyMedicineSchedule() when $default != null:
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
    TResult Function(int medicineScheduleId, double? totalCount,
            String alarmTime, MedicineDoseState status, String? proofImageUrl)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailyMedicineSchedule() when $default != null:
        return $default(_that.medicineScheduleId, _that.totalCount,
            _that.alarmTime, _that.status, _that.proofImageUrl);
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
    TResult Function(int medicineScheduleId, double? totalCount,
            String alarmTime, MedicineDoseState status, String? proofImageUrl)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyMedicineSchedule():
        return $default(_that.medicineScheduleId, _that.totalCount,
            _that.alarmTime, _that.status, _that.proofImageUrl);
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
    TResult? Function(int medicineScheduleId, double? totalCount,
            String alarmTime, MedicineDoseState status, String? proofImageUrl)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyMedicineSchedule() when $default != null:
        return $default(_that.medicineScheduleId, _that.totalCount,
            _that.alarmTime, _that.status, _that.proofImageUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DailyMedicineSchedule implements DailyMedicineSchedule {
  const _DailyMedicineSchedule(
      {required this.medicineScheduleId,
      this.totalCount,
      required this.alarmTime,
      required this.status,
      this.proofImageUrl});
  factory _DailyMedicineSchedule.fromJson(Map<String, dynamic> json) =>
      _$DailyMedicineScheduleFromJson(json);

  @override
  final int medicineScheduleId;
// 알약 수라 0.5정처럼 소수일 수 있다.
  @override
  final double? totalCount;
  @override
  final String alarmTime;
  @override
  final MedicineDoseState status;
  @override
  final String? proofImageUrl;

  /// Create a copy of DailyMedicineSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DailyMedicineScheduleCopyWith<_DailyMedicineSchedule> get copyWith =>
      __$DailyMedicineScheduleCopyWithImpl<_DailyMedicineSchedule>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DailyMedicineScheduleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DailyMedicineSchedule &&
            (identical(other.medicineScheduleId, medicineScheduleId) ||
                other.medicineScheduleId == medicineScheduleId) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.alarmTime, alarmTime) ||
                other.alarmTime == alarmTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.proofImageUrl, proofImageUrl) ||
                other.proofImageUrl == proofImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, medicineScheduleId, totalCount,
      alarmTime, status, proofImageUrl);

  @override
  String toString() {
    return 'DailyMedicineSchedule(medicineScheduleId: $medicineScheduleId, totalCount: $totalCount, alarmTime: $alarmTime, status: $status, proofImageUrl: $proofImageUrl)';
  }
}

/// @nodoc
abstract mixin class _$DailyMedicineScheduleCopyWith<$Res>
    implements $DailyMedicineScheduleCopyWith<$Res> {
  factory _$DailyMedicineScheduleCopyWith(_DailyMedicineSchedule value,
          $Res Function(_DailyMedicineSchedule) _then) =
      __$DailyMedicineScheduleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int medicineScheduleId,
      double? totalCount,
      String alarmTime,
      MedicineDoseState status,
      String? proofImageUrl});
}

/// @nodoc
class __$DailyMedicineScheduleCopyWithImpl<$Res>
    implements _$DailyMedicineScheduleCopyWith<$Res> {
  __$DailyMedicineScheduleCopyWithImpl(this._self, this._then);

  final _DailyMedicineSchedule _self;
  final $Res Function(_DailyMedicineSchedule) _then;

  /// Create a copy of DailyMedicineSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? medicineScheduleId = null,
    Object? totalCount = freezed,
    Object? alarmTime = null,
    Object? status = null,
    Object? proofImageUrl = freezed,
  }) {
    return _then(_DailyMedicineSchedule(
      medicineScheduleId: null == medicineScheduleId
          ? _self.medicineScheduleId
          : medicineScheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: freezed == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as double?,
      alarmTime: null == alarmTime
          ? _self.alarmTime
          : alarmTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MedicineDoseState,
      proofImageUrl: freezed == proofImageUrl
          ? _self.proofImageUrl
          : proofImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
