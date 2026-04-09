// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heart_rate_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeartRateRequest {
  List<HeartRate> get heartRates;

  /// Create a copy of HeartRateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeartRateRequestCopyWith<HeartRateRequest> get copyWith =>
      _$HeartRateRequestCopyWithImpl<HeartRateRequest>(
          this as HeartRateRequest, _$identity);

  /// Serializes this HeartRateRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeartRateRequest &&
            const DeepCollectionEquality()
                .equals(other.heartRates, heartRates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(heartRates));

  @override
  String toString() {
    return 'HeartRateRequest(heartRates: $heartRates)';
  }
}

/// @nodoc
abstract mixin class $HeartRateRequestCopyWith<$Res> {
  factory $HeartRateRequestCopyWith(
          HeartRateRequest value, $Res Function(HeartRateRequest) _then) =
      _$HeartRateRequestCopyWithImpl;
  @useResult
  $Res call({List<HeartRate> heartRates});
}

/// @nodoc
class _$HeartRateRequestCopyWithImpl<$Res>
    implements $HeartRateRequestCopyWith<$Res> {
  _$HeartRateRequestCopyWithImpl(this._self, this._then);

  final HeartRateRequest _self;
  final $Res Function(HeartRateRequest) _then;

  /// Create a copy of HeartRateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heartRates = null,
  }) {
    return _then(_self.copyWith(
      heartRates: null == heartRates
          ? _self.heartRates
          : heartRates // ignore: cast_nullable_to_non_nullable
              as List<HeartRate>,
    ));
  }
}

/// Adds pattern-matching-related methods to [HeartRateRequest].
extension HeartRateRequestPatterns on HeartRateRequest {
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
    TResult Function(_HeartRateRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRateRequest() when $default != null:
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
    TResult Function(_HeartRateRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateRequest():
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
    TResult? Function(_HeartRateRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateRequest() when $default != null:
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
    TResult Function(List<HeartRate> heartRates)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeartRateRequest() when $default != null:
        return $default(_that.heartRates);
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
    TResult Function(List<HeartRate> heartRates) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateRequest():
        return $default(_that.heartRates);
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
    TResult? Function(List<HeartRate> heartRates)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeartRateRequest() when $default != null:
        return $default(_that.heartRates);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HeartRateRequest implements HeartRateRequest {
  const _HeartRateRequest({required final List<HeartRate> heartRates})
      : _heartRates = heartRates;
  factory _HeartRateRequest.fromJson(Map<String, dynamic> json) =>
      _$HeartRateRequestFromJson(json);

  final List<HeartRate> _heartRates;
  @override
  List<HeartRate> get heartRates {
    if (_heartRates is EqualUnmodifiableListView) return _heartRates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_heartRates);
  }

  /// Create a copy of HeartRateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HeartRateRequestCopyWith<_HeartRateRequest> get copyWith =>
      __$HeartRateRequestCopyWithImpl<_HeartRateRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HeartRateRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HeartRateRequest &&
            const DeepCollectionEquality()
                .equals(other._heartRates, _heartRates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_heartRates));

  @override
  String toString() {
    return 'HeartRateRequest(heartRates: $heartRates)';
  }
}

/// @nodoc
abstract mixin class _$HeartRateRequestCopyWith<$Res>
    implements $HeartRateRequestCopyWith<$Res> {
  factory _$HeartRateRequestCopyWith(
          _HeartRateRequest value, $Res Function(_HeartRateRequest) _then) =
      __$HeartRateRequestCopyWithImpl;
  @override
  @useResult
  $Res call({List<HeartRate> heartRates});
}

/// @nodoc
class __$HeartRateRequestCopyWithImpl<$Res>
    implements _$HeartRateRequestCopyWith<$Res> {
  __$HeartRateRequestCopyWithImpl(this._self, this._then);

  final _HeartRateRequest _self;
  final $Res Function(_HeartRateRequest) _then;

  /// Create a copy of HeartRateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? heartRates = null,
  }) {
    return _then(_HeartRateRequest(
      heartRates: null == heartRates
          ? _self._heartRates
          : heartRates // ignore: cast_nullable_to_non_nullable
              as List<HeartRate>,
    ));
  }
}

// dart format on
