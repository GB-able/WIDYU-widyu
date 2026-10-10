// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SensorResult {
  String get batchId;
  int get seq;
  String get result;

  /// Create a copy of SensorResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorResultCopyWith<SensorResult> get copyWith =>
      _$SensorResultCopyWithImpl<SensorResult>(
          this as SensorResult, _$identity);

  /// Serializes this SensorResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorResult &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, batchId, seq, result);

  @override
  String toString() {
    return 'SensorResult(batchId: $batchId, seq: $seq, result: $result)';
  }
}

/// @nodoc
abstract mixin class $SensorResultCopyWith<$Res> {
  factory $SensorResultCopyWith(
          SensorResult value, $Res Function(SensorResult) _then) =
      _$SensorResultCopyWithImpl;
  @useResult
  $Res call({String batchId, int seq, String result});
}

/// @nodoc
class _$SensorResultCopyWithImpl<$Res> implements $SensorResultCopyWith<$Res> {
  _$SensorResultCopyWithImpl(this._self, this._then);

  final SensorResult _self;
  final $Res Function(SensorResult) _then;

  /// Create a copy of SensorResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? batchId = null,
    Object? seq = null,
    Object? result = null,
  }) {
    return _then(_self.copyWith(
      batchId: null == batchId
          ? _self.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      seq: null == seq
          ? _self.seq
          : seq // ignore: cast_nullable_to_non_nullable
              as int,
      result: null == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [SensorResult].
extension SensorResultPatterns on SensorResult {
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
    TResult Function(_SensorResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorResult() when $default != null:
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
    TResult Function(_SensorResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorResult():
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
    TResult? Function(_SensorResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorResult() when $default != null:
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
    TResult Function(String batchId, int seq, String result)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorResult() when $default != null:
        return $default(_that.batchId, _that.seq, _that.result);
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
    TResult Function(String batchId, int seq, String result) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorResult():
        return $default(_that.batchId, _that.seq, _that.result);
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
    TResult? Function(String batchId, int seq, String result)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorResult() when $default != null:
        return $default(_that.batchId, _that.seq, _that.result);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SensorResult implements SensorResult {
  const _SensorResult(
      {required this.batchId, required this.seq, required this.result});
  factory _SensorResult.fromJson(Map<String, dynamic> json) =>
      _$SensorResultFromJson(json);

  @override
  final String batchId;
  @override
  final int seq;
  @override
  final String result;

  /// Create a copy of SensorResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SensorResultCopyWith<_SensorResult> get copyWith =>
      __$SensorResultCopyWithImpl<_SensorResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SensorResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SensorResult &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, batchId, seq, result);

  @override
  String toString() {
    return 'SensorResult(batchId: $batchId, seq: $seq, result: $result)';
  }
}

/// @nodoc
abstract mixin class _$SensorResultCopyWith<$Res>
    implements $SensorResultCopyWith<$Res> {
  factory _$SensorResultCopyWith(
          _SensorResult value, $Res Function(_SensorResult) _then) =
      __$SensorResultCopyWithImpl;
  @override
  @useResult
  $Res call({String batchId, int seq, String result});
}

/// @nodoc
class __$SensorResultCopyWithImpl<$Res>
    implements _$SensorResultCopyWith<$Res> {
  __$SensorResultCopyWithImpl(this._self, this._then);

  final _SensorResult _self;
  final $Res Function(_SensorResult) _then;

  /// Create a copy of SensorResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? batchId = null,
    Object? seq = null,
    Object? result = null,
  }) {
    return _then(_SensorResult(
      batchId: null == batchId
          ? _self.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      seq: null == seq
          ? _self.seq
          : seq // ignore: cast_nullable_to_non_nullable
              as int,
      result: null == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
