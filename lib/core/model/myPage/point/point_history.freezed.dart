// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'point_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PointHistory {
  int get currentPoints;
  List<Point> get histories;

  /// Create a copy of PointHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PointHistoryCopyWith<PointHistory> get copyWith =>
      _$PointHistoryCopyWithImpl<PointHistory>(
          this as PointHistory, _$identity);

  /// Serializes this PointHistory to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PointHistory &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints) &&
            const DeepCollectionEquality().equals(other.histories, histories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPoints,
      const DeepCollectionEquality().hash(histories));

  @override
  String toString() {
    return 'PointHistory(currentPoints: $currentPoints, histories: $histories)';
  }
}

/// @nodoc
abstract mixin class $PointHistoryCopyWith<$Res> {
  factory $PointHistoryCopyWith(
          PointHistory value, $Res Function(PointHistory) _then) =
      _$PointHistoryCopyWithImpl;
  @useResult
  $Res call({int currentPoints, List<Point> histories});
}

/// @nodoc
class _$PointHistoryCopyWithImpl<$Res> implements $PointHistoryCopyWith<$Res> {
  _$PointHistoryCopyWithImpl(this._self, this._then);

  final PointHistory _self;
  final $Res Function(PointHistory) _then;

  /// Create a copy of PointHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPoints = null,
    Object? histories = null,
  }) {
    return _then(_self.copyWith(
      currentPoints: null == currentPoints
          ? _self.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      histories: null == histories
          ? _self.histories
          : histories // ignore: cast_nullable_to_non_nullable
              as List<Point>,
    ));
  }
}

/// Adds pattern-matching-related methods to [PointHistory].
extension PointHistoryPatterns on PointHistory {
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
    TResult Function(_PointHistory value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PointHistory() when $default != null:
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
    TResult Function(_PointHistory value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PointHistory():
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
    TResult? Function(_PointHistory value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PointHistory() when $default != null:
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
    TResult Function(int currentPoints, List<Point> histories)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PointHistory() when $default != null:
        return $default(_that.currentPoints, _that.histories);
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
    TResult Function(int currentPoints, List<Point> histories) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PointHistory():
        return $default(_that.currentPoints, _that.histories);
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
    TResult? Function(int currentPoints, List<Point> histories)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PointHistory() when $default != null:
        return $default(_that.currentPoints, _that.histories);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PointHistory implements PointHistory {
  const _PointHistory(
      {required this.currentPoints, required final List<Point> histories})
      : _histories = histories;
  factory _PointHistory.fromJson(Map<String, dynamic> json) =>
      _$PointHistoryFromJson(json);

  @override
  final int currentPoints;
  final List<Point> _histories;
  @override
  List<Point> get histories {
    if (_histories is EqualUnmodifiableListView) return _histories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_histories);
  }

  /// Create a copy of PointHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PointHistoryCopyWith<_PointHistory> get copyWith =>
      __$PointHistoryCopyWithImpl<_PointHistory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PointHistoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PointHistory &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints) &&
            const DeepCollectionEquality()
                .equals(other._histories, _histories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPoints,
      const DeepCollectionEquality().hash(_histories));

  @override
  String toString() {
    return 'PointHistory(currentPoints: $currentPoints, histories: $histories)';
  }
}

/// @nodoc
abstract mixin class _$PointHistoryCopyWith<$Res>
    implements $PointHistoryCopyWith<$Res> {
  factory _$PointHistoryCopyWith(
          _PointHistory value, $Res Function(_PointHistory) _then) =
      __$PointHistoryCopyWithImpl;
  @override
  @useResult
  $Res call({int currentPoints, List<Point> histories});
}

/// @nodoc
class __$PointHistoryCopyWithImpl<$Res>
    implements _$PointHistoryCopyWith<$Res> {
  __$PointHistoryCopyWithImpl(this._self, this._then);

  final _PointHistory _self;
  final $Res Function(_PointHistory) _then;

  /// Create a copy of PointHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentPoints = null,
    Object? histories = null,
  }) {
    return _then(_PointHistory(
      currentPoints: null == currentPoints
          ? _self.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      histories: null == histories
          ? _self._histories
          : histories // ignore: cast_nullable_to_non_nullable
              as List<Point>,
    ));
  }
}

// dart format on
