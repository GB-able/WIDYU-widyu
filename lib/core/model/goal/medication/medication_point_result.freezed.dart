// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_point_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationPointResult {
  int get currentPoints;
  int get earnedPoints;

  /// Create a copy of MedicationPointResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationPointResultCopyWith<MedicationPointResult> get copyWith =>
      _$MedicationPointResultCopyWithImpl<MedicationPointResult>(
          this as MedicationPointResult, _$identity);

  /// Serializes this MedicationPointResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationPointResult &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints) &&
            (identical(other.earnedPoints, earnedPoints) ||
                other.earnedPoints == earnedPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPoints, earnedPoints);

  @override
  String toString() {
    return 'MedicationPointResult(currentPoints: $currentPoints, earnedPoints: $earnedPoints)';
  }
}

/// @nodoc
abstract mixin class $MedicationPointResultCopyWith<$Res> {
  factory $MedicationPointResultCopyWith(MedicationPointResult value,
          $Res Function(MedicationPointResult) _then) =
      _$MedicationPointResultCopyWithImpl;
  @useResult
  $Res call({int currentPoints, int earnedPoints});
}

/// @nodoc
class _$MedicationPointResultCopyWithImpl<$Res>
    implements $MedicationPointResultCopyWith<$Res> {
  _$MedicationPointResultCopyWithImpl(this._self, this._then);

  final MedicationPointResult _self;
  final $Res Function(MedicationPointResult) _then;

  /// Create a copy of MedicationPointResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPoints = null,
    Object? earnedPoints = null,
  }) {
    return _then(_self.copyWith(
      currentPoints: null == currentPoints
          ? _self.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      earnedPoints: null == earnedPoints
          ? _self.earnedPoints
          : earnedPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicationPointResult].
extension MedicationPointResultPatterns on MedicationPointResult {
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
    TResult Function(_MedicationPointResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationPointResult() when $default != null:
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
    TResult Function(_MedicationPointResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationPointResult():
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
    TResult? Function(_MedicationPointResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationPointResult() when $default != null:
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
    TResult Function(int currentPoints, int earnedPoints)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationPointResult() when $default != null:
        return $default(_that.currentPoints, _that.earnedPoints);
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
    TResult Function(int currentPoints, int earnedPoints) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationPointResult():
        return $default(_that.currentPoints, _that.earnedPoints);
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
    TResult? Function(int currentPoints, int earnedPoints)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationPointResult() when $default != null:
        return $default(_that.currentPoints, _that.earnedPoints);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MedicationPointResult implements MedicationPointResult {
  const _MedicationPointResult({this.currentPoints = 0, this.earnedPoints = 0});
  factory _MedicationPointResult.fromJson(Map<String, dynamic> json) =>
      _$MedicationPointResultFromJson(json);

  @override
  @JsonKey()
  final int currentPoints;
  @override
  @JsonKey()
  final int earnedPoints;

  /// Create a copy of MedicationPointResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationPointResultCopyWith<_MedicationPointResult> get copyWith =>
      __$MedicationPointResultCopyWithImpl<_MedicationPointResult>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicationPointResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationPointResult &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints) &&
            (identical(other.earnedPoints, earnedPoints) ||
                other.earnedPoints == earnedPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPoints, earnedPoints);

  @override
  String toString() {
    return 'MedicationPointResult(currentPoints: $currentPoints, earnedPoints: $earnedPoints)';
  }
}

/// @nodoc
abstract mixin class _$MedicationPointResultCopyWith<$Res>
    implements $MedicationPointResultCopyWith<$Res> {
  factory _$MedicationPointResultCopyWith(_MedicationPointResult value,
          $Res Function(_MedicationPointResult) _then) =
      __$MedicationPointResultCopyWithImpl;
  @override
  @useResult
  $Res call({int currentPoints, int earnedPoints});
}

/// @nodoc
class __$MedicationPointResultCopyWithImpl<$Res>
    implements _$MedicationPointResultCopyWith<$Res> {
  __$MedicationPointResultCopyWithImpl(this._self, this._then);

  final _MedicationPointResult _self;
  final $Res Function(_MedicationPointResult) _then;

  /// Create a copy of MedicationPointResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentPoints = null,
    Object? earnedPoints = null,
  }) {
    return _then(_MedicationPointResult(
      currentPoints: null == currentPoints
          ? _self.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      earnedPoints: null == earnedPoints
          ? _self.earnedPoints
          : earnedPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
