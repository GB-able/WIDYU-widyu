// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_daily.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalkDaily {
  DateTime get date; // 목표를 정하기 전 날은 null이다.
  int? get goal;
  int? get actual;

  /// Create a copy of WalkDaily
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalkDailyCopyWith<WalkDaily> get copyWith =>
      _$WalkDailyCopyWithImpl<WalkDaily>(this as WalkDaily, _$identity);

  /// Serializes this WalkDaily to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WalkDaily &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.actual, actual) || other.actual == actual));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, goal, actual);

  @override
  String toString() {
    return 'WalkDaily(date: $date, goal: $goal, actual: $actual)';
  }
}

/// @nodoc
abstract mixin class $WalkDailyCopyWith<$Res> {
  factory $WalkDailyCopyWith(WalkDaily value, $Res Function(WalkDaily) _then) =
      _$WalkDailyCopyWithImpl;
  @useResult
  $Res call({DateTime date, int? goal, int? actual});
}

/// @nodoc
class _$WalkDailyCopyWithImpl<$Res> implements $WalkDailyCopyWith<$Res> {
  _$WalkDailyCopyWithImpl(this._self, this._then);

  final WalkDaily _self;
  final $Res Function(WalkDaily) _then;

  /// Create a copy of WalkDaily
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? goal = freezed,
    Object? actual = freezed,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      goal: freezed == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as int?,
      actual: freezed == actual
          ? _self.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [WalkDaily].
extension WalkDailyPatterns on WalkDaily {
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
    TResult Function(_WalkDaily value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalkDaily() when $default != null:
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
    TResult Function(_WalkDaily value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkDaily():
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
    TResult? Function(_WalkDaily value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkDaily() when $default != null:
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
    TResult Function(DateTime date, int? goal, int? actual)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalkDaily() when $default != null:
        return $default(_that.date, _that.goal, _that.actual);
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
    TResult Function(DateTime date, int? goal, int? actual) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkDaily():
        return $default(_that.date, _that.goal, _that.actual);
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
    TResult? Function(DateTime date, int? goal, int? actual)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalkDaily() when $default != null:
        return $default(_that.date, _that.goal, _that.actual);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WalkDaily implements WalkDaily {
  const _WalkDaily({required this.date, this.goal, this.actual});
  factory _WalkDaily.fromJson(Map<String, dynamic> json) =>
      _$WalkDailyFromJson(json);

  @override
  final DateTime date;
// 목표를 정하기 전 날은 null이다.
  @override
  final int? goal;
  @override
  final int? actual;

  /// Create a copy of WalkDaily
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WalkDailyCopyWith<_WalkDaily> get copyWith =>
      __$WalkDailyCopyWithImpl<_WalkDaily>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WalkDailyToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WalkDaily &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.actual, actual) || other.actual == actual));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, goal, actual);

  @override
  String toString() {
    return 'WalkDaily(date: $date, goal: $goal, actual: $actual)';
  }
}

/// @nodoc
abstract mixin class _$WalkDailyCopyWith<$Res>
    implements $WalkDailyCopyWith<$Res> {
  factory _$WalkDailyCopyWith(
          _WalkDaily value, $Res Function(_WalkDaily) _then) =
      __$WalkDailyCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime date, int? goal, int? actual});
}

/// @nodoc
class __$WalkDailyCopyWithImpl<$Res> implements _$WalkDailyCopyWith<$Res> {
  __$WalkDailyCopyWithImpl(this._self, this._then);

  final _WalkDaily _self;
  final $Res Function(_WalkDaily) _then;

  /// Create a copy of WalkDaily
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? goal = freezed,
    Object? actual = freezed,
  }) {
    return _then(_WalkDaily(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      goal: freezed == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as int?,
      actual: freezed == actual
          ? _self.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
