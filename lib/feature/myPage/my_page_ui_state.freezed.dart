// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_page_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyPageUiState {
  bool get isLoading;
  String? get profileImage;
  String? get name;

  /// Create a copy of MyPageUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyPageUiStateCopyWith<MyPageUiState> get copyWith =>
      _$MyPageUiStateCopyWithImpl<MyPageUiState>(
          this as MyPageUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyPageUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, profileImage, name);

  @override
  String toString() {
    return 'MyPageUiState(isLoading: $isLoading, profileImage: $profileImage, name: $name)';
  }
}

/// @nodoc
abstract mixin class $MyPageUiStateCopyWith<$Res> {
  factory $MyPageUiStateCopyWith(
          MyPageUiState value, $Res Function(MyPageUiState) _then) =
      _$MyPageUiStateCopyWithImpl;
  @useResult
  $Res call({bool isLoading, String? profileImage, String? name});
}

/// @nodoc
class _$MyPageUiStateCopyWithImpl<$Res>
    implements $MyPageUiStateCopyWith<$Res> {
  _$MyPageUiStateCopyWithImpl(this._self, this._then);

  final MyPageUiState _self;
  final $Res Function(MyPageUiState) _then;

  /// Create a copy of MyPageUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? profileImage = freezed,
    Object? name = freezed,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MyPageUiState].
extension MyPageUiStatePatterns on MyPageUiState {
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
    TResult Function(_MyPageUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageUiState() when $default != null:
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
    TResult Function(_MyPageUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageUiState():
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
    TResult? Function(_MyPageUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageUiState() when $default != null:
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
    TResult Function(bool isLoading, String? profileImage, String? name)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyPageUiState() when $default != null:
        return $default(_that.isLoading, _that.profileImage, _that.name);
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
    TResult Function(bool isLoading, String? profileImage, String? name)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageUiState():
        return $default(_that.isLoading, _that.profileImage, _that.name);
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
    TResult? Function(bool isLoading, String? profileImage, String? name)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyPageUiState() when $default != null:
        return $default(_that.isLoading, _that.profileImage, _that.name);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MyPageUiState implements MyPageUiState {
  const _MyPageUiState(
      {this.isLoading = false, this.profileImage = null, this.name = null});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? profileImage;
  @override
  @JsonKey()
  final String? name;

  /// Create a copy of MyPageUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MyPageUiStateCopyWith<_MyPageUiState> get copyWith =>
      __$MyPageUiStateCopyWithImpl<_MyPageUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MyPageUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, profileImage, name);

  @override
  String toString() {
    return 'MyPageUiState(isLoading: $isLoading, profileImage: $profileImage, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$MyPageUiStateCopyWith<$Res>
    implements $MyPageUiStateCopyWith<$Res> {
  factory _$MyPageUiStateCopyWith(
          _MyPageUiState value, $Res Function(_MyPageUiState) _then) =
      __$MyPageUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isLoading, String? profileImage, String? name});
}

/// @nodoc
class __$MyPageUiStateCopyWithImpl<$Res>
    implements _$MyPageUiStateCopyWith<$Res> {
  __$MyPageUiStateCopyWithImpl(this._self, this._then);

  final _MyPageUiState _self;
  final $Res Function(_MyPageUiState) _then;

  /// Create a copy of MyPageUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? profileImage = freezed,
    Object? name = freezed,
  }) {
    return _then(_MyPageUiState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
