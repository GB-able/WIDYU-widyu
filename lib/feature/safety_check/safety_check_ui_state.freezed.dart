// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'safety_check_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SafetyCheckUiState {
  SafetyCheckPhase get phase;
  bool get isSubmitting;

  /// Create a copy of SafetyCheckUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SafetyCheckUiStateCopyWith<SafetyCheckUiState> get copyWith =>
      _$SafetyCheckUiStateCopyWithImpl<SafetyCheckUiState>(
          this as SafetyCheckUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SafetyCheckUiState &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phase, isSubmitting);

  @override
  String toString() {
    return 'SafetyCheckUiState(phase: $phase, isSubmitting: $isSubmitting)';
  }
}

/// @nodoc
abstract mixin class $SafetyCheckUiStateCopyWith<$Res> {
  factory $SafetyCheckUiStateCopyWith(
          SafetyCheckUiState value, $Res Function(SafetyCheckUiState) _then) =
      _$SafetyCheckUiStateCopyWithImpl;
  @useResult
  $Res call({SafetyCheckPhase phase, bool isSubmitting});
}

/// @nodoc
class _$SafetyCheckUiStateCopyWithImpl<$Res>
    implements $SafetyCheckUiStateCopyWith<$Res> {
  _$SafetyCheckUiStateCopyWithImpl(this._self, this._then);

  final SafetyCheckUiState _self;
  final $Res Function(SafetyCheckUiState) _then;

  /// Create a copy of SafetyCheckUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phase = null,
    Object? isSubmitting = null,
  }) {
    return _then(_self.copyWith(
      phase: null == phase
          ? _self.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as SafetyCheckPhase,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SafetyCheckUiState].
extension SafetyCheckUiStatePatterns on SafetyCheckUiState {
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
    TResult Function(_SafetyCheckUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SafetyCheckUiState() when $default != null:
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
    TResult Function(_SafetyCheckUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafetyCheckUiState():
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
    TResult? Function(_SafetyCheckUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafetyCheckUiState() when $default != null:
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
    TResult Function(SafetyCheckPhase phase, bool isSubmitting)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SafetyCheckUiState() when $default != null:
        return $default(_that.phase, _that.isSubmitting);
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
    TResult Function(SafetyCheckPhase phase, bool isSubmitting) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafetyCheckUiState():
        return $default(_that.phase, _that.isSubmitting);
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
    TResult? Function(SafetyCheckPhase phase, bool isSubmitting)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SafetyCheckUiState() when $default != null:
        return $default(_that.phase, _that.isSubmitting);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SafetyCheckUiState implements SafetyCheckUiState {
  const _SafetyCheckUiState(
      {this.phase = SafetyCheckPhase.confirm, this.isSubmitting = false});

  @override
  @JsonKey()
  final SafetyCheckPhase phase;
  @override
  @JsonKey()
  final bool isSubmitting;

  /// Create a copy of SafetyCheckUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SafetyCheckUiStateCopyWith<_SafetyCheckUiState> get copyWith =>
      __$SafetyCheckUiStateCopyWithImpl<_SafetyCheckUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SafetyCheckUiState &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phase, isSubmitting);

  @override
  String toString() {
    return 'SafetyCheckUiState(phase: $phase, isSubmitting: $isSubmitting)';
  }
}

/// @nodoc
abstract mixin class _$SafetyCheckUiStateCopyWith<$Res>
    implements $SafetyCheckUiStateCopyWith<$Res> {
  factory _$SafetyCheckUiStateCopyWith(
          _SafetyCheckUiState value, $Res Function(_SafetyCheckUiState) _then) =
      __$SafetyCheckUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({SafetyCheckPhase phase, bool isSubmitting});
}

/// @nodoc
class __$SafetyCheckUiStateCopyWithImpl<$Res>
    implements _$SafetyCheckUiStateCopyWith<$Res> {
  __$SafetyCheckUiStateCopyWithImpl(this._self, this._then);

  final _SafetyCheckUiState _self;
  final $Res Function(_SafetyCheckUiState) _then;

  /// Create a copy of SafetyCheckUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? phase = null,
    Object? isSubmitting = null,
  }) {
    return _then(_SafetyCheckUiState(
      phase: null == phase
          ? _self.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as SafetyCheckPhase,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
