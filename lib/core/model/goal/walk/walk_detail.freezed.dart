// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalkDetail {
  int get goal;
  int get actual;

  /// Create a copy of WalkDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalkDetailCopyWith<WalkDetail> get copyWith =>
      _$WalkDetailCopyWithImpl<WalkDetail>(this as WalkDetail, _$identity);

  /// Serializes this WalkDetail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WalkDetail &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.actual, actual) || other.actual == actual));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, goal, actual);

  @override
  String toString() {
    return 'WalkDetail(goal: $goal, actual: $actual)';
  }
}

/// @nodoc
abstract mixin class $WalkDetailCopyWith<$Res> {
  factory $WalkDetailCopyWith(
          WalkDetail value, $Res Function(WalkDetail) _then) =
      _$WalkDetailCopyWithImpl;
  @useResult
  $Res call({int goal, int actual});
}

/// @nodoc
class _$WalkDetailCopyWithImpl<$Res> implements $WalkDetailCopyWith<$Res> {
  _$WalkDetailCopyWithImpl(this._self, this._then);

  final WalkDetail _self;
  final $Res Function(WalkDetail) _then;

  /// Create a copy of WalkDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goal = null,
    Object? actual = null,
  }) {
    return _then(_self.copyWith(
      goal: null == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as int,
      actual: null == actual
          ? _self.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [WalkDetail].
extension WalkDetailPatterns on WalkDetail {
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
    TResult Function(_WalkDetail value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalkDetail() when $default != null:
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
    TResult Function(_WalkDetail value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkDetail():
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
    TResult? Function(_WalkDetail value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkDetail() when $default != null:
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
    TResult Function(int goal, int actual)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalkDetail() when $default != null:
        return $default(_that.goal, _that.actual);
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
    TResult Function(int goal, int actual) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkDetail():
        return $default(_that.goal, _that.actual);
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
    TResult? Function(int goal, int actual)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkDetail() when $default != null:
        return $default(_that.goal, _that.actual);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WalkDetail implements WalkDetail {
  const _WalkDetail({required this.goal, required this.actual});
  factory _WalkDetail.fromJson(Map<String, dynamic> json) =>
      _$WalkDetailFromJson(json);

  @override
  final int goal;
  @override
  final int actual;

  /// Create a copy of WalkDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WalkDetailCopyWith<_WalkDetail> get copyWith =>
      __$WalkDetailCopyWithImpl<_WalkDetail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WalkDetailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WalkDetail &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.actual, actual) || other.actual == actual));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, goal, actual);

  @override
  String toString() {
    return 'WalkDetail(goal: $goal, actual: $actual)';
  }
}

/// @nodoc
abstract mixin class _$WalkDetailCopyWith<$Res>
    implements $WalkDetailCopyWith<$Res> {
  factory _$WalkDetailCopyWith(
          _WalkDetail value, $Res Function(_WalkDetail) _then) =
      __$WalkDetailCopyWithImpl;
  @override
  @useResult
  $Res call({int goal, int actual});
}

/// @nodoc
class __$WalkDetailCopyWithImpl<$Res> implements _$WalkDetailCopyWith<$Res> {
  __$WalkDetailCopyWithImpl(this._self, this._then);

  final _WalkDetail _self;
  final $Res Function(_WalkDetail) _then;

  /// Create a copy of WalkDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? goal = null,
    Object? actual = null,
  }) {
    return _then(_WalkDetail(
      goal: null == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as int,
      actual: null == actual
          ? _self.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
