// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_unlock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumUnlock {
  int get unlockId;
  int get albumId;
  String? get albumTitle;
  DateTime get unlockedAt;
  String? get message;

  /// Create a copy of AlbumUnlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AlbumUnlockCopyWith<AlbumUnlock> get copyWith =>
      _$AlbumUnlockCopyWithImpl<AlbumUnlock>(this as AlbumUnlock, _$identity);

  /// Serializes this AlbumUnlock to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AlbumUnlock &&
            (identical(other.unlockId, unlockId) ||
                other.unlockId == unlockId) &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.albumTitle, albumTitle) ||
                other.albumTitle == albumTitle) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, unlockId, albumId, albumTitle, unlockedAt, message);

  @override
  String toString() {
    return 'AlbumUnlock(unlockId: $unlockId, albumId: $albumId, albumTitle: $albumTitle, unlockedAt: $unlockedAt, message: $message)';
  }
}

/// @nodoc
abstract mixin class $AlbumUnlockCopyWith<$Res> {
  factory $AlbumUnlockCopyWith(
          AlbumUnlock value, $Res Function(AlbumUnlock) _then) =
      _$AlbumUnlockCopyWithImpl;
  @useResult
  $Res call(
      {int unlockId,
      int albumId,
      String? albumTitle,
      DateTime unlockedAt,
      String? message});
}

/// @nodoc
class _$AlbumUnlockCopyWithImpl<$Res> implements $AlbumUnlockCopyWith<$Res> {
  _$AlbumUnlockCopyWithImpl(this._self, this._then);

  final AlbumUnlock _self;
  final $Res Function(AlbumUnlock) _then;

  /// Create a copy of AlbumUnlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unlockId = null,
    Object? albumId = null,
    Object? albumTitle = freezed,
    Object? unlockedAt = null,
    Object? message = freezed,
  }) {
    return _then(_self.copyWith(
      unlockId: null == unlockId
          ? _self.unlockId
          : unlockId // ignore: cast_nullable_to_non_nullable
              as int,
      albumId: null == albumId
          ? _self.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as int,
      albumTitle: freezed == albumTitle
          ? _self.albumTitle
          : albumTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      unlockedAt: null == unlockedAt
          ? _self.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AlbumUnlock].
extension AlbumUnlockPatterns on AlbumUnlock {
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
    TResult Function(_AlbumUnlock value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumUnlock() when $default != null:
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
    TResult Function(_AlbumUnlock value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumUnlock():
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
    TResult? Function(_AlbumUnlock value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumUnlock() when $default != null:
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
    TResult Function(int unlockId, int albumId, String? albumTitle,
            DateTime unlockedAt, String? message)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumUnlock() when $default != null:
        return $default(_that.unlockId, _that.albumId, _that.albumTitle,
            _that.unlockedAt, _that.message);
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
    TResult Function(int unlockId, int albumId, String? albumTitle,
            DateTime unlockedAt, String? message)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumUnlock():
        return $default(_that.unlockId, _that.albumId, _that.albumTitle,
            _that.unlockedAt, _that.message);
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
    TResult? Function(int unlockId, int albumId, String? albumTitle,
            DateTime unlockedAt, String? message)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumUnlock() when $default != null:
        return $default(_that.unlockId, _that.albumId, _that.albumTitle,
            _that.unlockedAt, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AlbumUnlock implements AlbumUnlock {
  const _AlbumUnlock(
      {required this.unlockId,
      required this.albumId,
      this.albumTitle,
      required this.unlockedAt,
      this.message});
  factory _AlbumUnlock.fromJson(Map<String, dynamic> json) =>
      _$AlbumUnlockFromJson(json);

  @override
  final int unlockId;
  @override
  final int albumId;
  @override
  final String? albumTitle;
  @override
  final DateTime unlockedAt;
  @override
  final String? message;

  /// Create a copy of AlbumUnlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AlbumUnlockCopyWith<_AlbumUnlock> get copyWith =>
      __$AlbumUnlockCopyWithImpl<_AlbumUnlock>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AlbumUnlockToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AlbumUnlock &&
            (identical(other.unlockId, unlockId) ||
                other.unlockId == unlockId) &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.albumTitle, albumTitle) ||
                other.albumTitle == albumTitle) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, unlockId, albumId, albumTitle, unlockedAt, message);

  @override
  String toString() {
    return 'AlbumUnlock(unlockId: $unlockId, albumId: $albumId, albumTitle: $albumTitle, unlockedAt: $unlockedAt, message: $message)';
  }
}

/// @nodoc
abstract mixin class _$AlbumUnlockCopyWith<$Res>
    implements $AlbumUnlockCopyWith<$Res> {
  factory _$AlbumUnlockCopyWith(
          _AlbumUnlock value, $Res Function(_AlbumUnlock) _then) =
      __$AlbumUnlockCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int unlockId,
      int albumId,
      String? albumTitle,
      DateTime unlockedAt,
      String? message});
}

/// @nodoc
class __$AlbumUnlockCopyWithImpl<$Res> implements _$AlbumUnlockCopyWith<$Res> {
  __$AlbumUnlockCopyWithImpl(this._self, this._then);

  final _AlbumUnlock _self;
  final $Res Function(_AlbumUnlock) _then;

  /// Create a copy of AlbumUnlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? unlockId = null,
    Object? albumId = null,
    Object? albumTitle = freezed,
    Object? unlockedAt = null,
    Object? message = freezed,
  }) {
    return _then(_AlbumUnlock(
      unlockId: null == unlockId
          ? _self.unlockId
          : unlockId // ignore: cast_nullable_to_non_nullable
              as int,
      albumId: null == albumId
          ? _self.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as int,
      albumTitle: freezed == albumTitle
          ? _self.albumTitle
          : albumTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      unlockedAt: null == unlockedAt
          ? _self.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
