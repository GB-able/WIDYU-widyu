// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileUiState {
  bool get isLoading;
  String get name;
  String? get profileImage;
  String get phoneNumber;
  String get address;
  String get detailAddress;
  String get inviteCode;

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileUiStateCopyWith<ProfileUiState> get copyWith =>
      _$ProfileUiStateCopyWithImpl<ProfileUiState>(
          this as ProfileUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.detailAddress, detailAddress) ||
                other.detailAddress == detailAddress) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, name, profileImage,
      phoneNumber, address, detailAddress, inviteCode);

  @override
  String toString() {
    return 'ProfileUiState(isLoading: $isLoading, name: $name, profileImage: $profileImage, phoneNumber: $phoneNumber, address: $address, detailAddress: $detailAddress, inviteCode: $inviteCode)';
  }
}

/// @nodoc
abstract mixin class $ProfileUiStateCopyWith<$Res> {
  factory $ProfileUiStateCopyWith(
          ProfileUiState value, $Res Function(ProfileUiState) _then) =
      _$ProfileUiStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      String name,
      String? profileImage,
      String phoneNumber,
      String address,
      String detailAddress,
      String inviteCode});
}

/// @nodoc
class _$ProfileUiStateCopyWithImpl<$Res>
    implements $ProfileUiStateCopyWith<$Res> {
  _$ProfileUiStateCopyWithImpl(this._self, this._then);

  final ProfileUiState _self;
  final $Res Function(ProfileUiState) _then;

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? name = null,
    Object? profileImage = freezed,
    Object? phoneNumber = null,
    Object? address = null,
    Object? detailAddress = null,
    Object? inviteCode = null,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      detailAddress: null == detailAddress
          ? _self.detailAddress
          : detailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfileUiState].
extension ProfileUiStatePatterns on ProfileUiState {
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
    TResult Function(_ProfileUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileUiState() when $default != null:
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
    TResult Function(_ProfileUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileUiState():
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
    TResult? Function(_ProfileUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileUiState() when $default != null:
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
            bool isLoading,
            String name,
            String? profileImage,
            String phoneNumber,
            String address,
            String detailAddress,
            String inviteCode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileUiState() when $default != null:
        return $default(
            _that.isLoading,
            _that.name,
            _that.profileImage,
            _that.phoneNumber,
            _that.address,
            _that.detailAddress,
            _that.inviteCode);
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
            bool isLoading,
            String name,
            String? profileImage,
            String phoneNumber,
            String address,
            String detailAddress,
            String inviteCode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileUiState():
        return $default(
            _that.isLoading,
            _that.name,
            _that.profileImage,
            _that.phoneNumber,
            _that.address,
            _that.detailAddress,
            _that.inviteCode);
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
            bool isLoading,
            String name,
            String? profileImage,
            String phoneNumber,
            String address,
            String detailAddress,
            String inviteCode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileUiState() when $default != null:
        return $default(
            _that.isLoading,
            _that.name,
            _that.profileImage,
            _that.phoneNumber,
            _that.address,
            _that.detailAddress,
            _that.inviteCode);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ProfileUiState implements ProfileUiState {
  const _ProfileUiState(
      {this.isLoading = false,
      this.name = '',
      this.profileImage = null,
      this.phoneNumber = '',
      this.address = '',
      this.detailAddress = '',
      this.inviteCode = ''});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String? profileImage;
  @override
  @JsonKey()
  final String phoneNumber;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String detailAddress;
  @override
  @JsonKey()
  final String inviteCode;

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileUiStateCopyWith<_ProfileUiState> get copyWith =>
      __$ProfileUiStateCopyWithImpl<_ProfileUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfileUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.detailAddress, detailAddress) ||
                other.detailAddress == detailAddress) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, name, profileImage,
      phoneNumber, address, detailAddress, inviteCode);

  @override
  String toString() {
    return 'ProfileUiState(isLoading: $isLoading, name: $name, profileImage: $profileImage, phoneNumber: $phoneNumber, address: $address, detailAddress: $detailAddress, inviteCode: $inviteCode)';
  }
}

/// @nodoc
abstract mixin class _$ProfileUiStateCopyWith<$Res>
    implements $ProfileUiStateCopyWith<$Res> {
  factory _$ProfileUiStateCopyWith(
          _ProfileUiState value, $Res Function(_ProfileUiState) _then) =
      __$ProfileUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String name,
      String? profileImage,
      String phoneNumber,
      String address,
      String detailAddress,
      String inviteCode});
}

/// @nodoc
class __$ProfileUiStateCopyWithImpl<$Res>
    implements _$ProfileUiStateCopyWith<$Res> {
  __$ProfileUiStateCopyWithImpl(this._self, this._then);

  final _ProfileUiState _self;
  final $Res Function(_ProfileUiState) _then;

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? name = null,
    Object? profileImage = freezed,
    Object? phoneNumber = null,
    Object? address = null,
    Object? detailAddress = null,
    Object? inviteCode = null,
  }) {
    return _then(_ProfileUiState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      detailAddress: null == detailAddress
          ? _self.detailAddress
          : detailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
