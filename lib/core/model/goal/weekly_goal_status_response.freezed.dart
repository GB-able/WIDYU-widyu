// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_goal_status_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyGoalStatusResponse {
  @JsonKey(name: 'thisWeekGoalRates')
  List<GoalRateStatus> get statuses;

  /// Create a copy of WeeklyGoalStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeeklyGoalStatusResponseCopyWith<WeeklyGoalStatusResponse> get copyWith =>
      _$WeeklyGoalStatusResponseCopyWithImpl<WeeklyGoalStatusResponse>(
          this as WeeklyGoalStatusResponse, _$identity);

  /// Serializes this WeeklyGoalStatusResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeeklyGoalStatusResponse &&
            const DeepCollectionEquality().equals(other.statuses, statuses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(statuses));

  @override
  String toString() {
    return 'WeeklyGoalStatusResponse(statuses: $statuses)';
  }
}

/// @nodoc
abstract mixin class $WeeklyGoalStatusResponseCopyWith<$Res> {
  factory $WeeklyGoalStatusResponseCopyWith(WeeklyGoalStatusResponse value,
          $Res Function(WeeklyGoalStatusResponse) _then) =
      _$WeeklyGoalStatusResponseCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'thisWeekGoalRates') List<GoalRateStatus> statuses});
}

/// @nodoc
class _$WeeklyGoalStatusResponseCopyWithImpl<$Res>
    implements $WeeklyGoalStatusResponseCopyWith<$Res> {
  _$WeeklyGoalStatusResponseCopyWithImpl(this._self, this._then);

  final WeeklyGoalStatusResponse _self;
  final $Res Function(WeeklyGoalStatusResponse) _then;

  /// Create a copy of WeeklyGoalStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statuses = null,
  }) {
    return _then(_self.copyWith(
      statuses: null == statuses
          ? _self.statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<GoalRateStatus>,
    ));
  }
}

/// Adds pattern-matching-related methods to [WeeklyGoalStatusResponse].
extension WeeklyGoalStatusResponsePatterns on WeeklyGoalStatusResponse {
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
    TResult Function(_WeeklyGoalStatusResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyGoalStatusResponse() when $default != null:
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
    TResult Function(_WeeklyGoalStatusResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyGoalStatusResponse():
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
    TResult? Function(_WeeklyGoalStatusResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyGoalStatusResponse() when $default != null:
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
            @JsonKey(name: 'thisWeekGoalRates') List<GoalRateStatus> statuses)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeeklyGoalStatusResponse() when $default != null:
        return $default(_that.statuses);
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
            @JsonKey(name: 'thisWeekGoalRates') List<GoalRateStatus> statuses)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyGoalStatusResponse():
        return $default(_that.statuses);
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
            @JsonKey(name: 'thisWeekGoalRates') List<GoalRateStatus> statuses)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeeklyGoalStatusResponse() when $default != null:
        return $default(_that.statuses);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WeeklyGoalStatusResponse implements WeeklyGoalStatusResponse {
  const _WeeklyGoalStatusResponse(
      {@JsonKey(name: 'thisWeekGoalRates')
      final List<GoalRateStatus> statuses = const []})
      : _statuses = statuses;
  factory _WeeklyGoalStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$WeeklyGoalStatusResponseFromJson(json);

  final List<GoalRateStatus> _statuses;
  @override
  @JsonKey(name: 'thisWeekGoalRates')
  List<GoalRateStatus> get statuses {
    if (_statuses is EqualUnmodifiableListView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statuses);
  }

  /// Create a copy of WeeklyGoalStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WeeklyGoalStatusResponseCopyWith<_WeeklyGoalStatusResponse> get copyWith =>
      __$WeeklyGoalStatusResponseCopyWithImpl<_WeeklyGoalStatusResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WeeklyGoalStatusResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeeklyGoalStatusResponse &&
            const DeepCollectionEquality().equals(other._statuses, _statuses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_statuses));

  @override
  String toString() {
    return 'WeeklyGoalStatusResponse(statuses: $statuses)';
  }
}

/// @nodoc
abstract mixin class _$WeeklyGoalStatusResponseCopyWith<$Res>
    implements $WeeklyGoalStatusResponseCopyWith<$Res> {
  factory _$WeeklyGoalStatusResponseCopyWith(_WeeklyGoalStatusResponse value,
          $Res Function(_WeeklyGoalStatusResponse) _then) =
      __$WeeklyGoalStatusResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'thisWeekGoalRates') List<GoalRateStatus> statuses});
}

/// @nodoc
class __$WeeklyGoalStatusResponseCopyWithImpl<$Res>
    implements _$WeeklyGoalStatusResponseCopyWith<$Res> {
  __$WeeklyGoalStatusResponseCopyWithImpl(this._self, this._then);

  final _WeeklyGoalStatusResponse _self;
  final $Res Function(_WeeklyGoalStatusResponse) _then;

  /// Create a copy of WeeklyGoalStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? statuses = null,
  }) {
    return _then(_WeeklyGoalStatusResponse(
      statuses: null == statuses
          ? _self._statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<GoalRateStatus>,
    ));
  }
}

// dart format on
