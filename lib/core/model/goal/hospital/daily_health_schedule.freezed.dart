// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_health_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyHealthSchedule {
  int get healthScheduleId;
  String get scheduleName;
  DateTime get scheduledAt;
  String? get placeAddress;
  double? get latitude;
  double? get longitude;
  HealthScheduleState get progressStatus;

  /// Create a copy of DailyHealthSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DailyHealthScheduleCopyWith<DailyHealthSchedule> get copyWith =>
      _$DailyHealthScheduleCopyWithImpl<DailyHealthSchedule>(
          this as DailyHealthSchedule, _$identity);

  /// Serializes this DailyHealthSchedule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DailyHealthSchedule &&
            (identical(other.healthScheduleId, healthScheduleId) ||
                other.healthScheduleId == healthScheduleId) &&
            (identical(other.scheduleName, scheduleName) ||
                other.scheduleName == scheduleName) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.placeAddress, placeAddress) ||
                other.placeAddress == placeAddress) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.progressStatus, progressStatus) ||
                other.progressStatus == progressStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, healthScheduleId, scheduleName,
      scheduledAt, placeAddress, latitude, longitude, progressStatus);

  @override
  String toString() {
    return 'DailyHealthSchedule(healthScheduleId: $healthScheduleId, scheduleName: $scheduleName, scheduledAt: $scheduledAt, placeAddress: $placeAddress, latitude: $latitude, longitude: $longitude, progressStatus: $progressStatus)';
  }
}

/// @nodoc
abstract mixin class $DailyHealthScheduleCopyWith<$Res> {
  factory $DailyHealthScheduleCopyWith(
          DailyHealthSchedule value, $Res Function(DailyHealthSchedule) _then) =
      _$DailyHealthScheduleCopyWithImpl;
  @useResult
  $Res call(
      {int healthScheduleId,
      String scheduleName,
      DateTime scheduledAt,
      String? placeAddress,
      double? latitude,
      double? longitude,
      HealthScheduleState progressStatus});
}

/// @nodoc
class _$DailyHealthScheduleCopyWithImpl<$Res>
    implements $DailyHealthScheduleCopyWith<$Res> {
  _$DailyHealthScheduleCopyWithImpl(this._self, this._then);

  final DailyHealthSchedule _self;
  final $Res Function(DailyHealthSchedule) _then;

  /// Create a copy of DailyHealthSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? healthScheduleId = null,
    Object? scheduleName = null,
    Object? scheduledAt = null,
    Object? placeAddress = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? progressStatus = null,
  }) {
    return _then(_self.copyWith(
      healthScheduleId: null == healthScheduleId
          ? _self.healthScheduleId
          : healthScheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleName: null == scheduleName
          ? _self.scheduleName
          : scheduleName // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledAt: null == scheduledAt
          ? _self.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      progressStatus: null == progressStatus
          ? _self.progressStatus
          : progressStatus // ignore: cast_nullable_to_non_nullable
              as HealthScheduleState,
    ));
  }
}

/// Adds pattern-matching-related methods to [DailyHealthSchedule].
extension DailyHealthSchedulePatterns on DailyHealthSchedule {
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
    TResult Function(_DailyHealthSchedule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailyHealthSchedule() when $default != null:
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
    TResult Function(_DailyHealthSchedule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyHealthSchedule():
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
    TResult? Function(_DailyHealthSchedule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyHealthSchedule() when $default != null:
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
            int healthScheduleId,
            String scheduleName,
            DateTime scheduledAt,
            String? placeAddress,
            double? latitude,
            double? longitude,
            HealthScheduleState progressStatus)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailyHealthSchedule() when $default != null:
        return $default(
            _that.healthScheduleId,
            _that.scheduleName,
            _that.scheduledAt,
            _that.placeAddress,
            _that.latitude,
            _that.longitude,
            _that.progressStatus);
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
            int healthScheduleId,
            String scheduleName,
            DateTime scheduledAt,
            String? placeAddress,
            double? latitude,
            double? longitude,
            HealthScheduleState progressStatus)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyHealthSchedule():
        return $default(
            _that.healthScheduleId,
            _that.scheduleName,
            _that.scheduledAt,
            _that.placeAddress,
            _that.latitude,
            _that.longitude,
            _that.progressStatus);
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
            int healthScheduleId,
            String scheduleName,
            DateTime scheduledAt,
            String? placeAddress,
            double? latitude,
            double? longitude,
            HealthScheduleState progressStatus)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyHealthSchedule() when $default != null:
        return $default(
            _that.healthScheduleId,
            _that.scheduleName,
            _that.scheduledAt,
            _that.placeAddress,
            _that.latitude,
            _that.longitude,
            _that.progressStatus);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DailyHealthSchedule implements DailyHealthSchedule {
  const _DailyHealthSchedule(
      {required this.healthScheduleId,
      required this.scheduleName,
      required this.scheduledAt,
      this.placeAddress,
      this.latitude,
      this.longitude,
      required this.progressStatus});
  factory _DailyHealthSchedule.fromJson(Map<String, dynamic> json) =>
      _$DailyHealthScheduleFromJson(json);

  @override
  final int healthScheduleId;
  @override
  final String scheduleName;
  @override
  final DateTime scheduledAt;
  @override
  final String? placeAddress;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final HealthScheduleState progressStatus;

  /// Create a copy of DailyHealthSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DailyHealthScheduleCopyWith<_DailyHealthSchedule> get copyWith =>
      __$DailyHealthScheduleCopyWithImpl<_DailyHealthSchedule>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DailyHealthScheduleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DailyHealthSchedule &&
            (identical(other.healthScheduleId, healthScheduleId) ||
                other.healthScheduleId == healthScheduleId) &&
            (identical(other.scheduleName, scheduleName) ||
                other.scheduleName == scheduleName) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.placeAddress, placeAddress) ||
                other.placeAddress == placeAddress) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.progressStatus, progressStatus) ||
                other.progressStatus == progressStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, healthScheduleId, scheduleName,
      scheduledAt, placeAddress, latitude, longitude, progressStatus);

  @override
  String toString() {
    return 'DailyHealthSchedule(healthScheduleId: $healthScheduleId, scheduleName: $scheduleName, scheduledAt: $scheduledAt, placeAddress: $placeAddress, latitude: $latitude, longitude: $longitude, progressStatus: $progressStatus)';
  }
}

/// @nodoc
abstract mixin class _$DailyHealthScheduleCopyWith<$Res>
    implements $DailyHealthScheduleCopyWith<$Res> {
  factory _$DailyHealthScheduleCopyWith(_DailyHealthSchedule value,
          $Res Function(_DailyHealthSchedule) _then) =
      __$DailyHealthScheduleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int healthScheduleId,
      String scheduleName,
      DateTime scheduledAt,
      String? placeAddress,
      double? latitude,
      double? longitude,
      HealthScheduleState progressStatus});
}

/// @nodoc
class __$DailyHealthScheduleCopyWithImpl<$Res>
    implements _$DailyHealthScheduleCopyWith<$Res> {
  __$DailyHealthScheduleCopyWithImpl(this._self, this._then);

  final _DailyHealthSchedule _self;
  final $Res Function(_DailyHealthSchedule) _then;

  /// Create a copy of DailyHealthSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? healthScheduleId = null,
    Object? scheduleName = null,
    Object? scheduledAt = null,
    Object? placeAddress = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? progressStatus = null,
  }) {
    return _then(_DailyHealthSchedule(
      healthScheduleId: null == healthScheduleId
          ? _self.healthScheduleId
          : healthScheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleName: null == scheduleName
          ? _self.scheduleName
          : scheduleName // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledAt: null == scheduledAt
          ? _self.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      progressStatus: null == progressStatus
          ? _self.progressStatus
          : progressStatus // ignore: cast_nullable_to_non_nullable
              as HealthScheduleState,
    ));
  }
}

// dart format on
