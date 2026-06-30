// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Notification {
  int get notificationId;
  String get image;
  String get title;
  String get content;
  String get createdAt;
  String get scheme;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationCopyWith<Notification> get copyWith =>
      _$NotificationCopyWithImpl<Notification>(
          this as Notification, _$identity);

  /// Serializes this Notification to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Notification &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.scheme, scheme) || other.scheme == scheme));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, notificationId, image, title, content, createdAt, scheme);

  @override
  String toString() {
    return 'Notification(notificationId: $notificationId, image: $image, title: $title, content: $content, createdAt: $createdAt, scheme: $scheme)';
  }
}

/// @nodoc
abstract mixin class $NotificationCopyWith<$Res> {
  factory $NotificationCopyWith(
          Notification value, $Res Function(Notification) _then) =
      _$NotificationCopyWithImpl;
  @useResult
  $Res call(
      {int notificationId,
      String image,
      String title,
      String content,
      String createdAt,
      String scheme});
}

/// @nodoc
class _$NotificationCopyWithImpl<$Res> implements $NotificationCopyWith<$Res> {
  _$NotificationCopyWithImpl(this._self, this._then);

  final Notification _self;
  final $Res Function(Notification) _then;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? image = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? scheme = null,
  }) {
    return _then(_self.copyWith(
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int,
      image: null == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      scheme: null == scheme
          ? _self.scheme
          : scheme // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Notification].
extension NotificationPatterns on Notification {
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
    TResult Function(_Notification value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Notification() when $default != null:
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
    TResult Function(_Notification value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Notification():
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
    TResult? Function(_Notification value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Notification() when $default != null:
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
    TResult Function(int notificationId, String image, String title,
            String content, String createdAt, String scheme)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Notification() when $default != null:
        return $default(_that.notificationId, _that.image, _that.title,
            _that.content, _that.createdAt, _that.scheme);
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
    TResult Function(int notificationId, String image, String title,
            String content, String createdAt, String scheme)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Notification():
        return $default(_that.notificationId, _that.image, _that.title,
            _that.content, _that.createdAt, _that.scheme);
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
    TResult? Function(int notificationId, String image, String title,
            String content, String createdAt, String scheme)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Notification() when $default != null:
        return $default(_that.notificationId, _that.image, _that.title,
            _that.content, _that.createdAt, _that.scheme);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Notification implements Notification {
  const _Notification(
      {required this.notificationId,
      required this.image,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.scheme});
  factory _Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  @override
  final int notificationId;
  @override
  final String image;
  @override
  final String title;
  @override
  final String content;
  @override
  final String createdAt;
  @override
  final String scheme;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationCopyWith<_Notification> get copyWith =>
      __$NotificationCopyWithImpl<_Notification>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Notification &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.scheme, scheme) || other.scheme == scheme));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, notificationId, image, title, content, createdAt, scheme);

  @override
  String toString() {
    return 'Notification(notificationId: $notificationId, image: $image, title: $title, content: $content, createdAt: $createdAt, scheme: $scheme)';
  }
}

/// @nodoc
abstract mixin class _$NotificationCopyWith<$Res>
    implements $NotificationCopyWith<$Res> {
  factory _$NotificationCopyWith(
          _Notification value, $Res Function(_Notification) _then) =
      __$NotificationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int notificationId,
      String image,
      String title,
      String content,
      String createdAt,
      String scheme});
}

/// @nodoc
class __$NotificationCopyWithImpl<$Res>
    implements _$NotificationCopyWith<$Res> {
  __$NotificationCopyWithImpl(this._self, this._then);

  final _Notification _self;
  final $Res Function(_Notification) _then;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? notificationId = null,
    Object? image = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? scheme = null,
  }) {
    return _then(_Notification(
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int,
      image: null == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      scheme: null == scheme
          ? _self.scheme
          : scheme // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
