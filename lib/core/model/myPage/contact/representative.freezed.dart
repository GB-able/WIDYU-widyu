// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'representative.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Representative {
  String get name;
  String get phoneNumber;

  /// Create a copy of Representative
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RepresentativeCopyWith<Representative> get copyWith =>
      _$RepresentativeCopyWithImpl<Representative>(
          this as Representative, _$identity);

  /// Serializes this Representative to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Representative &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, phoneNumber);

  @override
  String toString() {
    return 'Representative(name: $name, phoneNumber: $phoneNumber)';
  }
}

/// @nodoc
abstract mixin class $RepresentativeCopyWith<$Res> {
  factory $RepresentativeCopyWith(
          Representative value, $Res Function(Representative) _then) =
      _$RepresentativeCopyWithImpl;
  @useResult
  $Res call({String name, String phoneNumber});
}

/// @nodoc
class _$RepresentativeCopyWithImpl<$Res>
    implements $RepresentativeCopyWith<$Res> {
  _$RepresentativeCopyWithImpl(this._self, this._then);

  final Representative _self;
  final $Res Function(Representative) _then;

  /// Create a copy of Representative
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? phoneNumber = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Representative].
extension RepresentativePatterns on Representative {
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
    TResult Function(_Representative value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Representative() when $default != null:
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
    TResult Function(_Representative value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Representative():
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
    TResult? Function(_Representative value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Representative() when $default != null:
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
    TResult Function(String name, String phoneNumber)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Representative() when $default != null:
        return $default(_that.name, _that.phoneNumber);
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
    TResult Function(String name, String phoneNumber) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Representative():
        return $default(_that.name, _that.phoneNumber);
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
    TResult? Function(String name, String phoneNumber)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Representative() when $default != null:
        return $default(_that.name, _that.phoneNumber);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Representative implements Representative {
  const _Representative({required this.name, required this.phoneNumber});
  factory _Representative.fromJson(Map<String, dynamic> json) =>
      _$RepresentativeFromJson(json);

  @override
  final String name;
  @override
  final String phoneNumber;

  /// Create a copy of Representative
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RepresentativeCopyWith<_Representative> get copyWith =>
      __$RepresentativeCopyWithImpl<_Representative>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RepresentativeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Representative &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, phoneNumber);

  @override
  String toString() {
    return 'Representative(name: $name, phoneNumber: $phoneNumber)';
  }
}

/// @nodoc
abstract mixin class _$RepresentativeCopyWith<$Res>
    implements $RepresentativeCopyWith<$Res> {
  factory _$RepresentativeCopyWith(
          _Representative value, $Res Function(_Representative) _then) =
      __$RepresentativeCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String phoneNumber});
}

/// @nodoc
class __$RepresentativeCopyWithImpl<$Res>
    implements _$RepresentativeCopyWith<$Res> {
  __$RepresentativeCopyWithImpl(this._self, this._then);

  final _Representative _self;
  final $Res Function(_Representative) _then;

  /// Create a copy of Representative
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? phoneNumber = null,
  }) {
    return _then(_Representative(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
