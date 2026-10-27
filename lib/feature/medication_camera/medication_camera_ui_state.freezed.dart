// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_camera_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationCameraUiState {
  bool get isReady;
  bool get isBusy;
  bool get isPermissionDenied;

  /// Create a copy of MedicationCameraUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationCameraUiStateCopyWith<MedicationCameraUiState> get copyWith =>
      _$MedicationCameraUiStateCopyWithImpl<MedicationCameraUiState>(
          this as MedicationCameraUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationCameraUiState &&
            (identical(other.isReady, isReady) || other.isReady == isReady) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.isPermissionDenied, isPermissionDenied) ||
                other.isPermissionDenied == isPermissionDenied));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isReady, isBusy, isPermissionDenied);

  @override
  String toString() {
    return 'MedicationCameraUiState(isReady: $isReady, isBusy: $isBusy, isPermissionDenied: $isPermissionDenied)';
  }
}

/// @nodoc
abstract mixin class $MedicationCameraUiStateCopyWith<$Res> {
  factory $MedicationCameraUiStateCopyWith(MedicationCameraUiState value,
          $Res Function(MedicationCameraUiState) _then) =
      _$MedicationCameraUiStateCopyWithImpl;
  @useResult
  $Res call({bool isReady, bool isBusy, bool isPermissionDenied});
}

/// @nodoc
class _$MedicationCameraUiStateCopyWithImpl<$Res>
    implements $MedicationCameraUiStateCopyWith<$Res> {
  _$MedicationCameraUiStateCopyWithImpl(this._self, this._then);

  final MedicationCameraUiState _self;
  final $Res Function(MedicationCameraUiState) _then;

  /// Create a copy of MedicationCameraUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isReady = null,
    Object? isBusy = null,
    Object? isPermissionDenied = null,
  }) {
    return _then(_self.copyWith(
      isReady: null == isReady
          ? _self.isReady
          : isReady // ignore: cast_nullable_to_non_nullable
              as bool,
      isBusy: null == isBusy
          ? _self.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isPermissionDenied: null == isPermissionDenied
          ? _self.isPermissionDenied
          : isPermissionDenied // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicationCameraUiState].
extension MedicationCameraUiStatePatterns on MedicationCameraUiState {
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
    TResult Function(_MedicationCameraUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationCameraUiState() when $default != null:
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
    TResult Function(_MedicationCameraUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationCameraUiState():
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
    TResult? Function(_MedicationCameraUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationCameraUiState() when $default != null:
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
    TResult Function(bool isReady, bool isBusy, bool isPermissionDenied)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationCameraUiState() when $default != null:
        return $default(_that.isReady, _that.isBusy, _that.isPermissionDenied);
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
    TResult Function(bool isReady, bool isBusy, bool isPermissionDenied)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationCameraUiState():
        return $default(_that.isReady, _that.isBusy, _that.isPermissionDenied);
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
    TResult? Function(bool isReady, bool isBusy, bool isPermissionDenied)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationCameraUiState() when $default != null:
        return $default(_that.isReady, _that.isBusy, _that.isPermissionDenied);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MedicationCameraUiState implements MedicationCameraUiState {
  const _MedicationCameraUiState(
      {this.isReady = false,
      this.isBusy = false,
      this.isPermissionDenied = false});

  @override
  @JsonKey()
  final bool isReady;
  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final bool isPermissionDenied;

  /// Create a copy of MedicationCameraUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationCameraUiStateCopyWith<_MedicationCameraUiState> get copyWith =>
      __$MedicationCameraUiStateCopyWithImpl<_MedicationCameraUiState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationCameraUiState &&
            (identical(other.isReady, isReady) || other.isReady == isReady) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.isPermissionDenied, isPermissionDenied) ||
                other.isPermissionDenied == isPermissionDenied));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isReady, isBusy, isPermissionDenied);

  @override
  String toString() {
    return 'MedicationCameraUiState(isReady: $isReady, isBusy: $isBusy, isPermissionDenied: $isPermissionDenied)';
  }
}

/// @nodoc
abstract mixin class _$MedicationCameraUiStateCopyWith<$Res>
    implements $MedicationCameraUiStateCopyWith<$Res> {
  factory _$MedicationCameraUiStateCopyWith(_MedicationCameraUiState value,
          $Res Function(_MedicationCameraUiState) _then) =
      __$MedicationCameraUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isReady, bool isBusy, bool isPermissionDenied});
}

/// @nodoc
class __$MedicationCameraUiStateCopyWithImpl<$Res>
    implements _$MedicationCameraUiStateCopyWith<$Res> {
  __$MedicationCameraUiStateCopyWithImpl(this._self, this._then);

  final _MedicationCameraUiState _self;
  final $Res Function(_MedicationCameraUiState) _then;

  /// Create a copy of MedicationCameraUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isReady = null,
    Object? isBusy = null,
    Object? isPermissionDenied = null,
  }) {
    return _then(_MedicationCameraUiState(
      isReady: null == isReady
          ? _self.isReady
          : isReady // ignore: cast_nullable_to_non_nullable
              as bool,
      isBusy: null == isBusy
          ? _self.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isPermissionDenied: null == isPermissionDenied
          ? _self.isPermissionDenied
          : isPermissionDenied // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
