// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyCode {
  String get familyCode;

  /// Create a copy of FamilyCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FamilyCodeCopyWith<FamilyCode> get copyWith =>
      _$FamilyCodeCopyWithImpl<FamilyCode>(this as FamilyCode, _$identity);

  /// Serializes this FamilyCode to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FamilyCode &&
            (identical(other.familyCode, familyCode) ||
                other.familyCode == familyCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, familyCode);

  @override
  String toString() {
    return 'FamilyCode(familyCode: $familyCode)';
  }
}

/// @nodoc
abstract mixin class $FamilyCodeCopyWith<$Res> {
  factory $FamilyCodeCopyWith(
          FamilyCode value, $Res Function(FamilyCode) _then) =
      _$FamilyCodeCopyWithImpl;
  @useResult
  $Res call({String familyCode});
}

/// @nodoc
class _$FamilyCodeCopyWithImpl<$Res> implements $FamilyCodeCopyWith<$Res> {
  _$FamilyCodeCopyWithImpl(this._self, this._then);

  final FamilyCode _self;
  final $Res Function(FamilyCode) _then;

  /// Create a copy of FamilyCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? familyCode = null,
  }) {
    return _then(_self.copyWith(
      familyCode: null == familyCode
          ? _self.familyCode
          : familyCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [FamilyCode].
extension FamilyCodePatterns on FamilyCode {
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
    TResult Function(_FamilyCode value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FamilyCode() when $default != null:
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
    TResult Function(_FamilyCode value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FamilyCode():
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
    TResult? Function(_FamilyCode value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FamilyCode() when $default != null:
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
    TResult Function(String familyCode)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FamilyCode() when $default != null:
        return $default(_that.familyCode);
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
    TResult Function(String familyCode) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FamilyCode():
        return $default(_that.familyCode);
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
    TResult? Function(String familyCode)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FamilyCode() when $default != null:
        return $default(_that.familyCode);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FamilyCode implements FamilyCode {
  const _FamilyCode({required this.familyCode});
  factory _FamilyCode.fromJson(Map<String, dynamic> json) =>
      _$FamilyCodeFromJson(json);

  @override
  final String familyCode;

  /// Create a copy of FamilyCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FamilyCodeCopyWith<_FamilyCode> get copyWith =>
      __$FamilyCodeCopyWithImpl<_FamilyCode>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FamilyCodeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FamilyCode &&
            (identical(other.familyCode, familyCode) ||
                other.familyCode == familyCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, familyCode);

  @override
  String toString() {
    return 'FamilyCode(familyCode: $familyCode)';
  }
}

/// @nodoc
abstract mixin class _$FamilyCodeCopyWith<$Res>
    implements $FamilyCodeCopyWith<$Res> {
  factory _$FamilyCodeCopyWith(
          _FamilyCode value, $Res Function(_FamilyCode) _then) =
      __$FamilyCodeCopyWithImpl;
  @override
  @useResult
  $Res call({String familyCode});
}

/// @nodoc
class __$FamilyCodeCopyWithImpl<$Res> implements _$FamilyCodeCopyWith<$Res> {
  __$FamilyCodeCopyWithImpl(this._self, this._then);

  final _FamilyCode _self;
  final $Res Function(_FamilyCode) _then;

  /// Create a copy of FamilyCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? familyCode = null,
  }) {
    return _then(_FamilyCode(
      familyCode: null == familyCode
          ? _self.familyCode
          : familyCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
