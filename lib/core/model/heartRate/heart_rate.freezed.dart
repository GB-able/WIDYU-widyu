// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heart_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeartRate {
  int get heartRate;
  DateTime get measuredAt;

  /// Create a copy of HeartRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeartRateCopyWith<HeartRate> get copyWith =>
      _$HeartRateCopyWithImpl<HeartRate>(this as HeartRate, _$identity);

  /// Serializes this HeartRate to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeartRate &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, heartRate, measuredAt);

  @override
  String toString() {
    return 'HeartRate(heartRate: $heartRate, measuredAt: $measuredAt)';
  }
}

/// @nodoc
abstract mixin class $HeartRateCopyWith<$Res> {
  factory $HeartRateCopyWith(HeartRate value, $Res Function(HeartRate) _then) =
      _$HeartRateCopyWithImpl;
  @useResult
  $Res call({int heartRate, DateTime measuredAt});
}

/// @nodoc
class _$HeartRateCopyWithImpl<$Res> implements $HeartRateCopyWith<$Res> {
  _$HeartRateCopyWithImpl(this._self, this._then);

  final HeartRate _self;
  final $Res Function(HeartRate) _then;

  /// Create a copy of HeartRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heartRate = null,
    Object? measuredAt = null,
  }) {
    return _then(_self.copyWith(
      heartRate: null == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int,
      measuredAt: null == measuredAt
          ? _self.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [HeartRate].
extension HeartRatePatterns on HeartRate {
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
    TResult Function(_HeartRate value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRate() when $default != null:
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
    TResult Function(_HeartRate value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRate():
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
    TResult? Function(_HeartRate value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRate() when $default != null:
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
    TResult Function(int heartRate, DateTime measuredAt)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRate() when $default != null:
        return $default(_that.heartRate, _that.measuredAt);
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
    TResult Function(int heartRate, DateTime measuredAt) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRate():
        return $default(_that.heartRate, _that.measuredAt);
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
    TResult? Function(int heartRate, DateTime measuredAt)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRate() when $default != null:
        return $default(_that.heartRate, _that.measuredAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HeartRate implements HeartRate {
  const _HeartRate({required this.heartRate, required this.measuredAt});
  factory _HeartRate.fromJson(Map<String, dynamic> json) =>
      _$HeartRateFromJson(json);

  @override
  final int heartRate;
  @override
  final DateTime measuredAt;

  /// Create a copy of HeartRate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HeartRateCopyWith<_HeartRate> get copyWith =>
      __$HeartRateCopyWithImpl<_HeartRate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HeartRateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HeartRate &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, heartRate, measuredAt);

  @override
  String toString() {
    return 'HeartRate(heartRate: $heartRate, measuredAt: $measuredAt)';
  }
}

/// @nodoc
abstract mixin class _$HeartRateCopyWith<$Res>
    implements $HeartRateCopyWith<$Res> {
  factory _$HeartRateCopyWith(
          _HeartRate value, $Res Function(_HeartRate) _then) =
      __$HeartRateCopyWithImpl;
  @override
  @useResult
  $Res call({int heartRate, DateTime measuredAt});
}

/// @nodoc
class __$HeartRateCopyWithImpl<$Res> implements _$HeartRateCopyWith<$Res> {
  __$HeartRateCopyWithImpl(this._self, this._then);

  final _HeartRate _self;
  final $Res Function(_HeartRate) _then;

  /// Create a copy of HeartRate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? heartRate = null,
    Object? measuredAt = null,
  }) {
    return _then(_HeartRate(
      heartRate: null == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int,
      measuredAt: null == measuredAt
          ? _self.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
