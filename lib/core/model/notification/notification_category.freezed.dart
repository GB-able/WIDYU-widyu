// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationCategory {
  String get label;
  String get name;
  int get count;

  /// Create a copy of NotificationCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationCategoryCopyWith<NotificationCategory> get copyWith =>
      _$NotificationCategoryCopyWithImpl<NotificationCategory>(
          this as NotificationCategory, _$identity);

  /// Serializes this NotificationCategory to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationCategory &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, name, count);

  @override
  String toString() {
    return 'NotificationCategory(label: $label, name: $name, count: $count)';
  }
}

/// @nodoc
abstract mixin class $NotificationCategoryCopyWith<$Res> {
  factory $NotificationCategoryCopyWith(NotificationCategory value,
          $Res Function(NotificationCategory) _then) =
      _$NotificationCategoryCopyWithImpl;
  @useResult
  $Res call({String label, String name, int count});
}

/// @nodoc
class _$NotificationCategoryCopyWithImpl<$Res>
    implements $NotificationCategoryCopyWith<$Res> {
  _$NotificationCategoryCopyWithImpl(this._self, this._then);

  final NotificationCategory _self;
  final $Res Function(NotificationCategory) _then;

  /// Create a copy of NotificationCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? name = null,
    Object? count = null,
  }) {
    return _then(_self.copyWith(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationCategory].
extension NotificationCategoryPatterns on NotificationCategory {
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
    TResult Function(_NotificationCategory value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationCategory() when $default != null:
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
    TResult Function(_NotificationCategory value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationCategory():
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
    TResult? Function(_NotificationCategory value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationCategory() when $default != null:
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
    TResult Function(String label, String name, int count)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationCategory() when $default != null:
        return $default(_that.label, _that.name, _that.count);
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
    TResult Function(String label, String name, int count) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationCategory():
        return $default(_that.label, _that.name, _that.count);
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
    TResult? Function(String label, String name, int count)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationCategory() when $default != null:
        return $default(_that.label, _that.name, _that.count);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationCategory implements NotificationCategory {
  const _NotificationCategory(
      {required this.label, required this.name, required this.count});
  factory _NotificationCategory.fromJson(Map<String, dynamic> json) =>
      _$NotificationCategoryFromJson(json);

  @override
  final String label;
  @override
  final String name;
  @override
  final int count;

  /// Create a copy of NotificationCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationCategoryCopyWith<_NotificationCategory> get copyWith =>
      __$NotificationCategoryCopyWithImpl<_NotificationCategory>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationCategoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationCategory &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, name, count);

  @override
  String toString() {
    return 'NotificationCategory(label: $label, name: $name, count: $count)';
  }
}

/// @nodoc
abstract mixin class _$NotificationCategoryCopyWith<$Res>
    implements $NotificationCategoryCopyWith<$Res> {
  factory _$NotificationCategoryCopyWith(_NotificationCategory value,
          $Res Function(_NotificationCategory) _then) =
      __$NotificationCategoryCopyWithImpl;
  @override
  @useResult
  $Res call({String label, String name, int count});
}

/// @nodoc
class __$NotificationCategoryCopyWithImpl<$Res>
    implements _$NotificationCategoryCopyWith<$Res> {
  __$NotificationCategoryCopyWithImpl(this._self, this._then);

  final _NotificationCategory _self;
  final $Res Function(_NotificationCategory) _then;

  /// Create a copy of NotificationCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? label = null,
    Object? name = null,
    Object? count = null,
  }) {
    return _then(_NotificationCategory(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
