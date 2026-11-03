// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationItemUiModel {
  int get notificationId;
  String get image;
  String get category;
  String get title;
  String get content;
  bool get isRead;
  DateTime get createdAt;
  String get path;

  /// Create a copy of NotificationItemUiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationItemUiModelCopyWith<NotificationItemUiModel> get copyWith =>
      _$NotificationItemUiModelCopyWithImpl<NotificationItemUiModel>(
          this as NotificationItemUiModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationItemUiModel &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, notificationId, image, category,
      title, content, isRead, createdAt, path);

  @override
  String toString() {
    return 'NotificationItemUiModel(notificationId: $notificationId, image: $image, category: $category, title: $title, content: $content, isRead: $isRead, createdAt: $createdAt, path: $path)';
  }
}

/// @nodoc
abstract mixin class $NotificationItemUiModelCopyWith<$Res> {
  factory $NotificationItemUiModelCopyWith(NotificationItemUiModel value,
          $Res Function(NotificationItemUiModel) _then) =
      _$NotificationItemUiModelCopyWithImpl;
  @useResult
  $Res call(
      {int notificationId,
      String image,
      String category,
      String title,
      String content,
      bool isRead,
      DateTime createdAt,
      String path});
}

/// @nodoc
class _$NotificationItemUiModelCopyWithImpl<$Res>
    implements $NotificationItemUiModelCopyWith<$Res> {
  _$NotificationItemUiModelCopyWithImpl(this._self, this._then);

  final NotificationItemUiModel _self;
  final $Res Function(NotificationItemUiModel) _then;

  /// Create a copy of NotificationItemUiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? image = null,
    Object? category = null,
    Object? title = null,
    Object? content = null,
    Object? isRead = null,
    Object? createdAt = null,
    Object? path = null,
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
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationItemUiModel].
extension NotificationItemUiModelPatterns on NotificationItemUiModel {
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
    TResult Function(_NotificationItemUiModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationItemUiModel() when $default != null:
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
    TResult Function(_NotificationItemUiModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationItemUiModel():
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
    TResult? Function(_NotificationItemUiModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationItemUiModel() when $default != null:
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
            int notificationId,
            String image,
            String category,
            String title,
            String content,
            bool isRead,
            DateTime createdAt,
            String path)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationItemUiModel() when $default != null:
        return $default(
            _that.notificationId,
            _that.image,
            _that.category,
            _that.title,
            _that.content,
            _that.isRead,
            _that.createdAt,
            _that.path);
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
            int notificationId,
            String image,
            String category,
            String title,
            String content,
            bool isRead,
            DateTime createdAt,
            String path)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationItemUiModel():
        return $default(
            _that.notificationId,
            _that.image,
            _that.category,
            _that.title,
            _that.content,
            _that.isRead,
            _that.createdAt,
            _that.path);
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
            int notificationId,
            String image,
            String category,
            String title,
            String content,
            bool isRead,
            DateTime createdAt,
            String path)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationItemUiModel() when $default != null:
        return $default(
            _that.notificationId,
            _that.image,
            _that.category,
            _that.title,
            _that.content,
            _that.isRead,
            _that.createdAt,
            _that.path);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _NotificationItemUiModel implements NotificationItemUiModel {
  const _NotificationItemUiModel(
      {required this.notificationId,
      required this.image,
      required this.category,
      required this.title,
      required this.content,
      required this.isRead,
      required this.createdAt,
      required this.path});

  @override
  final int notificationId;
  @override
  final String image;
  @override
  final String category;
  @override
  final String title;
  @override
  final String content;
  @override
  final bool isRead;
  @override
  final DateTime createdAt;
  @override
  final String path;

  /// Create a copy of NotificationItemUiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationItemUiModelCopyWith<_NotificationItemUiModel> get copyWith =>
      __$NotificationItemUiModelCopyWithImpl<_NotificationItemUiModel>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationItemUiModel &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, notificationId, image, category,
      title, content, isRead, createdAt, path);

  @override
  String toString() {
    return 'NotificationItemUiModel(notificationId: $notificationId, image: $image, category: $category, title: $title, content: $content, isRead: $isRead, createdAt: $createdAt, path: $path)';
  }
}

/// @nodoc
abstract mixin class _$NotificationItemUiModelCopyWith<$Res>
    implements $NotificationItemUiModelCopyWith<$Res> {
  factory _$NotificationItemUiModelCopyWith(_NotificationItemUiModel value,
          $Res Function(_NotificationItemUiModel) _then) =
      __$NotificationItemUiModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int notificationId,
      String image,
      String category,
      String title,
      String content,
      bool isRead,
      DateTime createdAt,
      String path});
}

/// @nodoc
class __$NotificationItemUiModelCopyWithImpl<$Res>
    implements _$NotificationItemUiModelCopyWith<$Res> {
  __$NotificationItemUiModelCopyWithImpl(this._self, this._then);

  final _NotificationItemUiModel _self;
  final $Res Function(_NotificationItemUiModel) _then;

  /// Create a copy of NotificationItemUiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? notificationId = null,
    Object? image = null,
    Object? category = null,
    Object? title = null,
    Object? content = null,
    Object? isRead = null,
    Object? createdAt = null,
    Object? path = null,
  }) {
    return _then(_NotificationItemUiModel(
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int,
      image: null == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
