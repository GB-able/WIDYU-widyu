// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationUiState {
  String get category;
  List<NotificationCategory> get categories;

  /// Create a copy of NotificationUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationUiStateCopyWith<NotificationUiState> get copyWith =>
      _$NotificationUiStateCopyWithImpl<NotificationUiState>(
          this as NotificationUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationUiState &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, category, const DeepCollectionEquality().hash(categories));

  @override
  String toString() {
    return 'NotificationUiState(category: $category, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $NotificationUiStateCopyWith<$Res> {
  factory $NotificationUiStateCopyWith(
          NotificationUiState value, $Res Function(NotificationUiState) _then) =
      _$NotificationUiStateCopyWithImpl;
  @useResult
  $Res call({String category, List<NotificationCategory> categories});
}

/// @nodoc
class _$NotificationUiStateCopyWithImpl<$Res>
    implements $NotificationUiStateCopyWith<$Res> {
  _$NotificationUiStateCopyWithImpl(this._self, this._then);

  final NotificationUiState _self;
  final $Res Function(NotificationUiState) _then;

  /// Create a copy of NotificationUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? categories = null,
  }) {
    return _then(_self.copyWith(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<NotificationCategory>,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationUiState].
extension NotificationUiStatePatterns on NotificationUiState {
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
    TResult Function(_NotificationUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationUiState() when $default != null:
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
    TResult Function(_NotificationUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationUiState():
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
    TResult? Function(_NotificationUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationUiState() when $default != null:
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
    TResult Function(String category, List<NotificationCategory> categories)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationUiState() when $default != null:
        return $default(_that.category, _that.categories);
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
    TResult Function(String category, List<NotificationCategory> categories)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationUiState():
        return $default(_that.category, _that.categories);
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
    TResult? Function(String category, List<NotificationCategory> categories)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationUiState() when $default != null:
        return $default(_that.category, _that.categories);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _NotificationUiState extends NotificationUiState {
  const _NotificationUiState(
      {this.category = 'ALL',
      final List<NotificationCategory> categories = const []})
      : _categories = categories,
        super._();

  @override
  @JsonKey()
  final String category;
  final List<NotificationCategory> _categories;
  @override
  @JsonKey()
  List<NotificationCategory> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// Create a copy of NotificationUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationUiStateCopyWith<_NotificationUiState> get copyWith =>
      __$NotificationUiStateCopyWithImpl<_NotificationUiState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationUiState &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, category, const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'NotificationUiState(category: $category, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class _$NotificationUiStateCopyWith<$Res>
    implements $NotificationUiStateCopyWith<$Res> {
  factory _$NotificationUiStateCopyWith(_NotificationUiState value,
          $Res Function(_NotificationUiState) _then) =
      __$NotificationUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({String category, List<NotificationCategory> categories});
}

/// @nodoc
class __$NotificationUiStateCopyWithImpl<$Res>
    implements _$NotificationUiStateCopyWith<$Res> {
  __$NotificationUiStateCopyWithImpl(this._self, this._then);

  final _NotificationUiState _self;
  final $Res Function(_NotificationUiState) _then;

  /// Create a copy of NotificationUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = null,
    Object? categories = null,
  }) {
    return _then(_NotificationUiState(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<NotificationCategory>,
    ));
  }
}

// dart format on
