// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_tab_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedTabUiState {
// 캐시에 남아 있는(삭제되지 않은) 게시물 id만 담는다.
  InfiniteScrollState<int> get list;
  AlbumCache get cache;
  Set<int> get expandedFeedIds;

  /// Create a copy of FeedTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedTabUiStateCopyWith<FeedTabUiState> get copyWith =>
      _$FeedTabUiStateCopyWithImpl<FeedTabUiState>(
          this as FeedTabUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedTabUiState &&
            (identical(other.list, list) || other.list == list) &&
            (identical(other.cache, cache) || other.cache == cache) &&
            const DeepCollectionEquality()
                .equals(other.expandedFeedIds, expandedFeedIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, list, cache,
      const DeepCollectionEquality().hash(expandedFeedIds));

  @override
  String toString() {
    return 'FeedTabUiState(list: $list, cache: $cache, expandedFeedIds: $expandedFeedIds)';
  }
}

/// @nodoc
abstract mixin class $FeedTabUiStateCopyWith<$Res> {
  factory $FeedTabUiStateCopyWith(
          FeedTabUiState value, $Res Function(FeedTabUiState) _then) =
      _$FeedTabUiStateCopyWithImpl;
  @useResult
  $Res call(
      {InfiniteScrollState<int> list,
      AlbumCache cache,
      Set<int> expandedFeedIds});

  $InfiniteScrollStateCopyWith<int, $Res> get list;
}

/// @nodoc
class _$FeedTabUiStateCopyWithImpl<$Res>
    implements $FeedTabUiStateCopyWith<$Res> {
  _$FeedTabUiStateCopyWithImpl(this._self, this._then);

  final FeedTabUiState _self;
  final $Res Function(FeedTabUiState) _then;

  /// Create a copy of FeedTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? cache = null,
    Object? expandedFeedIds = null,
  }) {
    return _then(_self.copyWith(
      list: null == list
          ? _self.list
          : list // ignore: cast_nullable_to_non_nullable
              as InfiniteScrollState<int>,
      cache: null == cache
          ? _self.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as AlbumCache,
      expandedFeedIds: null == expandedFeedIds
          ? _self.expandedFeedIds
          : expandedFeedIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ));
  }

  /// Create a copy of FeedTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InfiniteScrollStateCopyWith<int, $Res> get list {
    return $InfiniteScrollStateCopyWith<int, $Res>(_self.list, (value) {
      return _then(_self.copyWith(list: value));
    });
  }
}

/// Adds pattern-matching-related methods to [FeedTabUiState].
extension FeedTabUiStatePatterns on FeedTabUiState {
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
    TResult Function(_FeedTabUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedTabUiState() when $default != null:
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
    TResult Function(_FeedTabUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedTabUiState():
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
    TResult? Function(_FeedTabUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedTabUiState() when $default != null:
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
    TResult Function(InfiniteScrollState<int> list, AlbumCache cache,
            Set<int> expandedFeedIds)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedTabUiState() when $default != null:
        return $default(_that.list, _that.cache, _that.expandedFeedIds);
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
    TResult Function(InfiniteScrollState<int> list, AlbumCache cache,
            Set<int> expandedFeedIds)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedTabUiState():
        return $default(_that.list, _that.cache, _that.expandedFeedIds);
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
    TResult? Function(InfiniteScrollState<int> list, AlbumCache cache,
            Set<int> expandedFeedIds)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedTabUiState() when $default != null:
        return $default(_that.list, _that.cache, _that.expandedFeedIds);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FeedTabUiState implements FeedTabUiState {
  const _FeedTabUiState(
      {this.list = const InfiniteScrollState<int>(),
      this.cache = const AlbumCache(),
      final Set<int> expandedFeedIds = const {}})
      : _expandedFeedIds = expandedFeedIds;

// 캐시에 남아 있는(삭제되지 않은) 게시물 id만 담는다.
  @override
  @JsonKey()
  final InfiniteScrollState<int> list;
  @override
  @JsonKey()
  final AlbumCache cache;
  final Set<int> _expandedFeedIds;
  @override
  @JsonKey()
  Set<int> get expandedFeedIds {
    if (_expandedFeedIds is EqualUnmodifiableSetView) return _expandedFeedIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_expandedFeedIds);
  }

  /// Create a copy of FeedTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedTabUiStateCopyWith<_FeedTabUiState> get copyWith =>
      __$FeedTabUiStateCopyWithImpl<_FeedTabUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedTabUiState &&
            (identical(other.list, list) || other.list == list) &&
            (identical(other.cache, cache) || other.cache == cache) &&
            const DeepCollectionEquality()
                .equals(other._expandedFeedIds, _expandedFeedIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, list, cache,
      const DeepCollectionEquality().hash(_expandedFeedIds));

  @override
  String toString() {
    return 'FeedTabUiState(list: $list, cache: $cache, expandedFeedIds: $expandedFeedIds)';
  }
}

/// @nodoc
abstract mixin class _$FeedTabUiStateCopyWith<$Res>
    implements $FeedTabUiStateCopyWith<$Res> {
  factory _$FeedTabUiStateCopyWith(
          _FeedTabUiState value, $Res Function(_FeedTabUiState) _then) =
      __$FeedTabUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {InfiniteScrollState<int> list,
      AlbumCache cache,
      Set<int> expandedFeedIds});

  @override
  $InfiniteScrollStateCopyWith<int, $Res> get list;
}

/// @nodoc
class __$FeedTabUiStateCopyWithImpl<$Res>
    implements _$FeedTabUiStateCopyWith<$Res> {
  __$FeedTabUiStateCopyWithImpl(this._self, this._then);

  final _FeedTabUiState _self;
  final $Res Function(_FeedTabUiState) _then;

  /// Create a copy of FeedTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? list = null,
    Object? cache = null,
    Object? expandedFeedIds = null,
  }) {
    return _then(_FeedTabUiState(
      list: null == list
          ? _self.list
          : list // ignore: cast_nullable_to_non_nullable
              as InfiniteScrollState<int>,
      cache: null == cache
          ? _self.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as AlbumCache,
      expandedFeedIds: null == expandedFeedIds
          ? _self._expandedFeedIds
          : expandedFeedIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ));
  }

  /// Create a copy of FeedTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InfiniteScrollStateCopyWith<int, $Res> get list {
    return $InfiniteScrollStateCopyWith<int, $Res>(_self.list, (value) {
      return _then(_self.copyWith(list: value));
    });
  }
}

// dart format on
