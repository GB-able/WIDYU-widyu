// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_service_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationServiceState {
  bool get serviceEnabled;
  bool get permissionGranted;

  /// Create a copy of LocationServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocationServiceStateCopyWith<LocationServiceState> get copyWith =>
      _$LocationServiceStateCopyWithImpl<LocationServiceState>(
          this as LocationServiceState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocationServiceState &&
            (identical(other.serviceEnabled, serviceEnabled) ||
                other.serviceEnabled == serviceEnabled) &&
            (identical(other.permissionGranted, permissionGranted) ||
                other.permissionGranted == permissionGranted));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, serviceEnabled, permissionGranted);

  @override
  String toString() {
    return 'LocationServiceState(serviceEnabled: $serviceEnabled, permissionGranted: $permissionGranted)';
  }
}

/// @nodoc
abstract mixin class $LocationServiceStateCopyWith<$Res> {
  factory $LocationServiceStateCopyWith(LocationServiceState value,
          $Res Function(LocationServiceState) _then) =
      _$LocationServiceStateCopyWithImpl;
  @useResult
  $Res call({bool serviceEnabled, bool permissionGranted});
}

/// @nodoc
class _$LocationServiceStateCopyWithImpl<$Res>
    implements $LocationServiceStateCopyWith<$Res> {
  _$LocationServiceStateCopyWithImpl(this._self, this._then);

  final LocationServiceState _self;
  final $Res Function(LocationServiceState) _then;

  /// Create a copy of LocationServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceEnabled = null,
    Object? permissionGranted = null,
  }) {
    return _then(_self.copyWith(
      serviceEnabled: null == serviceEnabled
          ? _self.serviceEnabled
          : serviceEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      permissionGranted: null == permissionGranted
          ? _self.permissionGranted
          : permissionGranted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [LocationServiceState].
extension LocationServiceStatePatterns on LocationServiceState {
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
    TResult Function(_LocationServiceState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocationServiceState() when $default != null:
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
    TResult Function(_LocationServiceState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationServiceState():
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
    TResult? Function(_LocationServiceState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationServiceState() when $default != null:
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
    TResult Function(bool serviceEnabled, bool permissionGranted)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocationServiceState() when $default != null:
        return $default(_that.serviceEnabled, _that.permissionGranted);
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
    TResult Function(bool serviceEnabled, bool permissionGranted) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationServiceState():
        return $default(_that.serviceEnabled, _that.permissionGranted);
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
    TResult? Function(bool serviceEnabled, bool permissionGranted)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationServiceState() when $default != null:
        return $default(_that.serviceEnabled, _that.permissionGranted);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LocationServiceState extends LocationServiceState {
  _LocationServiceState(
      {required this.serviceEnabled, required this.permissionGranted})
      : super._();

  @override
  final bool serviceEnabled;
  @override
  final bool permissionGranted;

  /// Create a copy of LocationServiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocationServiceStateCopyWith<_LocationServiceState> get copyWith =>
      __$LocationServiceStateCopyWithImpl<_LocationServiceState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocationServiceState &&
            (identical(other.serviceEnabled, serviceEnabled) ||
                other.serviceEnabled == serviceEnabled) &&
            (identical(other.permissionGranted, permissionGranted) ||
                other.permissionGranted == permissionGranted));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, serviceEnabled, permissionGranted);

  @override
  String toString() {
    return 'LocationServiceState(serviceEnabled: $serviceEnabled, permissionGranted: $permissionGranted)';
  }
}

/// @nodoc
abstract mixin class _$LocationServiceStateCopyWith<$Res>
    implements $LocationServiceStateCopyWith<$Res> {
  factory _$LocationServiceStateCopyWith(_LocationServiceState value,
          $Res Function(_LocationServiceState) _then) =
      __$LocationServiceStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool serviceEnabled, bool permissionGranted});
}

/// @nodoc
class __$LocationServiceStateCopyWithImpl<$Res>
    implements _$LocationServiceStateCopyWith<$Res> {
  __$LocationServiceStateCopyWithImpl(this._self, this._then);

  final _LocationServiceState _self;
  final $Res Function(_LocationServiceState) _then;

  /// Create a copy of LocationServiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? serviceEnabled = null,
    Object? permissionGranted = null,
  }) {
    return _then(_LocationServiceState(
      serviceEnabled: null == serviceEnabled
          ? _self.serviceEnabled
          : serviceEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      permissionGranted: null == permissionGranted
          ? _self.permissionGranted
          : permissionGranted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
