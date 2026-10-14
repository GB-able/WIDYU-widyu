// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationVerification {
  int get earnedPoints;
  int get currentPoints;

  /// Create a copy of MedicationVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationVerificationCopyWith<MedicationVerification> get copyWith =>
      _$MedicationVerificationCopyWithImpl<MedicationVerification>(
          this as MedicationVerification, _$identity);

  /// Serializes this MedicationVerification to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationVerification &&
            (identical(other.earnedPoints, earnedPoints) ||
                other.earnedPoints == earnedPoints) &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, earnedPoints, currentPoints);

  @override
  String toString() {
    return 'MedicationVerification(earnedPoints: $earnedPoints, currentPoints: $currentPoints)';
  }
}

/// @nodoc
abstract mixin class $MedicationVerificationCopyWith<$Res> {
  factory $MedicationVerificationCopyWith(MedicationVerification value,
          $Res Function(MedicationVerification) _then) =
      _$MedicationVerificationCopyWithImpl;
  @useResult
  $Res call({int earnedPoints, int currentPoints});
}

/// @nodoc
class _$MedicationVerificationCopyWithImpl<$Res>
    implements $MedicationVerificationCopyWith<$Res> {
  _$MedicationVerificationCopyWithImpl(this._self, this._then);

  final MedicationVerification _self;
  final $Res Function(MedicationVerification) _then;

  /// Create a copy of MedicationVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? earnedPoints = null,
    Object? currentPoints = null,
  }) {
    return _then(_self.copyWith(
      earnedPoints: null == earnedPoints
          ? _self.earnedPoints
          : earnedPoints // ignore: cast_nullable_to_non_nullable
              as int,
      currentPoints: null == currentPoints
          ? _self.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicationVerification].
extension MedicationVerificationPatterns on MedicationVerification {
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
    TResult Function(_MedicationVerification value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationVerification() when $default != null:
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
    TResult Function(_MedicationVerification value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationVerification():
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
    TResult? Function(_MedicationVerification value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationVerification() when $default != null:
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
    TResult Function(int earnedPoints, int currentPoints)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationVerification() when $default != null:
        return $default(_that.earnedPoints, _that.currentPoints);
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
    TResult Function(int earnedPoints, int currentPoints) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationVerification():
        return $default(_that.earnedPoints, _that.currentPoints);
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
    TResult? Function(int earnedPoints, int currentPoints)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationVerification() when $default != null:
        return $default(_that.earnedPoints, _that.currentPoints);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MedicationVerification implements MedicationVerification {
  const _MedicationVerification(
      {required this.earnedPoints, required this.currentPoints});
  factory _MedicationVerification.fromJson(Map<String, dynamic> json) =>
      _$MedicationVerificationFromJson(json);

  @override
  final int earnedPoints;
  @override
  final int currentPoints;

  /// Create a copy of MedicationVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationVerificationCopyWith<_MedicationVerification> get copyWith =>
      __$MedicationVerificationCopyWithImpl<_MedicationVerification>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicationVerificationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationVerification &&
            (identical(other.earnedPoints, earnedPoints) ||
                other.earnedPoints == earnedPoints) &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, earnedPoints, currentPoints);

  @override
  String toString() {
    return 'MedicationVerification(earnedPoints: $earnedPoints, currentPoints: $currentPoints)';
  }
}

/// @nodoc
abstract mixin class _$MedicationVerificationCopyWith<$Res>
    implements $MedicationVerificationCopyWith<$Res> {
  factory _$MedicationVerificationCopyWith(_MedicationVerification value,
          $Res Function(_MedicationVerification) _then) =
      __$MedicationVerificationCopyWithImpl;
  @override
  @useResult
  $Res call({int earnedPoints, int currentPoints});
}

/// @nodoc
class __$MedicationVerificationCopyWithImpl<$Res>
    implements _$MedicationVerificationCopyWith<$Res> {
  __$MedicationVerificationCopyWithImpl(this._self, this._then);

  final _MedicationVerification _self;
  final $Res Function(_MedicationVerification) _then;

  /// Create a copy of MedicationVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? earnedPoints = null,
    Object? currentPoints = null,
  }) {
    return _then(_MedicationVerification(
      earnedPoints: null == earnedPoints
          ? _self.earnedPoints
          : earnedPoints // ignore: cast_nullable_to_non_nullable
              as int,
      currentPoints: null == currentPoints
          ? _self.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
