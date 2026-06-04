// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyMember {
  int get memberId;
  String get name;
  String get phoneNumber;
  bool get isRepresentative;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FamilyMemberCopyWith<FamilyMember> get copyWith =>
      _$FamilyMemberCopyWithImpl<FamilyMember>(
          this as FamilyMember, _$identity);

  /// Serializes this FamilyMember to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FamilyMember &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.isRepresentative, isRepresentative) ||
                other.isRepresentative == isRepresentative));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, memberId, name, phoneNumber, isRepresentative);

  @override
  String toString() {
    return 'FamilyMember(memberId: $memberId, name: $name, phoneNumber: $phoneNumber, isRepresentative: $isRepresentative)';
  }
}

/// @nodoc
abstract mixin class $FamilyMemberCopyWith<$Res> {
  factory $FamilyMemberCopyWith(
          FamilyMember value, $Res Function(FamilyMember) _then) =
      _$FamilyMemberCopyWithImpl;
  @useResult
  $Res call(
      {int memberId, String name, String phoneNumber, bool isRepresentative});
}

/// @nodoc
class _$FamilyMemberCopyWithImpl<$Res> implements $FamilyMemberCopyWith<$Res> {
  _$FamilyMemberCopyWithImpl(this._self, this._then);

  final FamilyMember _self;
  final $Res Function(FamilyMember) _then;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? isRepresentative = null,
  }) {
    return _then(_self.copyWith(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isRepresentative: null == isRepresentative
          ? _self.isRepresentative
          : isRepresentative // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [FamilyMember].
extension FamilyMemberPatterns on FamilyMember {
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
    TResult Function(_FamilyMember value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FamilyMember() when $default != null:
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
    TResult Function(_FamilyMember value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FamilyMember():
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
    TResult? Function(_FamilyMember value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FamilyMember() when $default != null:
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
    TResult Function(int memberId, String name, String phoneNumber,
            bool isRepresentative)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FamilyMember() when $default != null:
        return $default(_that.memberId, _that.name, _that.phoneNumber,
            _that.isRepresentative);
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
    TResult Function(int memberId, String name, String phoneNumber,
            bool isRepresentative)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FamilyMember():
        return $default(_that.memberId, _that.name, _that.phoneNumber,
            _that.isRepresentative);
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
    TResult? Function(int memberId, String name, String phoneNumber,
            bool isRepresentative)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FamilyMember() when $default != null:
        return $default(_that.memberId, _that.name, _that.phoneNumber,
            _that.isRepresentative);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FamilyMember implements FamilyMember {
  const _FamilyMember(
      {required this.memberId,
      required this.name,
      required this.phoneNumber,
      required this.isRepresentative});
  factory _FamilyMember.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberFromJson(json);

  @override
  final int memberId;
  @override
  final String name;
  @override
  final String phoneNumber;
  @override
  final bool isRepresentative;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FamilyMemberCopyWith<_FamilyMember> get copyWith =>
      __$FamilyMemberCopyWithImpl<_FamilyMember>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FamilyMemberToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FamilyMember &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.isRepresentative, isRepresentative) ||
                other.isRepresentative == isRepresentative));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, memberId, name, phoneNumber, isRepresentative);

  @override
  String toString() {
    return 'FamilyMember(memberId: $memberId, name: $name, phoneNumber: $phoneNumber, isRepresentative: $isRepresentative)';
  }
}

/// @nodoc
abstract mixin class _$FamilyMemberCopyWith<$Res>
    implements $FamilyMemberCopyWith<$Res> {
  factory _$FamilyMemberCopyWith(
          _FamilyMember value, $Res Function(_FamilyMember) _then) =
      __$FamilyMemberCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int memberId, String name, String phoneNumber, bool isRepresentative});
}

/// @nodoc
class __$FamilyMemberCopyWithImpl<$Res>
    implements _$FamilyMemberCopyWith<$Res> {
  __$FamilyMemberCopyWithImpl(this._self, this._then);

  final _FamilyMember _self;
  final $Res Function(_FamilyMember) _then;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? memberId = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? isRepresentative = null,
  }) {
    return _then(_FamilyMember(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isRepresentative: null == isRepresentative
          ? _self.isRepresentative
          : isRepresentative // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
