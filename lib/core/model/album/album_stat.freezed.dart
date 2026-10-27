// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumStat {
  bool get isLiked;
  int get likeCount;
  int get commentCount;

  /// Create a copy of AlbumStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AlbumStatCopyWith<AlbumStat> get copyWith =>
      _$AlbumStatCopyWithImpl<AlbumStat>(this as AlbumStat, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AlbumStat &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLiked, likeCount, commentCount);

  @override
  String toString() {
    return 'AlbumStat(isLiked: $isLiked, likeCount: $likeCount, commentCount: $commentCount)';
  }
}

/// @nodoc
abstract mixin class $AlbumStatCopyWith<$Res> {
  factory $AlbumStatCopyWith(AlbumStat value, $Res Function(AlbumStat) _then) =
      _$AlbumStatCopyWithImpl;
  @useResult
  $Res call({bool isLiked, int likeCount, int commentCount});
}

/// @nodoc
class _$AlbumStatCopyWithImpl<$Res> implements $AlbumStatCopyWith<$Res> {
  _$AlbumStatCopyWithImpl(this._self, this._then);

  final AlbumStat _self;
  final $Res Function(AlbumStat) _then;

  /// Create a copy of AlbumStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLiked = null,
    Object? likeCount = null,
    Object? commentCount = null,
  }) {
    return _then(_self.copyWith(
      isLiked: null == isLiked
          ? _self.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AlbumStat].
extension AlbumStatPatterns on AlbumStat {
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
    TResult Function(_AlbumStat value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumStat() when $default != null:
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
    TResult Function(_AlbumStat value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumStat():
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
    TResult? Function(_AlbumStat value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumStat() when $default != null:
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
    TResult Function(bool isLiked, int likeCount, int commentCount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumStat() when $default != null:
        return $default(_that.isLiked, _that.likeCount, _that.commentCount);
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
    TResult Function(bool isLiked, int likeCount, int commentCount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumStat():
        return $default(_that.isLiked, _that.likeCount, _that.commentCount);
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
    TResult? Function(bool isLiked, int likeCount, int commentCount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumStat() when $default != null:
        return $default(_that.isLiked, _that.likeCount, _that.commentCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AlbumStat implements AlbumStat {
  const _AlbumStat(
      {required this.isLiked,
      required this.likeCount,
      required this.commentCount});

  @override
  final bool isLiked;
  @override
  final int likeCount;
  @override
  final int commentCount;

  /// Create a copy of AlbumStat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AlbumStatCopyWith<_AlbumStat> get copyWith =>
      __$AlbumStatCopyWithImpl<_AlbumStat>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AlbumStat &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLiked, likeCount, commentCount);

  @override
  String toString() {
    return 'AlbumStat(isLiked: $isLiked, likeCount: $likeCount, commentCount: $commentCount)';
  }
}

/// @nodoc
abstract mixin class _$AlbumStatCopyWith<$Res>
    implements $AlbumStatCopyWith<$Res> {
  factory _$AlbumStatCopyWith(
          _AlbumStat value, $Res Function(_AlbumStat) _then) =
      __$AlbumStatCopyWithImpl;
  @override
  @useResult
  $Res call({bool isLiked, int likeCount, int commentCount});
}

/// @nodoc
class __$AlbumStatCopyWithImpl<$Res> implements _$AlbumStatCopyWith<$Res> {
  __$AlbumStatCopyWithImpl(this._self, this._then);

  final _AlbumStat _self;
  final $Res Function(_AlbumStat) _then;

  /// Create a copy of AlbumStat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLiked = null,
    Object? likeCount = null,
    Object? commentCount = null,
  }) {
    return _then(_AlbumStat(
      isLiked: null == isLiked
          ? _self.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
