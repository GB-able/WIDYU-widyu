// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heart_rate_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeartRateResponse {
  int get memberId;
  String get heartRateStatus;

  /// 아직 판정된 심박이 없으면(상태 UNKNOWN) 서버가 null 로 준다.
  int? get heartRate;
  DateTime? get measuredAt;

  /// Create a copy of HeartRateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeartRateResponseCopyWith<HeartRateResponse> get copyWith =>
      _$HeartRateResponseCopyWithImpl<HeartRateResponse>(
          this as HeartRateResponse, _$identity);

  /// Serializes this HeartRateResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeartRateResponse &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.heartRateStatus, heartRateStatus) ||
                other.heartRateStatus == heartRateStatus) &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, memberId, heartRateStatus, heartRate, measuredAt);

  @override
  String toString() {
    return 'HeartRateResponse(memberId: $memberId, heartRateStatus: $heartRateStatus, heartRate: $heartRate, measuredAt: $measuredAt)';
  }
}

/// @nodoc
abstract mixin class $HeartRateResponseCopyWith<$Res> {
  factory $HeartRateResponseCopyWith(
          HeartRateResponse value, $Res Function(HeartRateResponse) _then) =
      _$HeartRateResponseCopyWithImpl;
  @useResult
  $Res call(
      {int memberId,
      String heartRateStatus,
      int? heartRate,
      DateTime? measuredAt});
}

/// @nodoc
class _$HeartRateResponseCopyWithImpl<$Res>
    implements $HeartRateResponseCopyWith<$Res> {
  _$HeartRateResponseCopyWithImpl(this._self, this._then);

  final HeartRateResponse _self;
  final $Res Function(HeartRateResponse) _then;

  /// Create a copy of HeartRateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? heartRateStatus = null,
    Object? heartRate = freezed,
    Object? measuredAt = freezed,
  }) {
    return _then(_self.copyWith(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      heartRateStatus: null == heartRateStatus
          ? _self.heartRateStatus
          : heartRateStatus // ignore: cast_nullable_to_non_nullable
              as String,
      heartRate: freezed == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      measuredAt: freezed == measuredAt
          ? _self.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HeartRateResponse].
extension HeartRateResponsePatterns on HeartRateResponse {
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
    TResult Function(_HeartRateResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRateResponse() when $default != null:
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
    TResult Function(_HeartRateResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateResponse():
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
    TResult? Function(_HeartRateResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateResponse() when $default != null:
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
    TResult Function(int memberId, String heartRateStatus, int? heartRate,
            DateTime? measuredAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRateResponse() when $default != null:
        return $default(_that.memberId, _that.heartRateStatus, _that.heartRate,
            _that.measuredAt);
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
    TResult Function(int memberId, String heartRateStatus, int? heartRate,
            DateTime? measuredAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateResponse():
        return $default(_that.memberId, _that.heartRateStatus, _that.heartRate,
            _that.measuredAt);
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
    TResult? Function(int memberId, String heartRateStatus, int? heartRate,
            DateTime? measuredAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateResponse() when $default != null:
        return $default(_that.memberId, _that.heartRateStatus, _that.heartRate,
            _that.measuredAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HeartRateResponse implements HeartRateResponse {
  const _HeartRateResponse(
      {required this.memberId,
      required this.heartRateStatus,
      this.heartRate,
      this.measuredAt});
  factory _HeartRateResponse.fromJson(Map<String, dynamic> json) =>
      _$HeartRateResponseFromJson(json);

  @override
  final int memberId;
  @override
  final String heartRateStatus;

  /// 아직 판정된 심박이 없으면(상태 UNKNOWN) 서버가 null 로 준다.
  @override
  final int? heartRate;
  @override
  final DateTime? measuredAt;

  /// Create a copy of HeartRateResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HeartRateResponseCopyWith<_HeartRateResponse> get copyWith =>
      __$HeartRateResponseCopyWithImpl<_HeartRateResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HeartRateResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HeartRateResponse &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.heartRateStatus, heartRateStatus) ||
                other.heartRateStatus == heartRateStatus) &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, memberId, heartRateStatus, heartRate, measuredAt);

  @override
  String toString() {
    return 'HeartRateResponse(memberId: $memberId, heartRateStatus: $heartRateStatus, heartRate: $heartRate, measuredAt: $measuredAt)';
  }
}

/// @nodoc
abstract mixin class _$HeartRateResponseCopyWith<$Res>
    implements $HeartRateResponseCopyWith<$Res> {
  factory _$HeartRateResponseCopyWith(
          _HeartRateResponse value, $Res Function(_HeartRateResponse) _then) =
      __$HeartRateResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int memberId,
      String heartRateStatus,
      int? heartRate,
      DateTime? measuredAt});
}

/// @nodoc
class __$HeartRateResponseCopyWithImpl<$Res>
    implements _$HeartRateResponseCopyWith<$Res> {
  __$HeartRateResponseCopyWithImpl(this._self, this._then);

  final _HeartRateResponse _self;
  final $Res Function(_HeartRateResponse) _then;

  /// Create a copy of HeartRateResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? memberId = null,
    Object? heartRateStatus = null,
    Object? heartRate = freezed,
    Object? measuredAt = freezed,
  }) {
    return _then(_HeartRateResponse(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      heartRateStatus: null == heartRateStatus
          ? _self.heartRateStatus
          : heartRateStatus // ignore: cast_nullable_to_non_nullable
              as String,
      heartRate: freezed == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      measuredAt: freezed == measuredAt
          ? _self.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
