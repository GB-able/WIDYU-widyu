// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactUiState {
  bool get isLoading;
  Representative? get representative;
  List<FamilyMember> get familyMembers;

  /// Create a copy of ContactUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContactUiStateCopyWith<ContactUiState> get copyWith =>
      _$ContactUiStateCopyWithImpl<ContactUiState>(
          this as ContactUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContactUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.representative, representative) ||
                other.representative == representative) &&
            const DeepCollectionEquality()
                .equals(other.familyMembers, familyMembers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, representative,
      const DeepCollectionEquality().hash(familyMembers));

  @override
  String toString() {
    return 'ContactUiState(isLoading: $isLoading, representative: $representative, familyMembers: $familyMembers)';
  }
}

/// @nodoc
abstract mixin class $ContactUiStateCopyWith<$Res> {
  factory $ContactUiStateCopyWith(
          ContactUiState value, $Res Function(ContactUiState) _then) =
      _$ContactUiStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      Representative? representative,
      List<FamilyMember> familyMembers});

  $RepresentativeCopyWith<$Res>? get representative;
}

/// @nodoc
class _$ContactUiStateCopyWithImpl<$Res>
    implements $ContactUiStateCopyWith<$Res> {
  _$ContactUiStateCopyWithImpl(this._self, this._then);

  final ContactUiState _self;
  final $Res Function(ContactUiState) _then;

  /// Create a copy of ContactUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? representative = freezed,
    Object? familyMembers = null,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      representative: freezed == representative
          ? _self.representative
          : representative // ignore: cast_nullable_to_non_nullable
              as Representative?,
      familyMembers: null == familyMembers
          ? _self.familyMembers
          : familyMembers // ignore: cast_nullable_to_non_nullable
              as List<FamilyMember>,
    ));
  }

  /// Create a copy of ContactUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RepresentativeCopyWith<$Res>? get representative {
    if (_self.representative == null) {
      return null;
    }

    return $RepresentativeCopyWith<$Res>(_self.representative!, (value) {
      return _then(_self.copyWith(representative: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ContactUiState].
extension ContactUiStatePatterns on ContactUiState {
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
    TResult Function(_ContactUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ContactUiState() when $default != null:
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
    TResult Function(_ContactUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactUiState():
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
    TResult? Function(_ContactUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactUiState() when $default != null:
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
    TResult Function(bool isLoading, Representative? representative,
            List<FamilyMember> familyMembers)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ContactUiState() when $default != null:
        return $default(
            _that.isLoading, _that.representative, _that.familyMembers);
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
    TResult Function(bool isLoading, Representative? representative,
            List<FamilyMember> familyMembers)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactUiState():
        return $default(
            _that.isLoading, _that.representative, _that.familyMembers);
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
    TResult? Function(bool isLoading, Representative? representative,
            List<FamilyMember> familyMembers)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactUiState() when $default != null:
        return $default(
            _that.isLoading, _that.representative, _that.familyMembers);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ContactUiState implements ContactUiState {
  const _ContactUiState(
      {this.isLoading = false,
      this.representative = null,
      final List<FamilyMember> familyMembers = const []})
      : _familyMembers = familyMembers;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final Representative? representative;
  final List<FamilyMember> _familyMembers;
  @override
  @JsonKey()
  List<FamilyMember> get familyMembers {
    if (_familyMembers is EqualUnmodifiableListView) return _familyMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_familyMembers);
  }

  /// Create a copy of ContactUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ContactUiStateCopyWith<_ContactUiState> get copyWith =>
      __$ContactUiStateCopyWithImpl<_ContactUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ContactUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.representative, representative) ||
                other.representative == representative) &&
            const DeepCollectionEquality()
                .equals(other._familyMembers, _familyMembers));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, representative,
      const DeepCollectionEquality().hash(_familyMembers));

  @override
  String toString() {
    return 'ContactUiState(isLoading: $isLoading, representative: $representative, familyMembers: $familyMembers)';
  }
}

/// @nodoc
abstract mixin class _$ContactUiStateCopyWith<$Res>
    implements $ContactUiStateCopyWith<$Res> {
  factory _$ContactUiStateCopyWith(
          _ContactUiState value, $Res Function(_ContactUiState) _then) =
      __$ContactUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      Representative? representative,
      List<FamilyMember> familyMembers});

  @override
  $RepresentativeCopyWith<$Res>? get representative;
}

/// @nodoc
class __$ContactUiStateCopyWithImpl<$Res>
    implements _$ContactUiStateCopyWith<$Res> {
  __$ContactUiStateCopyWithImpl(this._self, this._then);

  final _ContactUiState _self;
  final $Res Function(_ContactUiState) _then;

  /// Create a copy of ContactUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? representative = freezed,
    Object? familyMembers = null,
  }) {
    return _then(_ContactUiState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      representative: freezed == representative
          ? _self.representative
          : representative // ignore: cast_nullable_to_non_nullable
              as Representative?,
      familyMembers: null == familyMembers
          ? _self._familyMembers
          : familyMembers // ignore: cast_nullable_to_non_nullable
              as List<FamilyMember>,
    ));
  }

  /// Create a copy of ContactUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RepresentativeCopyWith<$Res>? get representative {
    if (_self.representative == null) {
      return null;
    }

    return $RepresentativeCopyWith<$Res>(_self.representative!, (value) {
      return _then(_self.copyWith(representative: value));
    });
  }
}

// dart format on
