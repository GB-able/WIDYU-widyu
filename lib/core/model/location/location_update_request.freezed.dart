// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_update_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationUpdateRequest {
  int get v;
  int get memberId;
  @JsonKey(name: 'device_id')
  String get deviceId;
  @JsonKey(name: 'session_id')
  String get sessionId;
  int get seq;

  /// 위치를 **잰** 시각(epoch ms). 보낸 시각이 아니다.
  @JsonKey(name: 'ts_ms')
  int get tsMs;
  String get reason;
  double get lat;
  double get lon;

  /// 모의 위치가 아니어도 `false` 를 실어 보낸다(서버 권장).
  @JsonKey(name: 'is_mock')
  bool get isMock;
  @JsonKey(name: 'accuracy_m')
  double? get accuracyM;
  @JsonKey(name: 'speed_mps')
  double? get speedMps;
  @JsonKey(name: 'speed_accuracy_mps')
  double? get speedAccuracyMps;
  @JsonKey(name: 'heading_deg')
  double? get headingDeg;
  @JsonKey(name: 'altitude_m')
  double? get altitudeM;

  /// Create a copy of LocationUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocationUpdateRequestCopyWith<LocationUpdateRequest> get copyWith =>
      _$LocationUpdateRequestCopyWithImpl<LocationUpdateRequest>(
          this as LocationUpdateRequest, _$identity);

  /// Serializes this LocationUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocationUpdateRequest &&
            (identical(other.v, v) || other.v == v) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.isMock, isMock) || other.isMock == isMock) &&
            (identical(other.accuracyM, accuracyM) ||
                other.accuracyM == accuracyM) &&
            (identical(other.speedMps, speedMps) ||
                other.speedMps == speedMps) &&
            (identical(other.speedAccuracyMps, speedAccuracyMps) ||
                other.speedAccuracyMps == speedAccuracyMps) &&
            (identical(other.headingDeg, headingDeg) ||
                other.headingDeg == headingDeg) &&
            (identical(other.altitudeM, altitudeM) ||
                other.altitudeM == altitudeM));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      v,
      memberId,
      deviceId,
      sessionId,
      seq,
      tsMs,
      reason,
      lat,
      lon,
      isMock,
      accuracyM,
      speedMps,
      speedAccuracyMps,
      headingDeg,
      altitudeM);

  @override
  String toString() {
    return 'LocationUpdateRequest(v: $v, memberId: $memberId, deviceId: $deviceId, sessionId: $sessionId, seq: $seq, tsMs: $tsMs, reason: $reason, lat: $lat, lon: $lon, isMock: $isMock, accuracyM: $accuracyM, speedMps: $speedMps, speedAccuracyMps: $speedAccuracyMps, headingDeg: $headingDeg, altitudeM: $altitudeM)';
  }
}

/// @nodoc
abstract mixin class $LocationUpdateRequestCopyWith<$Res> {
  factory $LocationUpdateRequestCopyWith(LocationUpdateRequest value,
          $Res Function(LocationUpdateRequest) _then) =
      _$LocationUpdateRequestCopyWithImpl;
  @useResult
  $Res call(
      {int v,
      int memberId,
      @JsonKey(name: 'device_id') String deviceId,
      @JsonKey(name: 'session_id') String sessionId,
      int seq,
      @JsonKey(name: 'ts_ms') int tsMs,
      String reason,
      double lat,
      double lon,
      @JsonKey(name: 'is_mock') bool isMock,
      @JsonKey(name: 'accuracy_m') double? accuracyM,
      @JsonKey(name: 'speed_mps') double? speedMps,
      @JsonKey(name: 'speed_accuracy_mps') double? speedAccuracyMps,
      @JsonKey(name: 'heading_deg') double? headingDeg,
      @JsonKey(name: 'altitude_m') double? altitudeM});
}

/// @nodoc
class _$LocationUpdateRequestCopyWithImpl<$Res>
    implements $LocationUpdateRequestCopyWith<$Res> {
  _$LocationUpdateRequestCopyWithImpl(this._self, this._then);

  final LocationUpdateRequest _self;
  final $Res Function(LocationUpdateRequest) _then;

  /// Create a copy of LocationUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? v = null,
    Object? memberId = null,
    Object? deviceId = null,
    Object? sessionId = null,
    Object? seq = null,
    Object? tsMs = null,
    Object? reason = null,
    Object? lat = null,
    Object? lon = null,
    Object? isMock = null,
    Object? accuracyM = freezed,
    Object? speedMps = freezed,
    Object? speedAccuracyMps = freezed,
    Object? headingDeg = freezed,
    Object? altitudeM = freezed,
  }) {
    return _then(_self.copyWith(
      v: null == v
          ? _self.v
          : v // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      deviceId: null == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      seq: null == seq
          ? _self.seq
          : seq // ignore: cast_nullable_to_non_nullable
              as int,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _self.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      isMock: null == isMock
          ? _self.isMock
          : isMock // ignore: cast_nullable_to_non_nullable
              as bool,
      accuracyM: freezed == accuracyM
          ? _self.accuracyM
          : accuracyM // ignore: cast_nullable_to_non_nullable
              as double?,
      speedMps: freezed == speedMps
          ? _self.speedMps
          : speedMps // ignore: cast_nullable_to_non_nullable
              as double?,
      speedAccuracyMps: freezed == speedAccuracyMps
          ? _self.speedAccuracyMps
          : speedAccuracyMps // ignore: cast_nullable_to_non_nullable
              as double?,
      headingDeg: freezed == headingDeg
          ? _self.headingDeg
          : headingDeg // ignore: cast_nullable_to_non_nullable
              as double?,
      altitudeM: freezed == altitudeM
          ? _self.altitudeM
          : altitudeM // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LocationUpdateRequest].
extension LocationUpdateRequestPatterns on LocationUpdateRequest {
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
    TResult Function(_LocationUpdateRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocationUpdateRequest() when $default != null:
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
    TResult Function(_LocationUpdateRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationUpdateRequest():
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
    TResult? Function(_LocationUpdateRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationUpdateRequest() when $default != null:
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
            int v,
            int memberId,
            @JsonKey(name: 'device_id') String deviceId,
            @JsonKey(name: 'session_id') String sessionId,
            int seq,
            @JsonKey(name: 'ts_ms') int tsMs,
            String reason,
            double lat,
            double lon,
            @JsonKey(name: 'is_mock') bool isMock,
            @JsonKey(name: 'accuracy_m') double? accuracyM,
            @JsonKey(name: 'speed_mps') double? speedMps,
            @JsonKey(name: 'speed_accuracy_mps') double? speedAccuracyMps,
            @JsonKey(name: 'heading_deg') double? headingDeg,
            @JsonKey(name: 'altitude_m') double? altitudeM)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocationUpdateRequest() when $default != null:
        return $default(
            _that.v,
            _that.memberId,
            _that.deviceId,
            _that.sessionId,
            _that.seq,
            _that.tsMs,
            _that.reason,
            _that.lat,
            _that.lon,
            _that.isMock,
            _that.accuracyM,
            _that.speedMps,
            _that.speedAccuracyMps,
            _that.headingDeg,
            _that.altitudeM);
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
            int v,
            int memberId,
            @JsonKey(name: 'device_id') String deviceId,
            @JsonKey(name: 'session_id') String sessionId,
            int seq,
            @JsonKey(name: 'ts_ms') int tsMs,
            String reason,
            double lat,
            double lon,
            @JsonKey(name: 'is_mock') bool isMock,
            @JsonKey(name: 'accuracy_m') double? accuracyM,
            @JsonKey(name: 'speed_mps') double? speedMps,
            @JsonKey(name: 'speed_accuracy_mps') double? speedAccuracyMps,
            @JsonKey(name: 'heading_deg') double? headingDeg,
            @JsonKey(name: 'altitude_m') double? altitudeM)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationUpdateRequest():
        return $default(
            _that.v,
            _that.memberId,
            _that.deviceId,
            _that.sessionId,
            _that.seq,
            _that.tsMs,
            _that.reason,
            _that.lat,
            _that.lon,
            _that.isMock,
            _that.accuracyM,
            _that.speedMps,
            _that.speedAccuracyMps,
            _that.headingDeg,
            _that.altitudeM);
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
            int v,
            int memberId,
            @JsonKey(name: 'device_id') String deviceId,
            @JsonKey(name: 'session_id') String sessionId,
            int seq,
            @JsonKey(name: 'ts_ms') int tsMs,
            String reason,
            double lat,
            double lon,
            @JsonKey(name: 'is_mock') bool isMock,
            @JsonKey(name: 'accuracy_m') double? accuracyM,
            @JsonKey(name: 'speed_mps') double? speedMps,
            @JsonKey(name: 'speed_accuracy_mps') double? speedAccuracyMps,
            @JsonKey(name: 'heading_deg') double? headingDeg,
            @JsonKey(name: 'altitude_m') double? altitudeM)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationUpdateRequest() when $default != null:
        return $default(
            _that.v,
            _that.memberId,
            _that.deviceId,
            _that.sessionId,
            _that.seq,
            _that.tsMs,
            _that.reason,
            _that.lat,
            _that.lon,
            _that.isMock,
            _that.accuracyM,
            _that.speedMps,
            _that.speedAccuracyMps,
            _that.headingDeg,
            _that.altitudeM);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LocationUpdateRequest implements LocationUpdateRequest {
  const _LocationUpdateRequest(
      {this.v = 2,
      required this.memberId,
      @JsonKey(name: 'device_id') required this.deviceId,
      @JsonKey(name: 'session_id') required this.sessionId,
      required this.seq,
      @JsonKey(name: 'ts_ms') required this.tsMs,
      required this.reason,
      required this.lat,
      required this.lon,
      @JsonKey(name: 'is_mock') required this.isMock,
      @JsonKey(name: 'accuracy_m') this.accuracyM,
      @JsonKey(name: 'speed_mps') this.speedMps,
      @JsonKey(name: 'speed_accuracy_mps') this.speedAccuracyMps,
      @JsonKey(name: 'heading_deg') this.headingDeg,
      @JsonKey(name: 'altitude_m') this.altitudeM});
  factory _LocationUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$LocationUpdateRequestFromJson(json);

  @override
  @JsonKey()
  final int v;
  @override
  final int memberId;
  @override
  @JsonKey(name: 'device_id')
  final String deviceId;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  final int seq;

  /// 위치를 **잰** 시각(epoch ms). 보낸 시각이 아니다.
  @override
  @JsonKey(name: 'ts_ms')
  final int tsMs;
  @override
  final String reason;
  @override
  final double lat;
  @override
  final double lon;

  /// 모의 위치가 아니어도 `false` 를 실어 보낸다(서버 권장).
  @override
  @JsonKey(name: 'is_mock')
  final bool isMock;
  @override
  @JsonKey(name: 'accuracy_m')
  final double? accuracyM;
  @override
  @JsonKey(name: 'speed_mps')
  final double? speedMps;
  @override
  @JsonKey(name: 'speed_accuracy_mps')
  final double? speedAccuracyMps;
  @override
  @JsonKey(name: 'heading_deg')
  final double? headingDeg;
  @override
  @JsonKey(name: 'altitude_m')
  final double? altitudeM;

  /// Create a copy of LocationUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocationUpdateRequestCopyWith<_LocationUpdateRequest> get copyWith =>
      __$LocationUpdateRequestCopyWithImpl<_LocationUpdateRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LocationUpdateRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocationUpdateRequest &&
            (identical(other.v, v) || other.v == v) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.isMock, isMock) || other.isMock == isMock) &&
            (identical(other.accuracyM, accuracyM) ||
                other.accuracyM == accuracyM) &&
            (identical(other.speedMps, speedMps) ||
                other.speedMps == speedMps) &&
            (identical(other.speedAccuracyMps, speedAccuracyMps) ||
                other.speedAccuracyMps == speedAccuracyMps) &&
            (identical(other.headingDeg, headingDeg) ||
                other.headingDeg == headingDeg) &&
            (identical(other.altitudeM, altitudeM) ||
                other.altitudeM == altitudeM));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      v,
      memberId,
      deviceId,
      sessionId,
      seq,
      tsMs,
      reason,
      lat,
      lon,
      isMock,
      accuracyM,
      speedMps,
      speedAccuracyMps,
      headingDeg,
      altitudeM);

  @override
  String toString() {
    return 'LocationUpdateRequest(v: $v, memberId: $memberId, deviceId: $deviceId, sessionId: $sessionId, seq: $seq, tsMs: $tsMs, reason: $reason, lat: $lat, lon: $lon, isMock: $isMock, accuracyM: $accuracyM, speedMps: $speedMps, speedAccuracyMps: $speedAccuracyMps, headingDeg: $headingDeg, altitudeM: $altitudeM)';
  }
}

/// @nodoc
abstract mixin class _$LocationUpdateRequestCopyWith<$Res>
    implements $LocationUpdateRequestCopyWith<$Res> {
  factory _$LocationUpdateRequestCopyWith(_LocationUpdateRequest value,
          $Res Function(_LocationUpdateRequest) _then) =
      __$LocationUpdateRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int v,
      int memberId,
      @JsonKey(name: 'device_id') String deviceId,
      @JsonKey(name: 'session_id') String sessionId,
      int seq,
      @JsonKey(name: 'ts_ms') int tsMs,
      String reason,
      double lat,
      double lon,
      @JsonKey(name: 'is_mock') bool isMock,
      @JsonKey(name: 'accuracy_m') double? accuracyM,
      @JsonKey(name: 'speed_mps') double? speedMps,
      @JsonKey(name: 'speed_accuracy_mps') double? speedAccuracyMps,
      @JsonKey(name: 'heading_deg') double? headingDeg,
      @JsonKey(name: 'altitude_m') double? altitudeM});
}

/// @nodoc
class __$LocationUpdateRequestCopyWithImpl<$Res>
    implements _$LocationUpdateRequestCopyWith<$Res> {
  __$LocationUpdateRequestCopyWithImpl(this._self, this._then);

  final _LocationUpdateRequest _self;
  final $Res Function(_LocationUpdateRequest) _then;

  /// Create a copy of LocationUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? v = null,
    Object? memberId = null,
    Object? deviceId = null,
    Object? sessionId = null,
    Object? seq = null,
    Object? tsMs = null,
    Object? reason = null,
    Object? lat = null,
    Object? lon = null,
    Object? isMock = null,
    Object? accuracyM = freezed,
    Object? speedMps = freezed,
    Object? speedAccuracyMps = freezed,
    Object? headingDeg = freezed,
    Object? altitudeM = freezed,
  }) {
    return _then(_LocationUpdateRequest(
      v: null == v
          ? _self.v
          : v // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      deviceId: null == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      seq: null == seq
          ? _self.seq
          : seq // ignore: cast_nullable_to_non_nullable
              as int,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _self.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      isMock: null == isMock
          ? _self.isMock
          : isMock // ignore: cast_nullable_to_non_nullable
              as bool,
      accuracyM: freezed == accuracyM
          ? _self.accuracyM
          : accuracyM // ignore: cast_nullable_to_non_nullable
              as double?,
      speedMps: freezed == speedMps
          ? _self.speedMps
          : speedMps // ignore: cast_nullable_to_non_nullable
              as double?,
      speedAccuracyMps: freezed == speedAccuracyMps
          ? _self.speedAccuracyMps
          : speedAccuracyMps // ignore: cast_nullable_to_non_nullable
              as double?,
      headingDeg: freezed == headingDeg
          ? _self.headingDeg
          : headingDeg // ignore: cast_nullable_to_non_nullable
              as double?,
      altitudeM: freezed == altitudeM
          ? _self.altitudeM
          : altitudeM // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
