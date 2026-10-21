// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'infinite_page_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InfinitePageResult<T> {
  List<T> get items;
  String? get nextCursor;
  bool get hasNext;

  /// Create a copy of InfinitePageResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InfinitePageResultCopyWith<T, InfinitePageResult<T>> get copyWith =>
      _$InfinitePageResultCopyWithImpl<T, InfinitePageResult<T>>(
          this as InfinitePageResult<T>, _$identity);

  /// Serializes this InfinitePageResult to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InfinitePageResult<T> &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(items), nextCursor, hasNext);

  @override
  String toString() {
    return 'InfinitePageResult<$T>(items: $items, nextCursor: $nextCursor, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class $InfinitePageResultCopyWith<T, $Res> {
  factory $InfinitePageResultCopyWith(InfinitePageResult<T> value,
          $Res Function(InfinitePageResult<T>) _then) =
      _$InfinitePageResultCopyWithImpl;
  @useResult
  $Res call({List<T> items, String? nextCursor, bool hasNext});
}

/// @nodoc
class _$InfinitePageResultCopyWithImpl<T, $Res>
    implements $InfinitePageResultCopyWith<T, $Res> {
  _$InfinitePageResultCopyWithImpl(this._self, this._then);

  final InfinitePageResult<T> _self;
  final $Res Function(InfinitePageResult<T>) _then;

  /// Create a copy of InfinitePageResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [InfinitePageResult].
extension InfinitePageResultPatterns<T> on InfinitePageResult<T> {
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
    TResult Function(_InfinitePageResult<T> value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InfinitePageResult() when $default != null:
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
    TResult Function(_InfinitePageResult<T> value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InfinitePageResult():
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
    TResult? Function(_InfinitePageResult<T> value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InfinitePageResult() when $default != null:
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
    TResult Function(List<T> items, String? nextCursor, bool hasNext)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InfinitePageResult() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext);
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
    TResult Function(List<T> items, String? nextCursor, bool hasNext) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InfinitePageResult():
        return $default(_that.items, _that.nextCursor, _that.hasNext);
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
    TResult? Function(List<T> items, String? nextCursor, bool hasNext)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InfinitePageResult() when $default != null:
        return $default(_that.items, _that.nextCursor, _that.hasNext);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _InfinitePageResult<T> implements InfinitePageResult<T> {
  const _InfinitePageResult(
      {final List<T> items = const [],
      required this.nextCursor,
      this.hasNext = false})
      : _items = items;
  factory _InfinitePageResult.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$InfinitePageResultFromJson(json, fromJsonT);

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

  /// Create a copy of InfinitePageResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InfinitePageResultCopyWith<T, _InfinitePageResult<T>> get copyWith =>
      __$InfinitePageResultCopyWithImpl<T, _InfinitePageResult<T>>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$InfinitePageResultToJson<T>(this, toJsonT);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InfinitePageResult<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), nextCursor, hasNext);

  @override
  String toString() {
    return 'InfinitePageResult<$T>(items: $items, nextCursor: $nextCursor, hasNext: $hasNext)';
  }
}

/// @nodoc
abstract mixin class _$InfinitePageResultCopyWith<T, $Res>
    implements $InfinitePageResultCopyWith<T, $Res> {
  factory _$InfinitePageResultCopyWith(_InfinitePageResult<T> value,
          $Res Function(_InfinitePageResult<T>) _then) =
      __$InfinitePageResultCopyWithImpl;
  @override
  @useResult
  $Res call({List<T> items, String? nextCursor, bool hasNext});
}

/// @nodoc
class __$InfinitePageResultCopyWithImpl<T, $Res>
    implements _$InfinitePageResultCopyWith<T, $Res> {
  __$InfinitePageResultCopyWithImpl(this._self, this._then);

  final _InfinitePageResult<T> _self;
  final $Res Function(_InfinitePageResult<T>) _then;

  /// Create a copy of InfinitePageResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? hasNext = null,
  }) {
    return _then(_InfinitePageResult<T>(
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
    ));
  }
}

// dart format on
