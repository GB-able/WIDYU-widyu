// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_dropped_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SensorDroppedRecord {
  String get stream;
  @JsonKey(name: 'session_id')
  String get sessionId;
  @JsonKey(name: 'from_seq')
  int get fromSeq;
  @JsonKey(name: 'to_seq')
  int get toSeq;
  String get reason;
  @JsonKey(name: 'ts_ms')
  int get tsMs;

  /// Create a copy of SensorDroppedRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorDroppedRecordCopyWith<SensorDroppedRecord> get copyWith =>
      _$SensorDroppedRecordCopyWithImpl<SensorDroppedRecord>(
          this as SensorDroppedRecord, _$identity);

  /// Serializes this SensorDroppedRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorDroppedRecord &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.fromSeq, fromSeq) || other.fromSeq == fromSeq) &&
            (identical(other.toSeq, toSeq) || other.toSeq == toSeq) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stream, sessionId, fromSeq, toSeq, reason, tsMs);

  @override
  String toString() {
    return 'SensorDroppedRecord(stream: $stream, sessionId: $sessionId, fromSeq: $fromSeq, toSeq: $toSeq, reason: $reason, tsMs: $tsMs)';
  }
}

/// @nodoc
abstract mixin class $SensorDroppedRecordCopyWith<$Res> {
  factory $SensorDroppedRecordCopyWith(
          SensorDroppedRecord value, $Res Function(SensorDroppedRecord) _then) =
      _$SensorDroppedRecordCopyWithImpl;
  @useResult
  $Res call(
      {String stream,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'from_seq') int fromSeq,
      @JsonKey(name: 'to_seq') int toSeq,
      String reason,
      @JsonKey(name: 'ts_ms') int tsMs});
}

/// @nodoc
class _$SensorDroppedRecordCopyWithImpl<$Res>
    implements $SensorDroppedRecordCopyWith<$Res> {
  _$SensorDroppedRecordCopyWithImpl(this._self, this._then);

  final SensorDroppedRecord _self;
  final $Res Function(SensorDroppedRecord) _then;

  /// Create a copy of SensorDroppedRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stream = null,
    Object? sessionId = null,
    Object? fromSeq = null,
    Object? toSeq = null,
    Object? reason = null,
    Object? tsMs = null,
  }) {
    return _then(_self.copyWith(
      stream: null == stream
          ? _self.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      fromSeq: null == fromSeq
          ? _self.fromSeq
          : fromSeq // ignore: cast_nullable_to_non_nullable
              as int,
      toSeq: null == toSeq
          ? _self.toSeq
          : toSeq // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [SensorDroppedRecord].
extension SensorDroppedRecordPatterns on SensorDroppedRecord {
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
    TResult Function(_SensorDroppedRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord() when $default != null:
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
    TResult Function(_SensorDroppedRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord():
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
    TResult? Function(_SensorDroppedRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord() when $default != null:
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
            String stream,
            @JsonKey(name: 'session_id') String sessionId,
            @JsonKey(name: 'from_seq') int fromSeq,
            @JsonKey(name: 'to_seq') int toSeq,
            String reason,
            @JsonKey(name: 'ts_ms') int tsMs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord() when $default != null:
        return $default(_that.stream, _that.sessionId, _that.fromSeq,
            _that.toSeq, _that.reason, _that.tsMs);
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
            String stream,
            @JsonKey(name: 'session_id') String sessionId,
            @JsonKey(name: 'from_seq') int fromSeq,
            @JsonKey(name: 'to_seq') int toSeq,
            String reason,
            @JsonKey(name: 'ts_ms') int tsMs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord():
        return $default(_that.stream, _that.sessionId, _that.fromSeq,
            _that.toSeq, _that.reason, _that.tsMs);
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
            String stream,
            @JsonKey(name: 'session_id') String sessionId,
            @JsonKey(name: 'from_seq') int fromSeq,
            @JsonKey(name: 'to_seq') int toSeq,
            String reason,
            @JsonKey(name: 'ts_ms') int tsMs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord() when $default != null:
        return $default(_that.stream, _that.sessionId, _that.fromSeq,
            _that.toSeq, _that.reason, _that.tsMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SensorDroppedRecord implements SensorDroppedRecord {
  const _SensorDroppedRecord(
      {this.stream = 'imu_dropped',
      @JsonKey(name: 'session_id') required this.sessionId,
      @JsonKey(name: 'from_seq') required this.fromSeq,
      @JsonKey(name: 'to_seq') required this.toSeq,
      required this.reason,
      @JsonKey(name: 'ts_ms') required this.tsMs});
  factory _SensorDroppedRecord.fromJson(Map<String, dynamic> json) =>
      _$SensorDroppedRecordFromJson(json);

  @override
  @JsonKey()
  final String stream;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  @JsonKey(name: 'from_seq')
  final int fromSeq;
  @override
  @JsonKey(name: 'to_seq')
  final int toSeq;
  @override
  final String reason;
  @override
  @JsonKey(name: 'ts_ms')
  final int tsMs;

  /// Create a copy of SensorDroppedRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SensorDroppedRecordCopyWith<_SensorDroppedRecord> get copyWith =>
      __$SensorDroppedRecordCopyWithImpl<_SensorDroppedRecord>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SensorDroppedRecordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SensorDroppedRecord &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.fromSeq, fromSeq) || other.fromSeq == fromSeq) &&
            (identical(other.toSeq, toSeq) || other.toSeq == toSeq) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stream, sessionId, fromSeq, toSeq, reason, tsMs);

  @override
  String toString() {
    return 'SensorDroppedRecord(stream: $stream, sessionId: $sessionId, fromSeq: $fromSeq, toSeq: $toSeq, reason: $reason, tsMs: $tsMs)';
  }
}

/// @nodoc
abstract mixin class _$SensorDroppedRecordCopyWith<$Res>
    implements $SensorDroppedRecordCopyWith<$Res> {
  factory _$SensorDroppedRecordCopyWith(_SensorDroppedRecord value,
          $Res Function(_SensorDroppedRecord) _then) =
      __$SensorDroppedRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String stream,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'from_seq') int fromSeq,
      @JsonKey(name: 'to_seq') int toSeq,
      String reason,
      @JsonKey(name: 'ts_ms') int tsMs});
}

/// @nodoc
class __$SensorDroppedRecordCopyWithImpl<$Res>
    implements _$SensorDroppedRecordCopyWith<$Res> {
  __$SensorDroppedRecordCopyWithImpl(this._self, this._then);

  final _SensorDroppedRecord _self;
  final $Res Function(_SensorDroppedRecord) _then;

  /// Create a copy of SensorDroppedRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stream = null,
    Object? sessionId = null,
    Object? fromSeq = null,
    Object? toSeq = null,
    Object? reason = null,
    Object? tsMs = null,
  }) {
    return _then(_SensorDroppedRecord(
      stream: null == stream
          ? _self.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      fromSeq: null == fromSeq
          ? _self.fromSeq
          : fromSeq // ignore: cast_nullable_to_non_nullable
              as int,
      toSeq: null == toSeq
          ? _self.toSeq
          : toSeq // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
