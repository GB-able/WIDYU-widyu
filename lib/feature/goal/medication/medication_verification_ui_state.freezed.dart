// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_verification_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationVerificationUiState {
  bool get isReady;
  bool get isBusy;
  bool get isPermissionDenied;
  File? get photo;

  /// Create a copy of MedicationVerificationUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationVerificationUiStateCopyWith<MedicationVerificationUiState>
      get copyWith => _$MedicationVerificationUiStateCopyWithImpl<
              MedicationVerificationUiState>(
          this as MedicationVerificationUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationVerificationUiState &&
            (identical(other.isReady, isReady) || other.isReady == isReady) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.isPermissionDenied, isPermissionDenied) ||
                other.isPermissionDenied == isPermissionDenied) &&
            (identical(other.photo, photo) || other.photo == photo));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isReady, isBusy, isPermissionDenied, photo);

  @override
  String toString() {
    return 'MedicationVerificationUiState(isReady: $isReady, isBusy: $isBusy, isPermissionDenied: $isPermissionDenied, photo: $photo)';
  }
}

/// @nodoc
abstract mixin class $MedicationVerificationUiStateCopyWith<$Res> {
  factory $MedicationVerificationUiStateCopyWith(
          MedicationVerificationUiState value,
          $Res Function(MedicationVerificationUiState) _then) =
      _$MedicationVerificationUiStateCopyWithImpl;
  @useResult
  $Res call({bool isReady, bool isBusy, bool isPermissionDenied, File? photo});
}

/// @nodoc
class _$MedicationVerificationUiStateCopyWithImpl<$Res>
    implements $MedicationVerificationUiStateCopyWith<$Res> {
  _$MedicationVerificationUiStateCopyWithImpl(this._self, this._then);

  final MedicationVerificationUiState _self;
  final $Res Function(MedicationVerificationUiState) _then;

  /// Create a copy of MedicationVerificationUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isReady = null,
    Object? isBusy = null,
    Object? isPermissionDenied = null,
    Object? photo = freezed,
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
      photo: freezed == photo
          ? _self.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicationVerificationUiState].
extension MedicationVerificationUiStatePatterns
    on MedicationVerificationUiState {
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
    TResult Function(_MedicationVerificationUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationVerificationUiState() when $default != null:
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
    TResult Function(_MedicationVerificationUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationVerificationUiState():
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
    TResult? Function(_MedicationVerificationUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationVerificationUiState() when $default != null:
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
            bool isReady, bool isBusy, bool isPermissionDenied, File? photo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationVerificationUiState() when $default != null:
        return $default(
            _that.isReady, _that.isBusy, _that.isPermissionDenied, _that.photo);
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
            bool isReady, bool isBusy, bool isPermissionDenied, File? photo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationVerificationUiState():
        return $default(
            _that.isReady, _that.isBusy, _that.isPermissionDenied, _that.photo);
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
            bool isReady, bool isBusy, bool isPermissionDenied, File? photo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationVerificationUiState() when $default != null:
        return $default(
            _that.isReady, _that.isBusy, _that.isPermissionDenied, _that.photo);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MedicationVerificationUiState implements MedicationVerificationUiState {
  const _MedicationVerificationUiState(
      {this.isReady = false,
      this.isBusy = false,
      this.isPermissionDenied = false,
      this.photo});

  @override
  @JsonKey()
  final bool isReady;
  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final bool isPermissionDenied;
  @override
  final File? photo;

  /// Create a copy of MedicationVerificationUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationVerificationUiStateCopyWith<_MedicationVerificationUiState>
      get copyWith => __$MedicationVerificationUiStateCopyWithImpl<
          _MedicationVerificationUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationVerificationUiState &&
            (identical(other.isReady, isReady) || other.isReady == isReady) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.isPermissionDenied, isPermissionDenied) ||
                other.isPermissionDenied == isPermissionDenied) &&
            (identical(other.photo, photo) || other.photo == photo));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isReady, isBusy, isPermissionDenied, photo);

  @override
  String toString() {
    return 'MedicationVerificationUiState(isReady: $isReady, isBusy: $isBusy, isPermissionDenied: $isPermissionDenied, photo: $photo)';
  }
}

/// @nodoc
abstract mixin class _$MedicationVerificationUiStateCopyWith<$Res>
    implements $MedicationVerificationUiStateCopyWith<$Res> {
  factory _$MedicationVerificationUiStateCopyWith(
          _MedicationVerificationUiState value,
          $Res Function(_MedicationVerificationUiState) _then) =
      __$MedicationVerificationUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isReady, bool isBusy, bool isPermissionDenied, File? photo});
}

/// @nodoc
class __$MedicationVerificationUiStateCopyWithImpl<$Res>
    implements _$MedicationVerificationUiStateCopyWith<$Res> {
  __$MedicationVerificationUiStateCopyWithImpl(this._self, this._then);

  final _MedicationVerificationUiState _self;
  final $Res Function(_MedicationVerificationUiState) _then;

  /// Create a copy of MedicationVerificationUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isReady = null,
    Object? isBusy = null,
    Object? isPermissionDenied = null,
    Object? photo = freezed,
  }) {
    return _then(_MedicationVerificationUiState(
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
      photo: freezed == photo
          ? _self.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

// dart format on
