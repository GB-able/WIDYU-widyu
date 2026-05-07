// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'point_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PointUiState {
  bool get isLoading;
  int get currentPoints;
  List<PointUiModel> get histories;

  /// Create a copy of PointUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PointUiStateCopyWith<PointUiState> get copyWith =>
      _$PointUiStateCopyWithImpl<PointUiState>(
          this as PointUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PointUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints) &&
            const DeepCollectionEquality().equals(other.histories, histories));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, currentPoints,
      const DeepCollectionEquality().hash(histories));

  @override
  String toString() {
    return 'PointUiState(isLoading: $isLoading, currentPoints: $currentPoints, histories: $histories)';
  }
}

/// @nodoc
abstract mixin class $PointUiStateCopyWith<$Res> {
  factory $PointUiStateCopyWith(
          PointUiState value, $Res Function(PointUiState) _then) =
      _$PointUiStateCopyWithImpl;
  @useResult
  $Res call({bool isLoading, int currentPoints, List<PointUiModel> histories});
}

/// @nodoc
class _$PointUiStateCopyWithImpl<$Res> implements $PointUiStateCopyWith<$Res> {
  _$PointUiStateCopyWithImpl(this._self, this._then);

  final PointUiState _self;
  final $Res Function(PointUiState) _then;

  /// Create a copy of PointUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? currentPoints = null,
    Object? histories = null,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPoints: null == currentPoints
          ? _self.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      histories: null == histories
          ? _self.histories
          : histories // ignore: cast_nullable_to_non_nullable
              as List<PointUiModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [PointUiState].
extension PointUiStatePatterns on PointUiState {
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
    TResult Function(_PointUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PointUiState() when $default != null:
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
    TResult Function(_PointUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PointUiState():
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
    TResult? Function(_PointUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PointUiState() when $default != null:
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
            bool isLoading, int currentPoints, List<PointUiModel> histories)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PointUiState() when $default != null:
        return $default(_that.isLoading, _that.currentPoints, _that.histories);
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
            bool isLoading, int currentPoints, List<PointUiModel> histories)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PointUiState():
        return $default(_that.isLoading, _that.currentPoints, _that.histories);
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
            bool isLoading, int currentPoints, List<PointUiModel> histories)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PointUiState() when $default != null:
        return $default(_that.isLoading, _that.currentPoints, _that.histories);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PointUiState implements PointUiState {
  const _PointUiState(
      {this.isLoading = false,
      this.currentPoints = 0,
      final List<PointUiModel> histories = const []})
      : _histories = histories;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final int currentPoints;
  final List<PointUiModel> _histories;
  @override
  @JsonKey()
  List<PointUiModel> get histories {
    if (_histories is EqualUnmodifiableListView) return _histories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_histories);
  }

  /// Create a copy of PointUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PointUiStateCopyWith<_PointUiState> get copyWith =>
      __$PointUiStateCopyWithImpl<_PointUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PointUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.currentPoints, currentPoints) ||
                other.currentPoints == currentPoints) &&
            const DeepCollectionEquality()
                .equals(other._histories, _histories));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, currentPoints,
      const DeepCollectionEquality().hash(_histories));

  @override
  String toString() {
    return 'PointUiState(isLoading: $isLoading, currentPoints: $currentPoints, histories: $histories)';
  }
}

/// @nodoc
abstract mixin class _$PointUiStateCopyWith<$Res>
    implements $PointUiStateCopyWith<$Res> {
  factory _$PointUiStateCopyWith(
          _PointUiState value, $Res Function(_PointUiState) _then) =
      __$PointUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isLoading, int currentPoints, List<PointUiModel> histories});
}

/// @nodoc
class __$PointUiStateCopyWithImpl<$Res>
    implements _$PointUiStateCopyWith<$Res> {
  __$PointUiStateCopyWithImpl(this._self, this._then);

  final _PointUiState _self;
  final $Res Function(_PointUiState) _then;

  /// Create a copy of PointUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? currentPoints = null,
    Object? histories = null,
  }) {
    return _then(_PointUiState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPoints: null == currentPoints
          ? _self.currentPoints
          : currentPoints // ignore: cast_nullable_to_non_nullable
              as int,
      histories: null == histories
          ? _self._histories
          : histories // ignore: cast_nullable_to_non_nullable
              as List<PointUiModel>,
    ));
  }
}

// dart format on
