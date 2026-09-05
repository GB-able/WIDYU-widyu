// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine_point_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicinePointResult {
  int get currentPoints;
  int get earnedPoints;

  /// Create a copy of MedicinePointResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicinePointResultCopyWith<MedicinePointResult> get copyWith =>
      _$MedicinePointResultCopyWithImpl<MedicinePointResult>(
          this as MedicinePointResult, _$identity);

  /// Serializes this MedicinePointResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicinePointResult &&
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
    return 'MedicinePointResult(currentPoints: $currentPoints, earnedPoints: $earnedPoints)';
  }
}

/// @nodoc
abstract mixin class $MedicinePointResultCopyWith<$Res> {
  factory $MedicinePointResultCopyWith(
          MedicinePointResult value, $Res Function(MedicinePointResult) _then) =
      _$MedicinePointResultCopyWithImpl;
  @useResult
  $Res call({int currentPoints, int earnedPoints});
}

/// @nodoc
class _$MedicinePointResultCopyWithImpl<$Res>
    implements $MedicinePointResultCopyWith<$Res> {
  _$MedicinePointResultCopyWithImpl(this._self, this._then);

  final MedicinePointResult _self;
  final $Res Function(MedicinePointResult) _then;

  /// Create a copy of MedicinePointResult
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

/// Adds pattern-matching-related methods to [MedicinePointResult].
extension MedicinePointResultPatterns on MedicinePointResult {
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
    TResult Function(_MedicinePointResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicinePointResult() when $default != null:
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
    TResult Function(_MedicinePointResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicinePointResult():
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
    TResult? Function(_MedicinePointResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicinePointResult() when $default != null:
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
      case _MedicinePointResult() when $default != null:
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
      case _MedicinePointResult():
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
      case _MedicinePointResult() when $default != null:
        return $default(_that.currentPoints, _that.earnedPoints);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MedicinePointResult implements MedicinePointResult {
  const _MedicinePointResult({this.currentPoints = 0, this.earnedPoints = 0});
  factory _MedicinePointResult.fromJson(Map<String, dynamic> json) =>
      _$MedicinePointResultFromJson(json);

  @override
  @JsonKey()
  final int currentPoints;
  @override
  @JsonKey()
  final int earnedPoints;

  /// Create a copy of MedicinePointResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicinePointResultCopyWith<_MedicinePointResult> get copyWith =>
      __$MedicinePointResultCopyWithImpl<_MedicinePointResult>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicinePointResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicinePointResult &&
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
    return 'MedicinePointResult(currentPoints: $currentPoints, earnedPoints: $earnedPoints)';
  }
}

/// @nodoc
abstract mixin class _$MedicinePointResultCopyWith<$Res>
    implements $MedicinePointResultCopyWith<$Res> {
  factory _$MedicinePointResultCopyWith(_MedicinePointResult value,
          $Res Function(_MedicinePointResult) _then) =
      __$MedicinePointResultCopyWithImpl;
  @override
  @useResult
  $Res call({int currentPoints, int earnedPoints});
}

/// @nodoc
class __$MedicinePointResultCopyWithImpl<$Res>
    implements _$MedicinePointResultCopyWith<$Res> {
  __$MedicinePointResultCopyWithImpl(this._self, this._then);

  final _MedicinePointResult _self;
  final $Res Function(_MedicinePointResult) _then;

  /// Create a copy of MedicinePointResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentPoints = null,
    Object? earnedPoints = null,
  }) {
    return _then(_MedicinePointResult(
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
