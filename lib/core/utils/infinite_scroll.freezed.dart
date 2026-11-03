// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'infinite_scroll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InfiniteScrollState<T> {
  List<T> get items;
  String? get nextCursor;
  bool get hasNext;
  bool get isFetching;
  bool get isLoadingMore;
  bool get hasError;

  /// Create a copy of InfiniteScrollState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InfiniteScrollStateCopyWith<T, InfiniteScrollState<T>> get copyWith =>
      _$InfiniteScrollStateCopyWithImpl<T, InfiniteScrollState<T>>(
          this as InfiniteScrollState<T>, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InfiniteScrollState<T> &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.isFetching, isFetching) ||
                other.isFetching == isFetching) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.hasError, hasError) ||
                other.hasError == hasError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(items),
      nextCursor,
      hasNext,
      isFetching,
      isLoadingMore,
      hasError);

  @override
  String toString() {
    return 'InfiniteScrollState<$T>(items: $items, nextCursor: $nextCursor, hasNext: $hasNext, isFetching: $isFetching, isLoadingMore: $isLoadingMore, hasError: $hasError)';
  }
}

/// @nodoc
abstract mixin class $InfiniteScrollStateCopyWith<T, $Res> {
  factory $InfiniteScrollStateCopyWith(InfiniteScrollState<T> value,
          $Res Function(InfiniteScrollState<T>) _then) =
      _$InfiniteScrollStateCopyWithImpl;
  @useResult
  $Res call(
      {List<T> items,
      String? nextCursor,
      bool hasNext,
      bool isFetching,
      bool isLoadingMore,
      bool hasError});
}

/// @nodoc
class _$InfiniteScrollStateCopyWithImpl<T, $Res>
    implements $InfiniteScrollStateCopyWith<T, $Res> {
  _$InfiniteScrollStateCopyWithImpl(this._self, this._then);

  final InfiniteScrollState<T> _self;
  final $Res Function(InfiniteScrollState<T>) _then;

  /// Create a copy of InfiniteScrollState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
    Object? isFetching = null,
    Object? isLoadingMore = null,
    Object? hasError = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      isFetching: null == isFetching
          ? _self.isFetching
          : isFetching // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      hasError: null == hasError
          ? _self.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [InfiniteScrollState].
extension InfiniteScrollStatePatterns<T> on InfiniteScrollState<T> {
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
    TResult Function(_InfiniteScrollState<T> value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InfiniteScrollState() when $default != null:
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
    TResult Function(_InfiniteScrollState<T> value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InfiniteScrollState():
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
    TResult? Function(_InfiniteScrollState<T> value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InfiniteScrollState() when $default != null:
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
    TResult Function(List<T> items, String? nextCursor, bool hasNext,
            bool isFetching, bool isLoadingMore, bool hasError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InfiniteScrollState() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext,
            _that.isFetching, _that.isLoadingMore, _that.hasError);
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
    TResult Function(List<T> items, String? nextCursor, bool hasNext,
            bool isFetching, bool isLoadingMore, bool hasError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InfiniteScrollState():
        return $default(_that.items, _that.nextCursor, _that.hasNext,
            _that.isFetching, _that.isLoadingMore, _that.hasError);
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
    TResult? Function(List<T> items, String? nextCursor, bool hasNext,
            bool isFetching, bool isLoadingMore, bool hasError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InfiniteScrollState() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext,
            _that.isFetching, _that.isLoadingMore, _that.hasError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _InfiniteScrollState<T> extends InfiniteScrollState<T> {
  const _InfiniteScrollState(
      {final List<T> items = const [],
      this.nextCursor,
      this.hasNext = true,
      this.isFetching = false,
      this.isLoadingMore = false,
      this.hasError = false})
      : _items = items,
        super._();

  final List<T> _items;
  @override
  @JsonKey()
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;
  @override
  @JsonKey()
  final bool hasNext;
  @override
  @JsonKey()
  final bool isFetching;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool hasError;

  /// Create a copy of InfiniteScrollState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InfiniteScrollStateCopyWith<T, _InfiniteScrollState<T>> get copyWith =>
      __$InfiniteScrollStateCopyWithImpl<T, _InfiniteScrollState<T>>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InfiniteScrollState<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.isFetching, isFetching) ||
                other.isFetching == isFetching) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.hasError, hasError) ||
                other.hasError == hasError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      nextCursor,
      hasNext,
      isFetching,
      isLoadingMore,
      hasError);

  @override
  String toString() {
    return 'InfiniteScrollState<$T>(items: $items, nextCursor: $nextCursor, hasNext: $hasNext, isFetching: $isFetching, isLoadingMore: $isLoadingMore, hasError: $hasError)';
  }
}

/// @nodoc
abstract mixin class _$InfiniteScrollStateCopyWith<T, $Res>
    implements $InfiniteScrollStateCopyWith<T, $Res> {
  factory _$InfiniteScrollStateCopyWith(_InfiniteScrollState<T> value,
          $Res Function(_InfiniteScrollState<T>) _then) =
      __$InfiniteScrollStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<T> items,
      String? nextCursor,
      bool hasNext,
      bool isFetching,
      bool isLoadingMore,
      bool hasError});
}

/// @nodoc
class __$InfiniteScrollStateCopyWithImpl<T, $Res>
    implements _$InfiniteScrollStateCopyWith<T, $Res> {
  __$InfiniteScrollStateCopyWithImpl(this._self, this._then);

  final _InfiniteScrollState<T> _self;
  final $Res Function(_InfiniteScrollState<T>) _then;

  /// Create a copy of InfiniteScrollState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
    Object? isFetching = null,
    Object? isLoadingMore = null,
    Object? hasError = null,
  }) {
    return _then(_InfiniteScrollState<T>(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      isFetching: null == isFetching
          ? _self.isFetching
          : isFetching // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      hasError: null == hasError
          ? _self.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
