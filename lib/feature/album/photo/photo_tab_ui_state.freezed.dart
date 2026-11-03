// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_tab_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhotoTabUiState {
// 삭제된 게시물의 미디어는 뺀다.
  InfiniteScrollState<Media> get list;
  AlbumCache get cache;

  /// Create a copy of PhotoTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PhotoTabUiStateCopyWith<PhotoTabUiState> get copyWith =>
      _$PhotoTabUiStateCopyWithImpl<PhotoTabUiState>(
          this as PhotoTabUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PhotoTabUiState &&
            (identical(other.list, list) || other.list == list) &&
            (identical(other.cache, cache) || other.cache == cache));
  }

  @override
  int get hashCode => Object.hash(runtimeType, list, cache);

  @override
  String toString() {
    return 'PhotoTabUiState(list: $list, cache: $cache)';
  }
}

/// @nodoc
abstract mixin class $PhotoTabUiStateCopyWith<$Res> {
  factory $PhotoTabUiStateCopyWith(
          PhotoTabUiState value, $Res Function(PhotoTabUiState) _then) =
      _$PhotoTabUiStateCopyWithImpl;
  @useResult
  $Res call({InfiniteScrollState<Media> list, AlbumCache cache});

  $InfiniteScrollStateCopyWith<Media, $Res> get list;
}

/// @nodoc
class _$PhotoTabUiStateCopyWithImpl<$Res>
    implements $PhotoTabUiStateCopyWith<$Res> {
  _$PhotoTabUiStateCopyWithImpl(this._self, this._then);

  final PhotoTabUiState _self;
  final $Res Function(PhotoTabUiState) _then;

  /// Create a copy of PhotoTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? cache = null,
  }) {
    return _then(_self.copyWith(
      list: null == list
          ? _self.list
          : list // ignore: cast_nullable_to_non_nullable
              as InfiniteScrollState<Media>,
      cache: null == cache
          ? _self.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as AlbumCache,
    ));
  }

  /// Create a copy of PhotoTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InfiniteScrollStateCopyWith<Media, $Res> get list {
    return $InfiniteScrollStateCopyWith<Media, $Res>(_self.list, (value) {
      return _then(_self.copyWith(list: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PhotoTabUiState].
extension PhotoTabUiStatePatterns on PhotoTabUiState {
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
    TResult Function(_PhotoTabUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PhotoTabUiState() when $default != null:
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
    TResult Function(_PhotoTabUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PhotoTabUiState():
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
    TResult? Function(_PhotoTabUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PhotoTabUiState() when $default != null:
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
    TResult Function(InfiniteScrollState<Media> list, AlbumCache cache)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PhotoTabUiState() when $default != null:
        return $default(_that.list, _that.cache);
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
    TResult Function(InfiniteScrollState<Media> list, AlbumCache cache)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PhotoTabUiState():
        return $default(_that.list, _that.cache);
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
    TResult? Function(InfiniteScrollState<Media> list, AlbumCache cache)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PhotoTabUiState() when $default != null:
        return $default(_that.list, _that.cache);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PhotoTabUiState implements PhotoTabUiState {
  const _PhotoTabUiState(
      {this.list = const InfiniteScrollState<Media>(),
      this.cache = const AlbumCache()});

// 삭제된 게시물의 미디어는 뺀다.
  @override
  @JsonKey()
  final InfiniteScrollState<Media> list;
  @override
  @JsonKey()
  final AlbumCache cache;

  /// Create a copy of PhotoTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PhotoTabUiStateCopyWith<_PhotoTabUiState> get copyWith =>
      __$PhotoTabUiStateCopyWithImpl<_PhotoTabUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PhotoTabUiState &&
            (identical(other.list, list) || other.list == list) &&
            (identical(other.cache, cache) || other.cache == cache));
  }

  @override
  int get hashCode => Object.hash(runtimeType, list, cache);

  @override
  String toString() {
    return 'PhotoTabUiState(list: $list, cache: $cache)';
  }
}

/// @nodoc
abstract mixin class _$PhotoTabUiStateCopyWith<$Res>
    implements $PhotoTabUiStateCopyWith<$Res> {
  factory _$PhotoTabUiStateCopyWith(
          _PhotoTabUiState value, $Res Function(_PhotoTabUiState) _then) =
      __$PhotoTabUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({InfiniteScrollState<Media> list, AlbumCache cache});

  @override
  $InfiniteScrollStateCopyWith<Media, $Res> get list;
}

/// @nodoc
class __$PhotoTabUiStateCopyWithImpl<$Res>
    implements _$PhotoTabUiStateCopyWith<$Res> {
  __$PhotoTabUiStateCopyWithImpl(this._self, this._then);

  final _PhotoTabUiState _self;
  final $Res Function(_PhotoTabUiState) _then;

  /// Create a copy of PhotoTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? list = null,
    Object? cache = null,
  }) {
    return _then(_PhotoTabUiState(
      list: null == list
          ? _self.list
          : list // ignore: cast_nullable_to_non_nullable
              as InfiniteScrollState<Media>,
      cache: null == cache
          ? _self.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as AlbumCache,
    ));
  }

  /// Create a copy of PhotoTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InfiniteScrollStateCopyWith<Media, $Res> get list {
    return $InfiniteScrollStateCopyWith<Media, $Res>(_self.list, (value) {
      return _then(_self.copyWith(list: value));
    });
  }
}

// dart format on
