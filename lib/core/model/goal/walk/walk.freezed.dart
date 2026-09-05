// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Walk {
  int get goal;
  @JsonKey(name: 'steps')
  int get actual;
  bool? get isReward;

  /// Create a copy of Walk
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalkCopyWith<Walk> get copyWith =>
      _$WalkCopyWithImpl<Walk>(this as Walk, _$identity);

  /// Serializes this Walk to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Walk &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.isReward, isReward) ||
                other.isReward == isReward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, goal, actual, isReward);

  @override
  String toString() {
    return 'Walk(goal: $goal, actual: $actual, isReward: $isReward)';
  }
}

/// @nodoc
abstract mixin class $WalkCopyWith<$Res> {
  factory $WalkCopyWith(Walk value, $Res Function(Walk) _then) =
      _$WalkCopyWithImpl;
  @useResult
  $Res call({int goal, @JsonKey(name: 'steps') int actual, bool? isReward});
}

/// @nodoc
class _$WalkCopyWithImpl<$Res> implements $WalkCopyWith<$Res> {
  _$WalkCopyWithImpl(this._self, this._then);

  final Walk _self;
  final $Res Function(Walk) _then;

  /// Create a copy of Walk
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goal = null,
    Object? actual = null,
    Object? isReward = freezed,
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
      isReward: freezed == isReward
          ? _self.isReward
          : isReward // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Walk].
extension WalkPatterns on Walk {
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
    TResult Function(_Walk value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Walk() when $default != null:
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
    TResult Function(_Walk value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Walk():
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
    TResult? Function(_Walk value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Walk() when $default != null:
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
    TResult Function(
            int goal, @JsonKey(name: 'steps') int actual, bool? isReward)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Walk() when $default != null:
        return $default(_that.goal, _that.actual, _that.isReward);
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
    TResult Function(
            int goal, @JsonKey(name: 'steps') int actual, bool? isReward)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Walk():
        return $default(_that.goal, _that.actual, _that.isReward);
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
    TResult? Function(
            int goal, @JsonKey(name: 'steps') int actual, bool? isReward)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Walk() when $default != null:
        return $default(_that.goal, _that.actual, _that.isReward);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Walk implements Walk {
  const _Walk(
      {required this.goal,
      @JsonKey(name: 'steps') required this.actual,
      this.isReward});
  factory _Walk.fromJson(Map<String, dynamic> json) => _$WalkFromJson(json);

  @override
  final int goal;
  @override
  @JsonKey(name: 'steps')
  final int actual;
  @override
  final bool? isReward;

  /// Create a copy of Walk
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WalkCopyWith<_Walk> get copyWith =>
      __$WalkCopyWithImpl<_Walk>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WalkToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Walk &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.isReward, isReward) ||
                other.isReward == isReward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, goal, actual, isReward);

  @override
  String toString() {
    return 'Walk(goal: $goal, actual: $actual, isReward: $isReward)';
  }
}

/// @nodoc
abstract mixin class _$WalkCopyWith<$Res> implements $WalkCopyWith<$Res> {
  factory _$WalkCopyWith(_Walk value, $Res Function(_Walk) _then) =
      __$WalkCopyWithImpl;
  @override
  @useResult
  $Res call({int goal, @JsonKey(name: 'steps') int actual, bool? isReward});
}

/// @nodoc
class __$WalkCopyWithImpl<$Res> implements _$WalkCopyWith<$Res> {
  __$WalkCopyWithImpl(this._self, this._then);

  final _Walk _self;
  final $Res Function(_Walk) _then;

  /// Create a copy of Walk
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? goal = null,
    Object? actual = null,
    Object? isReward = freezed,
  }) {
    return _then(_Walk(
      goal: null == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as int,
      actual: null == actual
          ? _self.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as int,
      isReward: freezed == isReward
          ? _self.isReward
          : isReward // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
