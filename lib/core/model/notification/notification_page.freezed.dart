// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPage {
  List<Notification> get notifications;
  bool get hasNext;
  int? get nextCursor;

  /// Create a copy of NotificationPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationPageCopyWith<NotificationPage> get copyWith =>
      _$NotificationPageCopyWithImpl<NotificationPage>(
          this as NotificationPage, _$identity);

  /// Serializes this NotificationPage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationPage &&
            const DeepCollectionEquality()
                .equals(other.notifications, notifications) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(notifications), hasNext, nextCursor);

  @override
  String toString() {
    return 'NotificationPage(notifications: $notifications, hasNext: $hasNext, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $NotificationPageCopyWith<$Res> {
  factory $NotificationPageCopyWith(
          NotificationPage value, $Res Function(NotificationPage) _then) =
      _$NotificationPageCopyWithImpl;
  @useResult
  $Res call({List<Notification> notifications, bool hasNext, int? nextCursor});
}

/// @nodoc
class _$NotificationPageCopyWithImpl<$Res>
    implements $NotificationPageCopyWith<$Res> {
  _$NotificationPageCopyWithImpl(this._self, this._then);

  final NotificationPage _self;
  final $Res Function(NotificationPage) _then;

  /// Create a copy of NotificationPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? hasNext = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_self.copyWith(
      notifications: null == notifications
          ? _self.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<Notification>,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationPage].
extension NotificationPagePatterns on NotificationPage {
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
    TResult Function(_NotificationPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationPage() when $default != null:
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
    TResult Function(_NotificationPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPage():
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
    TResult? Function(_NotificationPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPage() when $default != null:
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
    TResult Function(
            List<Notification> notifications, bool hasNext, int? nextCursor)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationPage() when $default != null:
        return $default(_that.notifications, _that.hasNext, _that.nextCursor);
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
    TResult Function(
            List<Notification> notifications, bool hasNext, int? nextCursor)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPage():
        return $default(_that.notifications, _that.hasNext, _that.nextCursor);
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
    TResult? Function(
            List<Notification> notifications, bool hasNext, int? nextCursor)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPage() when $default != null:
        return $default(_that.notifications, _that.hasNext, _that.nextCursor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationPage implements NotificationPage {
  const _NotificationPage(
      {required final List<Notification> notifications,
      required this.hasNext,
      required this.nextCursor})
      : _notifications = notifications;
  factory _NotificationPage.fromJson(Map<String, dynamic> json) =>
      _$NotificationPageFromJson(json);

  final List<Notification> _notifications;
  @override
  List<Notification> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  final bool hasNext;
  @override
  final int? nextCursor;

  /// Create a copy of NotificationPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationPageCopyWith<_NotificationPage> get copyWith =>
      __$NotificationPageCopyWithImpl<_NotificationPage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationPageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationPage &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_notifications), hasNext, nextCursor);

  @override
  String toString() {
    return 'NotificationPage(notifications: $notifications, hasNext: $hasNext, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$NotificationPageCopyWith<$Res>
    implements $NotificationPageCopyWith<$Res> {
  factory _$NotificationPageCopyWith(
          _NotificationPage value, $Res Function(_NotificationPage) _then) =
      __$NotificationPageCopyWithImpl;
  @override
  @useResult
  $Res call({List<Notification> notifications, bool hasNext, int? nextCursor});
}

/// @nodoc
class __$NotificationPageCopyWithImpl<$Res>
    implements _$NotificationPageCopyWith<$Res> {
  __$NotificationPageCopyWithImpl(this._self, this._then);

  final _NotificationPage _self;
  final $Res Function(_NotificationPage) _then;

  /// Create a copy of NotificationPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? notifications = null,
    Object? hasNext = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_NotificationPage(
      notifications: null == notifications
          ? _self._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<Notification>,
      hasNext: null == hasNext
          ? _self.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
