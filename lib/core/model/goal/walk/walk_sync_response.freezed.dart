// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_sync_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalkSyncResponse {
  bool get achieved;

  /// Create a copy of WalkSyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalkSyncResponseCopyWith<WalkSyncResponse> get copyWith =>
      _$WalkSyncResponseCopyWithImpl<WalkSyncResponse>(
          this as WalkSyncResponse, _$identity);

  /// Serializes this WalkSyncResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WalkSyncResponse &&
            (identical(other.achieved, achieved) ||
                other.achieved == achieved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, achieved);

  @override
  String toString() {
    return 'WalkSyncResponse(achieved: $achieved)';
  }
}

/// @nodoc
abstract mixin class $WalkSyncResponseCopyWith<$Res> {
  factory $WalkSyncResponseCopyWith(
          WalkSyncResponse value, $Res Function(WalkSyncResponse) _then) =
      _$WalkSyncResponseCopyWithImpl;
  @useResult
  $Res call({bool achieved});
}

/// @nodoc
class _$WalkSyncResponseCopyWithImpl<$Res>
    implements $WalkSyncResponseCopyWith<$Res> {
  _$WalkSyncResponseCopyWithImpl(this._self, this._then);

  final WalkSyncResponse _self;
  final $Res Function(WalkSyncResponse) _then;

  /// Create a copy of WalkSyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? achieved = null,
  }) {
    return _then(_self.copyWith(
      achieved: null == achieved
          ? _self.achieved
          : achieved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [WalkSyncResponse].
extension WalkSyncResponsePatterns on WalkSyncResponse {
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
    TResult Function(_WalkSyncResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalkSyncResponse() when $default != null:
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
    TResult Function(_WalkSyncResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkSyncResponse():
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
    TResult? Function(_WalkSyncResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkSyncResponse() when $default != null:
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
    TResult Function(bool achieved)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalkSyncResponse() when $default != null:
        return $default(_that.achieved);
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
    TResult Function(bool achieved) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkSyncResponse():
        return $default(_that.achieved);
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
    TResult? Function(bool achieved)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkSyncResponse() when $default != null:
        return $default(_that.achieved);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WalkSyncResponse implements WalkSyncResponse {
  const _WalkSyncResponse({required this.achieved});
  factory _WalkSyncResponse.fromJson(Map<String, dynamic> json) =>
      _$WalkSyncResponseFromJson(json);

  @override
  final bool achieved;

  /// Create a copy of WalkSyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WalkSyncResponseCopyWith<_WalkSyncResponse> get copyWith =>
      __$WalkSyncResponseCopyWithImpl<_WalkSyncResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WalkSyncResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WalkSyncResponse &&
            (identical(other.achieved, achieved) ||
                other.achieved == achieved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, achieved);

  @override
  String toString() {
    return 'WalkSyncResponse(achieved: $achieved)';
  }
}

/// @nodoc
abstract mixin class _$WalkSyncResponseCopyWith<$Res>
    implements $WalkSyncResponseCopyWith<$Res> {
  factory _$WalkSyncResponseCopyWith(
          _WalkSyncResponse value, $Res Function(_WalkSyncResponse) _then) =
      __$WalkSyncResponseCopyWithImpl;
  @override
  @useResult
  $Res call({bool achieved});
}

/// @nodoc
class __$WalkSyncResponseCopyWithImpl<$Res>
    implements _$WalkSyncResponseCopyWith<$Res> {
  __$WalkSyncResponseCopyWithImpl(this._self, this._then);

  final _WalkSyncResponse _self;
  final $Res Function(_WalkSyncResponse) _then;

  /// Create a copy of WalkSyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? achieved = null,
  }) {
    return _then(_WalkSyncResponse(
      achieved: null == achieved
          ? _self.achieved
          : achieved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
