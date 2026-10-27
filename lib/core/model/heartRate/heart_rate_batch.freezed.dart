// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heart_rate_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeartRateBatch {
  int get v;
  String get stream;
  @JsonKey(name: 'batch_id')
  String get batchId;
  @JsonKey(name: 'device_id')
  String get deviceId;
  @JsonKey(name: 'session_id')
  String get sessionId;
  int get seq;
  @JsonKey(name: 'study_id')
  String? get studyId;
  @JsonKey(name: 'participation_id')
  String? get participationId;
  @JsonKey(name: 'run_id')
  String? get runId;
  @JsonKey(toJson: nestedToJson)
  ClockInfo get clock;
  @JsonKey(toJson: listToJson)
  List<HeartRateSample> get samples;
  @JsonKey(name: 'on_body')
  bool get onBody;
  @JsonKey(name: 'watch_battery_pct')
  int? get watchBatteryPct;
  @JsonKey(name: 'phone_received_at_ms')
  int? get phoneReceivedAtMs;
  @JsonKey(toJson: nestedToJson)
  ResendInfo? get resend;

  /// Create a copy of HeartRateBatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeartRateBatchCopyWith<HeartRateBatch> get copyWith =>
      _$HeartRateBatchCopyWithImpl<HeartRateBatch>(
          this as HeartRateBatch, _$identity);

  /// Serializes this HeartRateBatch to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeartRateBatch &&
            (identical(other.v, v) || other.v == v) &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.studyId, studyId) || other.studyId == studyId) &&
            (identical(other.participationId, participationId) ||
                other.participationId == participationId) &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.clock, clock) || other.clock == clock) &&
            const DeepCollectionEquality().equals(other.samples, samples) &&
            (identical(other.onBody, onBody) || other.onBody == onBody) &&
            (identical(other.watchBatteryPct, watchBatteryPct) ||
                other.watchBatteryPct == watchBatteryPct) &&
            (identical(other.phoneReceivedAtMs, phoneReceivedAtMs) ||
                other.phoneReceivedAtMs == phoneReceivedAtMs) &&
            (identical(other.resend, resend) || other.resend == resend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      v,
      stream,
      batchId,
      deviceId,
      sessionId,
      seq,
      studyId,
      participationId,
      runId,
      clock,
      const DeepCollectionEquality().hash(samples),
      onBody,
      watchBatteryPct,
      phoneReceivedAtMs,
      resend);

  @override
  String toString() {
    return 'HeartRateBatch(v: $v, stream: $stream, batchId: $batchId, deviceId: $deviceId, sessionId: $sessionId, seq: $seq, studyId: $studyId, participationId: $participationId, runId: $runId, clock: $clock, samples: $samples, onBody: $onBody, watchBatteryPct: $watchBatteryPct, phoneReceivedAtMs: $phoneReceivedAtMs, resend: $resend)';
  }
}

/// @nodoc
abstract mixin class $HeartRateBatchCopyWith<$Res> {
  factory $HeartRateBatchCopyWith(
          HeartRateBatch value, $Res Function(HeartRateBatch) _then) =
      _$HeartRateBatchCopyWithImpl;
  @useResult
  $Res call(
      {int v,
      String stream,
      @JsonKey(name: 'batch_id') String batchId,
      @JsonKey(name: 'device_id') String deviceId,
      @JsonKey(name: 'session_id') String sessionId,
      int seq,
      @JsonKey(name: 'study_id') String? studyId,
      @JsonKey(name: 'participation_id') String? participationId,
      @JsonKey(name: 'run_id') String? runId,
      @JsonKey(toJson: nestedToJson) ClockInfo clock,
      @JsonKey(toJson: listToJson) List<HeartRateSample> samples,
      @JsonKey(name: 'on_body') bool onBody,
      @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
      @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs,
      @JsonKey(toJson: nestedToJson) ResendInfo? resend});

  $ClockInfoCopyWith<$Res> get clock;
  $ResendInfoCopyWith<$Res>? get resend;
}

/// @nodoc
class _$HeartRateBatchCopyWithImpl<$Res>
    implements $HeartRateBatchCopyWith<$Res> {
  _$HeartRateBatchCopyWithImpl(this._self, this._then);

  final HeartRateBatch _self;
  final $Res Function(HeartRateBatch) _then;

  /// Create a copy of HeartRateBatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? v = null,
    Object? stream = null,
    Object? batchId = null,
    Object? deviceId = null,
    Object? sessionId = null,
    Object? seq = null,
    Object? studyId = freezed,
    Object? participationId = freezed,
    Object? runId = freezed,
    Object? clock = null,
    Object? samples = null,
    Object? onBody = null,
    Object? watchBatteryPct = freezed,
    Object? phoneReceivedAtMs = freezed,
    Object? resend = freezed,
  }) {
    return _then(_self.copyWith(
      v: null == v
          ? _self.v
          : v // ignore: cast_nullable_to_non_nullable
              as int,
      stream: null == stream
          ? _self.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String,
      batchId: null == batchId
          ? _self.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
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
      studyId: freezed == studyId
          ? _self.studyId
          : studyId // ignore: cast_nullable_to_non_nullable
              as String?,
      participationId: freezed == participationId
          ? _self.participationId
          : participationId // ignore: cast_nullable_to_non_nullable
              as String?,
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as String?,
      clock: null == clock
          ? _self.clock
          : clock // ignore: cast_nullable_to_non_nullable
              as ClockInfo,
      samples: null == samples
          ? _self.samples
          : samples // ignore: cast_nullable_to_non_nullable
              as List<HeartRateSample>,
      onBody: null == onBody
          ? _self.onBody
          : onBody // ignore: cast_nullable_to_non_nullable
              as bool,
      watchBatteryPct: freezed == watchBatteryPct
          ? _self.watchBatteryPct
          : watchBatteryPct // ignore: cast_nullable_to_non_nullable
              as int?,
      phoneReceivedAtMs: freezed == phoneReceivedAtMs
          ? _self.phoneReceivedAtMs
          : phoneReceivedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      resend: freezed == resend
          ? _self.resend
          : resend // ignore: cast_nullable_to_non_nullable
              as ResendInfo?,
    ));
  }

  /// Create a copy of HeartRateBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClockInfoCopyWith<$Res> get clock {
    return $ClockInfoCopyWith<$Res>(_self.clock, (value) {
      return _then(_self.copyWith(clock: value));
    });
  }

  /// Create a copy of HeartRateBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResendInfoCopyWith<$Res>? get resend {
    if (_self.resend == null) {
      return null;
    }

    return $ResendInfoCopyWith<$Res>(_self.resend!, (value) {
      return _then(_self.copyWith(resend: value));
    });
  }
}

/// Adds pattern-matching-related methods to [HeartRateBatch].
extension HeartRateBatchPatterns on HeartRateBatch {
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
    TResult Function(_HeartRateBatch value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRateBatch() when $default != null:
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
    TResult Function(_HeartRateBatch value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateBatch():
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
    TResult? Function(_HeartRateBatch value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateBatch() when $default != null:
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
            String stream,
            @JsonKey(name: 'batch_id') String batchId,
            @JsonKey(name: 'device_id') String deviceId,
            @JsonKey(name: 'session_id') String sessionId,
            int seq,
            @JsonKey(name: 'study_id') String? studyId,
            @JsonKey(name: 'participation_id') String? participationId,
            @JsonKey(name: 'run_id') String? runId,
            @JsonKey(toJson: nestedToJson) ClockInfo clock,
            @JsonKey(toJson: listToJson) List<HeartRateSample> samples,
            @JsonKey(name: 'on_body') bool onBody,
            @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
            @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs,
            @JsonKey(toJson: nestedToJson) ResendInfo? resend)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRateBatch() when $default != null:
        return $default(
            _that.v,
            _that.stream,
            _that.batchId,
            _that.deviceId,
            _that.sessionId,
            _that.seq,
            _that.studyId,
            _that.participationId,
            _that.runId,
            _that.clock,
            _that.samples,
            _that.onBody,
            _that.watchBatteryPct,
            _that.phoneReceivedAtMs,
            _that.resend);
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
            String stream,
            @JsonKey(name: 'batch_id') String batchId,
            @JsonKey(name: 'device_id') String deviceId,
            @JsonKey(name: 'session_id') String sessionId,
            int seq,
            @JsonKey(name: 'study_id') String? studyId,
            @JsonKey(name: 'participation_id') String? participationId,
            @JsonKey(name: 'run_id') String? runId,
            @JsonKey(toJson: nestedToJson) ClockInfo clock,
            @JsonKey(toJson: listToJson) List<HeartRateSample> samples,
            @JsonKey(name: 'on_body') bool onBody,
            @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
            @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs,
            @JsonKey(toJson: nestedToJson) ResendInfo? resend)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateBatch():
        return $default(
            _that.v,
            _that.stream,
            _that.batchId,
            _that.deviceId,
            _that.sessionId,
            _that.seq,
            _that.studyId,
            _that.participationId,
            _that.runId,
            _that.clock,
            _that.samples,
            _that.onBody,
            _that.watchBatteryPct,
            _that.phoneReceivedAtMs,
            _that.resend);
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
            String stream,
            @JsonKey(name: 'batch_id') String batchId,
            @JsonKey(name: 'device_id') String deviceId,
            @JsonKey(name: 'session_id') String sessionId,
            int seq,
            @JsonKey(name: 'study_id') String? studyId,
            @JsonKey(name: 'participation_id') String? participationId,
            @JsonKey(name: 'run_id') String? runId,
            @JsonKey(toJson: nestedToJson) ClockInfo clock,
            @JsonKey(toJson: listToJson) List<HeartRateSample> samples,
            @JsonKey(name: 'on_body') bool onBody,
            @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
            @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs,
            @JsonKey(toJson: nestedToJson) ResendInfo? resend)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateBatch() when $default != null:
        return $default(
            _that.v,
            _that.stream,
            _that.batchId,
            _that.deviceId,
            _that.sessionId,
            _that.seq,
            _that.studyId,
            _that.participationId,
            _that.runId,
            _that.clock,
            _that.samples,
            _that.onBody,
            _that.watchBatteryPct,
            _that.phoneReceivedAtMs,
            _that.resend);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HeartRateBatch implements HeartRateBatch {
  const _HeartRateBatch(
      {this.v = 2,
      this.stream = 'hr',
      @JsonKey(name: 'batch_id') required this.batchId,
      @JsonKey(name: 'device_id') required this.deviceId,
      @JsonKey(name: 'session_id') required this.sessionId,
      required this.seq,
      @JsonKey(name: 'study_id') this.studyId,
      @JsonKey(name: 'participation_id') this.participationId,
      @JsonKey(name: 'run_id') this.runId,
      @JsonKey(toJson: nestedToJson) required this.clock,
      @JsonKey(toJson: listToJson) required final List<HeartRateSample> samples,
      @JsonKey(name: 'on_body') required this.onBody,
      @JsonKey(name: 'watch_battery_pct') this.watchBatteryPct,
      @JsonKey(name: 'phone_received_at_ms') this.phoneReceivedAtMs,
      @JsonKey(toJson: nestedToJson) this.resend})
      : _samples = samples;
  factory _HeartRateBatch.fromJson(Map<String, dynamic> json) =>
      _$HeartRateBatchFromJson(json);

  @override
  @JsonKey()
  final int v;
  @override
  @JsonKey()
  final String stream;
  @override
  @JsonKey(name: 'batch_id')
  final String batchId;
  @override
  @JsonKey(name: 'device_id')
  final String deviceId;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  final int seq;
  @override
  @JsonKey(name: 'study_id')
  final String? studyId;
  @override
  @JsonKey(name: 'participation_id')
  final String? participationId;
  @override
  @JsonKey(name: 'run_id')
  final String? runId;
  @override
  @JsonKey(toJson: nestedToJson)
  final ClockInfo clock;
  final List<HeartRateSample> _samples;
  @override
  @JsonKey(toJson: listToJson)
  List<HeartRateSample> get samples {
    if (_samples is EqualUnmodifiableListView) return _samples;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_samples);
  }

  @override
  @JsonKey(name: 'on_body')
  final bool onBody;
  @override
  @JsonKey(name: 'watch_battery_pct')
  final int? watchBatteryPct;
  @override
  @JsonKey(name: 'phone_received_at_ms')
  final int? phoneReceivedAtMs;
  @override
  @JsonKey(toJson: nestedToJson)
  final ResendInfo? resend;

  /// Create a copy of HeartRateBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HeartRateBatchCopyWith<_HeartRateBatch> get copyWith =>
      __$HeartRateBatchCopyWithImpl<_HeartRateBatch>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HeartRateBatchToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HeartRateBatch &&
            (identical(other.v, v) || other.v == v) &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.studyId, studyId) || other.studyId == studyId) &&
            (identical(other.participationId, participationId) ||
                other.participationId == participationId) &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.clock, clock) || other.clock == clock) &&
            const DeepCollectionEquality().equals(other._samples, _samples) &&
            (identical(other.onBody, onBody) || other.onBody == onBody) &&
            (identical(other.watchBatteryPct, watchBatteryPct) ||
                other.watchBatteryPct == watchBatteryPct) &&
            (identical(other.phoneReceivedAtMs, phoneReceivedAtMs) ||
                other.phoneReceivedAtMs == phoneReceivedAtMs) &&
            (identical(other.resend, resend) || other.resend == resend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      v,
      stream,
      batchId,
      deviceId,
      sessionId,
      seq,
      studyId,
      participationId,
      runId,
      clock,
      const DeepCollectionEquality().hash(_samples),
      onBody,
      watchBatteryPct,
      phoneReceivedAtMs,
      resend);

  @override
  String toString() {
    return 'HeartRateBatch(v: $v, stream: $stream, batchId: $batchId, deviceId: $deviceId, sessionId: $sessionId, seq: $seq, studyId: $studyId, participationId: $participationId, runId: $runId, clock: $clock, samples: $samples, onBody: $onBody, watchBatteryPct: $watchBatteryPct, phoneReceivedAtMs: $phoneReceivedAtMs, resend: $resend)';
  }
}

/// @nodoc
abstract mixin class _$HeartRateBatchCopyWith<$Res>
    implements $HeartRateBatchCopyWith<$Res> {
  factory _$HeartRateBatchCopyWith(
          _HeartRateBatch value, $Res Function(_HeartRateBatch) _then) =
      __$HeartRateBatchCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int v,
      String stream,
      @JsonKey(name: 'batch_id') String batchId,
      @JsonKey(name: 'device_id') String deviceId,
      @JsonKey(name: 'session_id') String sessionId,
      int seq,
      @JsonKey(name: 'study_id') String? studyId,
      @JsonKey(name: 'participation_id') String? participationId,
      @JsonKey(name: 'run_id') String? runId,
      @JsonKey(toJson: nestedToJson) ClockInfo clock,
      @JsonKey(toJson: listToJson) List<HeartRateSample> samples,
      @JsonKey(name: 'on_body') bool onBody,
      @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
      @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs,
      @JsonKey(toJson: nestedToJson) ResendInfo? resend});

  @override
  $ClockInfoCopyWith<$Res> get clock;
  @override
  $ResendInfoCopyWith<$Res>? get resend;
}

/// @nodoc
class __$HeartRateBatchCopyWithImpl<$Res>
    implements _$HeartRateBatchCopyWith<$Res> {
  __$HeartRateBatchCopyWithImpl(this._self, this._then);

  final _HeartRateBatch _self;
  final $Res Function(_HeartRateBatch) _then;

  /// Create a copy of HeartRateBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? v = null,
    Object? stream = null,
    Object? batchId = null,
    Object? deviceId = null,
    Object? sessionId = null,
    Object? seq = null,
    Object? studyId = freezed,
    Object? participationId = freezed,
    Object? runId = freezed,
    Object? clock = null,
    Object? samples = null,
    Object? onBody = null,
    Object? watchBatteryPct = freezed,
    Object? phoneReceivedAtMs = freezed,
    Object? resend = freezed,
  }) {
    return _then(_HeartRateBatch(
      v: null == v
          ? _self.v
          : v // ignore: cast_nullable_to_non_nullable
              as int,
      stream: null == stream
          ? _self.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String,
      batchId: null == batchId
          ? _self.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
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
      studyId: freezed == studyId
          ? _self.studyId
          : studyId // ignore: cast_nullable_to_non_nullable
              as String?,
      participationId: freezed == participationId
          ? _self.participationId
          : participationId // ignore: cast_nullable_to_non_nullable
              as String?,
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as String?,
      clock: null == clock
          ? _self.clock
          : clock // ignore: cast_nullable_to_non_nullable
              as ClockInfo,
      samples: null == samples
          ? _self._samples
          : samples // ignore: cast_nullable_to_non_nullable
              as List<HeartRateSample>,
      onBody: null == onBody
          ? _self.onBody
          : onBody // ignore: cast_nullable_to_non_nullable
              as bool,
      watchBatteryPct: freezed == watchBatteryPct
          ? _self.watchBatteryPct
          : watchBatteryPct // ignore: cast_nullable_to_non_nullable
              as int?,
      phoneReceivedAtMs: freezed == phoneReceivedAtMs
          ? _self.phoneReceivedAtMs
          : phoneReceivedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      resend: freezed == resend
          ? _self.resend
          : resend // ignore: cast_nullable_to_non_nullable
              as ResendInfo?,
    ));
  }

  /// Create a copy of HeartRateBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClockInfoCopyWith<$Res> get clock {
    return $ClockInfoCopyWith<$Res>(_self.clock, (value) {
      return _then(_self.copyWith(clock: value));
    });
  }

  /// Create a copy of HeartRateBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResendInfoCopyWith<$Res>? get resend {
    if (_self.resend == null) {
      return null;
    }

    return $ResendInfoCopyWith<$Res>(_self.resend!, (value) {
      return _then(_self.copyWith(resend: value));
    });
  }
}

/// @nodoc
mixin _$HeartRateSample {
  int get bpm;
  @JsonKey(name: 'ts_ms')
  int get tsMs;

  /// HIGH·MEDIUM·LOW·UNRELIABLE·UNKNOWN. 누락·null 은 서버가 거절한다.
  String get accuracy;

  /// Create a copy of HeartRateSample
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeartRateSampleCopyWith<HeartRateSample> get copyWith =>
      _$HeartRateSampleCopyWithImpl<HeartRateSample>(
          this as HeartRateSample, _$identity);

  /// Serializes this HeartRateSample to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeartRateSample &&
            (identical(other.bpm, bpm) || other.bpm == bpm) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bpm, tsMs, accuracy);

  @override
  String toString() {
    return 'HeartRateSample(bpm: $bpm, tsMs: $tsMs, accuracy: $accuracy)';
  }
}

/// @nodoc
abstract mixin class $HeartRateSampleCopyWith<$Res> {
  factory $HeartRateSampleCopyWith(
          HeartRateSample value, $Res Function(HeartRateSample) _then) =
      _$HeartRateSampleCopyWithImpl;
  @useResult
  $Res call({int bpm, @JsonKey(name: 'ts_ms') int tsMs, String accuracy});
}

/// @nodoc
class _$HeartRateSampleCopyWithImpl<$Res>
    implements $HeartRateSampleCopyWith<$Res> {
  _$HeartRateSampleCopyWithImpl(this._self, this._then);

  final HeartRateSample _self;
  final $Res Function(HeartRateSample) _then;

  /// Create a copy of HeartRateSample
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bpm = null,
    Object? tsMs = null,
    Object? accuracy = null,
  }) {
    return _then(_self.copyWith(
      bpm: null == bpm
          ? _self.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as int,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
      accuracy: null == accuracy
          ? _self.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [HeartRateSample].
extension HeartRateSamplePatterns on HeartRateSample {
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
    TResult Function(_HeartRateSample value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRateSample() when $default != null:
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
    TResult Function(_HeartRateSample value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateSample():
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
    TResult? Function(_HeartRateSample value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateSample() when $default != null:
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
            int bpm, @JsonKey(name: 'ts_ms') int tsMs, String accuracy)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRateSample() when $default != null:
        return $default(_that.bpm, _that.tsMs, _that.accuracy);
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
    TResult Function(int bpm, @JsonKey(name: 'ts_ms') int tsMs, String accuracy)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateSample():
        return $default(_that.bpm, _that.tsMs, _that.accuracy);
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
            int bpm, @JsonKey(name: 'ts_ms') int tsMs, String accuracy)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateSample() when $default != null:
        return $default(_that.bpm, _that.tsMs, _that.accuracy);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HeartRateSample implements HeartRateSample {
  const _HeartRateSample(
      {required this.bpm,
      @JsonKey(name: 'ts_ms') required this.tsMs,
      required this.accuracy});
  factory _HeartRateSample.fromJson(Map<String, dynamic> json) =>
      _$HeartRateSampleFromJson(json);

  @override
  final int bpm;
  @override
  @JsonKey(name: 'ts_ms')
  final int tsMs;

  /// HIGH·MEDIUM·LOW·UNRELIABLE·UNKNOWN. 누락·null 은 서버가 거절한다.
  @override
  final String accuracy;

  /// Create a copy of HeartRateSample
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HeartRateSampleCopyWith<_HeartRateSample> get copyWith =>
      __$HeartRateSampleCopyWithImpl<_HeartRateSample>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HeartRateSampleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HeartRateSample &&
            (identical(other.bpm, bpm) || other.bpm == bpm) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bpm, tsMs, accuracy);

  @override
  String toString() {
    return 'HeartRateSample(bpm: $bpm, tsMs: $tsMs, accuracy: $accuracy)';
  }
}

/// @nodoc
abstract mixin class _$HeartRateSampleCopyWith<$Res>
    implements $HeartRateSampleCopyWith<$Res> {
  factory _$HeartRateSampleCopyWith(
          _HeartRateSample value, $Res Function(_HeartRateSample) _then) =
      __$HeartRateSampleCopyWithImpl;
  @override
  @useResult
  $Res call({int bpm, @JsonKey(name: 'ts_ms') int tsMs, String accuracy});
}

/// @nodoc
class __$HeartRateSampleCopyWithImpl<$Res>
    implements _$HeartRateSampleCopyWith<$Res> {
  __$HeartRateSampleCopyWithImpl(this._self, this._then);

  final _HeartRateSample _self;
  final $Res Function(_HeartRateSample) _then;

  /// Create a copy of HeartRateSample
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bpm = null,
    Object? tsMs = null,
    Object? accuracy = null,
  }) {
    return _then(_HeartRateSample(
      bpm: null == bpm
          ? _self.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as int,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
      accuracy: null == accuracy
          ? _self.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
