// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SensorMessage {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SensorMessage);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SensorMessage()';
  }
}

/// @nodoc
class $SensorMessageCopyWith<$Res> {
  $SensorMessageCopyWith(SensorMessage _, $Res Function(SensorMessage) __);
}

/// Adds pattern-matching-related methods to [SensorMessage].
extension SensorMessagePatterns on SensorMessage {
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
    TResult Function(SensorMessageBatch value)? batch,
    TResult Function(SensorMessageHeartRate value)? heartRate,
    TResult Function(SensorMessageDropped value)? dropped,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch() when batch != null:
        return batch(_that);
      case SensorMessageHeartRate() when heartRate != null:
        return heartRate(_that);
      case SensorMessageDropped() when dropped != null:
        return dropped(_that);
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
    required TResult Function(SensorMessageBatch value) batch,
    required TResult Function(SensorMessageHeartRate value) heartRate,
    required TResult Function(SensorMessageDropped value) dropped,
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch():
        return batch(_that);
      case SensorMessageHeartRate():
        return heartRate(_that);
      case SensorMessageDropped():
        return dropped(_that);
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
    TResult? Function(SensorMessageBatch value)? batch,
    TResult? Function(SensorMessageHeartRate value)? heartRate,
    TResult? Function(SensorMessageDropped value)? dropped,
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch() when batch != null:
        return batch(_that);
      case SensorMessageHeartRate() when heartRate != null:
        return heartRate(_that);
      case SensorMessageDropped() when dropped != null:
        return dropped(_that);
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
    TResult Function(SensorBatch batch)? batch,
    TResult Function(HeartRateBatch batch)? heartRate,
    TResult Function(SensorDroppedRecord record)? dropped,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch() when batch != null:
        return batch(_that.batch);
      case SensorMessageHeartRate() when heartRate != null:
        return heartRate(_that.batch);
      case SensorMessageDropped() when dropped != null:
        return dropped(_that.record);
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
    required TResult Function(SensorBatch batch) batch,
    required TResult Function(HeartRateBatch batch) heartRate,
    required TResult Function(SensorDroppedRecord record) dropped,
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch():
        return batch(_that.batch);
      case SensorMessageHeartRate():
        return heartRate(_that.batch);
      case SensorMessageDropped():
        return dropped(_that.record);
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
    TResult? Function(SensorBatch batch)? batch,
    TResult? Function(HeartRateBatch batch)? heartRate,
    TResult? Function(SensorDroppedRecord record)? dropped,
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch() when batch != null:
        return batch(_that.batch);
      case SensorMessageHeartRate() when heartRate != null:
        return heartRate(_that.batch);
      case SensorMessageDropped() when dropped != null:
        return dropped(_that.record);
      case _:
        return null;
    }
  }
}

/// @nodoc

class SensorMessageBatch implements SensorMessage {
  const SensorMessageBatch(this.batch);

  final SensorBatch batch;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorMessageBatchCopyWith<SensorMessageBatch> get copyWith =>
      _$SensorMessageBatchCopyWithImpl<SensorMessageBatch>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorMessageBatch &&
            (identical(other.batch, batch) || other.batch == batch));
  }

  @override
  int get hashCode => Object.hash(runtimeType, batch);

  @override
  String toString() {
    return 'SensorMessage.batch(batch: $batch)';
  }
}

/// @nodoc
abstract mixin class $SensorMessageBatchCopyWith<$Res>
    implements $SensorMessageCopyWith<$Res> {
  factory $SensorMessageBatchCopyWith(
          SensorMessageBatch value, $Res Function(SensorMessageBatch) _then) =
      _$SensorMessageBatchCopyWithImpl;
  @useResult
  $Res call({SensorBatch batch});

  $SensorBatchCopyWith<$Res> get batch;
}

/// @nodoc
class _$SensorMessageBatchCopyWithImpl<$Res>
    implements $SensorMessageBatchCopyWith<$Res> {
  _$SensorMessageBatchCopyWithImpl(this._self, this._then);

  final SensorMessageBatch _self;
  final $Res Function(SensorMessageBatch) _then;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? batch = null,
  }) {
    return _then(SensorMessageBatch(
      null == batch
          ? _self.batch
          : batch // ignore: cast_nullable_to_non_nullable
              as SensorBatch,
    ));
  }

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SensorBatchCopyWith<$Res> get batch {
    return $SensorBatchCopyWith<$Res>(_self.batch, (value) {
      return _then(_self.copyWith(batch: value));
    });
  }
}

/// @nodoc

class SensorMessageHeartRate implements SensorMessage {
  const SensorMessageHeartRate(this.batch);

  final HeartRateBatch batch;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorMessageHeartRateCopyWith<SensorMessageHeartRate> get copyWith =>
      _$SensorMessageHeartRateCopyWithImpl<SensorMessageHeartRate>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorMessageHeartRate &&
            (identical(other.batch, batch) || other.batch == batch));
  }

  @override
  int get hashCode => Object.hash(runtimeType, batch);

  @override
  String toString() {
    return 'SensorMessage.heartRate(batch: $batch)';
  }
}

/// @nodoc
abstract mixin class $SensorMessageHeartRateCopyWith<$Res>
    implements $SensorMessageCopyWith<$Res> {
  factory $SensorMessageHeartRateCopyWith(SensorMessageHeartRate value,
          $Res Function(SensorMessageHeartRate) _then) =
      _$SensorMessageHeartRateCopyWithImpl;
  @useResult
  $Res call({HeartRateBatch batch});

  $HeartRateBatchCopyWith<$Res> get batch;
}

/// @nodoc
class _$SensorMessageHeartRateCopyWithImpl<$Res>
    implements $SensorMessageHeartRateCopyWith<$Res> {
  _$SensorMessageHeartRateCopyWithImpl(this._self, this._then);

  final SensorMessageHeartRate _self;
  final $Res Function(SensorMessageHeartRate) _then;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? batch = null,
  }) {
    return _then(SensorMessageHeartRate(
      null == batch
          ? _self.batch
          : batch // ignore: cast_nullable_to_non_nullable
              as HeartRateBatch,
    ));
  }

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HeartRateBatchCopyWith<$Res> get batch {
    return $HeartRateBatchCopyWith<$Res>(_self.batch, (value) {
      return _then(_self.copyWith(batch: value));
    });
  }
}

/// @nodoc

class SensorMessageDropped implements SensorMessage {
  const SensorMessageDropped(this.record);

  final SensorDroppedRecord record;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorMessageDroppedCopyWith<SensorMessageDropped> get copyWith =>
      _$SensorMessageDroppedCopyWithImpl<SensorMessageDropped>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorMessageDropped &&
            (identical(other.record, record) || other.record == record));
  }

  @override
  int get hashCode => Object.hash(runtimeType, record);

  @override
  String toString() {
    return 'SensorMessage.dropped(record: $record)';
  }
}

/// @nodoc
abstract mixin class $SensorMessageDroppedCopyWith<$Res>
    implements $SensorMessageCopyWith<$Res> {
  factory $SensorMessageDroppedCopyWith(SensorMessageDropped value,
          $Res Function(SensorMessageDropped) _then) =
      _$SensorMessageDroppedCopyWithImpl;
  @useResult
  $Res call({SensorDroppedRecord record});

  $SensorDroppedRecordCopyWith<$Res> get record;
}

/// @nodoc
class _$SensorMessageDroppedCopyWithImpl<$Res>
    implements $SensorMessageDroppedCopyWith<$Res> {
  _$SensorMessageDroppedCopyWithImpl(this._self, this._then);

  final SensorMessageDropped _self;
  final $Res Function(SensorMessageDropped) _then;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? record = null,
  }) {
    return _then(SensorMessageDropped(
      null == record
          ? _self.record
          : record // ignore: cast_nullable_to_non_nullable
              as SensorDroppedRecord,
    ));
  }

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SensorDroppedRecordCopyWith<$Res> get record {
    return $SensorDroppedRecordCopyWith<$Res>(_self.record, (value) {
      return _then(_self.copyWith(record: value));
    });
  }
}

// dart format on
