// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserLocation {
  String? get memberId;
  double get latitude;
  double get longitude;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserLocationCopyWith<UserLocation> get copyWith =>
      _$UserLocationCopyWithImpl<UserLocation>(
          this as UserLocation, _$identity);

  /// Serializes this UserLocation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserLocation &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memberId, latitude, longitude);

  @override
  String toString() {
    return 'UserLocation(memberId: $memberId, latitude: $latitude, longitude: $longitude)';
  }
}

/// @nodoc
abstract mixin class $UserLocationCopyWith<$Res> {
  factory $UserLocationCopyWith(
          UserLocation value, $Res Function(UserLocation) _then) =
      _$UserLocationCopyWithImpl;
  @useResult
  $Res call({String? memberId, double latitude, double longitude});
}

/// @nodoc
class _$UserLocationCopyWithImpl<$Res> implements $UserLocationCopyWith<$Res> {
  _$UserLocationCopyWithImpl(this._self, this._then);

  final UserLocation _self;
  final $Res Function(UserLocation) _then;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = freezed,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_self.copyWith(
      memberId: freezed == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserLocation].
extension UserLocationPatterns on UserLocation {
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
    TResult Function(_UserLocation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserLocation() when $default != null:
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
    TResult Function(_UserLocation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserLocation():
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
    TResult? Function(_UserLocation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserLocation() when $default != null:
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
    TResult Function(String? memberId, double latitude, double longitude)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserLocation() when $default != null:
        return $default(_that.memberId, _that.latitude, _that.longitude);
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
    TResult Function(String? memberId, double latitude, double longitude)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserLocation():
        return $default(_that.memberId, _that.latitude, _that.longitude);
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
    TResult? Function(String? memberId, double latitude, double longitude)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserLocation() when $default != null:
        return $default(_that.memberId, _that.latitude, _that.longitude);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserLocation implements UserLocation {
  const _UserLocation(
      {this.memberId, required this.latitude, required this.longitude});
  factory _UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);

  @override
  final String? memberId;
  @override
  final double latitude;
  @override
  final double longitude;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserLocationCopyWith<_UserLocation> get copyWith =>
      __$UserLocationCopyWithImpl<_UserLocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserLocationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserLocation &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memberId, latitude, longitude);

  @override
  String toString() {
    return 'UserLocation(memberId: $memberId, latitude: $latitude, longitude: $longitude)';
  }
}

/// @nodoc
abstract mixin class _$UserLocationCopyWith<$Res>
    implements $UserLocationCopyWith<$Res> {
  factory _$UserLocationCopyWith(
          _UserLocation value, $Res Function(_UserLocation) _then) =
      __$UserLocationCopyWithImpl;
  @override
  @useResult
  $Res call({String? memberId, double latitude, double longitude});
}

/// @nodoc
class __$UserLocationCopyWithImpl<$Res>
    implements _$UserLocationCopyWith<$Res> {
  __$UserLocationCopyWithImpl(this._self, this._then);

  final _UserLocation _self;
  final $Res Function(_UserLocation) _then;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? memberId = freezed,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_UserLocation(
      memberId: freezed == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
