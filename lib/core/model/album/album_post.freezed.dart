// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumPost {
  int get albumId;
  String get authorName;
  String? get authorProfileImage;
  String get content;
  List<String> get mediaUrls;
  List<String> get thumbnailUrls;
  List<Member> get viewers;
  DateTime get createdAt;
  bool get canEdit;
  int get price;

  /// Create a copy of AlbumPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AlbumPostCopyWith<AlbumPost> get copyWith =>
      _$AlbumPostCopyWithImpl<AlbumPost>(this as AlbumPost, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AlbumPost &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorProfileImage, authorProfileImage) ||
                other.authorProfileImage == authorProfileImage) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other.mediaUrls, mediaUrls) &&
            const DeepCollectionEquality()
                .equals(other.thumbnailUrls, thumbnailUrls) &&
            const DeepCollectionEquality().equals(other.viewers, viewers) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            (identical(other.price, price) || other.price == price));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      albumId,
      authorName,
      authorProfileImage,
      content,
      const DeepCollectionEquality().hash(mediaUrls),
      const DeepCollectionEquality().hash(thumbnailUrls),
      const DeepCollectionEquality().hash(viewers),
      createdAt,
      canEdit,
      price);

  @override
  String toString() {
    return 'AlbumPost(albumId: $albumId, authorName: $authorName, authorProfileImage: $authorProfileImage, content: $content, mediaUrls: $mediaUrls, thumbnailUrls: $thumbnailUrls, viewers: $viewers, createdAt: $createdAt, canEdit: $canEdit, price: $price)';
  }
}

/// @nodoc
abstract mixin class $AlbumPostCopyWith<$Res> {
  factory $AlbumPostCopyWith(AlbumPost value, $Res Function(AlbumPost) _then) =
      _$AlbumPostCopyWithImpl;
  @useResult
  $Res call(
      {int albumId,
      String authorName,
      String? authorProfileImage,
      String content,
      List<String> mediaUrls,
      List<String> thumbnailUrls,
      List<Member> viewers,
      DateTime createdAt,
      bool canEdit,
      int price});
}

/// @nodoc
class _$AlbumPostCopyWithImpl<$Res> implements $AlbumPostCopyWith<$Res> {
  _$AlbumPostCopyWithImpl(this._self, this._then);

  final AlbumPost _self;
  final $Res Function(AlbumPost) _then;

  /// Create a copy of AlbumPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? albumId = null,
    Object? authorName = null,
    Object? authorProfileImage = freezed,
    Object? content = null,
    Object? mediaUrls = null,
    Object? thumbnailUrls = null,
    Object? viewers = null,
    Object? createdAt = null,
    Object? canEdit = null,
    Object? price = null,
  }) {
    return _then(_self.copyWith(
      albumId: null == albumId
          ? _self.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: null == authorName
          ? _self.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorProfileImage: freezed == authorProfileImage
          ? _self.authorProfileImage
          : authorProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrls: null == mediaUrls
          ? _self.mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnailUrls: null == thumbnailUrls
          ? _self.thumbnailUrls
          : thumbnailUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      viewers: null == viewers
          ? _self.viewers
          : viewers // ignore: cast_nullable_to_non_nullable
              as List<Member>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      canEdit: null == canEdit
          ? _self.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AlbumPost].
extension AlbumPostPatterns on AlbumPost {
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
    TResult Function(_AlbumPost value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumPost() when $default != null:
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
    TResult Function(_AlbumPost value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumPost():
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
    TResult? Function(_AlbumPost value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumPost() when $default != null:
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
            int albumId,
            String authorName,
            String? authorProfileImage,
            String content,
            List<String> mediaUrls,
            List<String> thumbnailUrls,
            List<Member> viewers,
            DateTime createdAt,
            bool canEdit,
            int price)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumPost() when $default != null:
        return $default(
            _that.albumId,
            _that.authorName,
            _that.authorProfileImage,
            _that.content,
            _that.mediaUrls,
            _that.thumbnailUrls,
            _that.viewers,
            _that.createdAt,
            _that.canEdit,
            _that.price);
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
            int albumId,
            String authorName,
            String? authorProfileImage,
            String content,
            List<String> mediaUrls,
            List<String> thumbnailUrls,
            List<Member> viewers,
            DateTime createdAt,
            bool canEdit,
            int price)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumPost():
        return $default(
            _that.albumId,
            _that.authorName,
            _that.authorProfileImage,
            _that.content,
            _that.mediaUrls,
            _that.thumbnailUrls,
            _that.viewers,
            _that.createdAt,
            _that.canEdit,
            _that.price);
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
            int albumId,
            String authorName,
            String? authorProfileImage,
            String content,
            List<String> mediaUrls,
            List<String> thumbnailUrls,
            List<Member> viewers,
            DateTime createdAt,
            bool canEdit,
            int price)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumPost() when $default != null:
        return $default(
            _that.albumId,
            _that.authorName,
            _that.authorProfileImage,
            _that.content,
            _that.mediaUrls,
            _that.thumbnailUrls,
            _that.viewers,
            _that.createdAt,
            _that.canEdit,
            _that.price);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AlbumPost implements AlbumPost {
  const _AlbumPost(
      {required this.albumId,
      required this.authorName,
      this.authorProfileImage,
      required this.content,
      required final List<String> mediaUrls,
      required final List<String> thumbnailUrls,
      required final List<Member> viewers,
      required this.createdAt,
      required this.canEdit,
      required this.price})
      : _mediaUrls = mediaUrls,
        _thumbnailUrls = thumbnailUrls,
        _viewers = viewers;

  @override
  final int albumId;
  @override
  final String authorName;
  @override
  final String? authorProfileImage;
  @override
  final String content;
  final List<String> _mediaUrls;
  @override
  List<String> get mediaUrls {
    if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaUrls);
  }

  final List<String> _thumbnailUrls;
  @override
  List<String> get thumbnailUrls {
    if (_thumbnailUrls is EqualUnmodifiableListView) return _thumbnailUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thumbnailUrls);
  }

  final List<Member> _viewers;
  @override
  List<Member> get viewers {
    if (_viewers is EqualUnmodifiableListView) return _viewers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viewers);
  }

  @override
  final DateTime createdAt;
  @override
  final bool canEdit;
  @override
  final int price;

  /// Create a copy of AlbumPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AlbumPostCopyWith<_AlbumPost> get copyWith =>
      __$AlbumPostCopyWithImpl<_AlbumPost>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AlbumPost &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorProfileImage, authorProfileImage) ||
                other.authorProfileImage == authorProfileImage) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._mediaUrls, _mediaUrls) &&
            const DeepCollectionEquality()
                .equals(other._thumbnailUrls, _thumbnailUrls) &&
            const DeepCollectionEquality().equals(other._viewers, _viewers) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            (identical(other.price, price) || other.price == price));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      albumId,
      authorName,
      authorProfileImage,
      content,
      const DeepCollectionEquality().hash(_mediaUrls),
      const DeepCollectionEquality().hash(_thumbnailUrls),
      const DeepCollectionEquality().hash(_viewers),
      createdAt,
      canEdit,
      price);

  @override
  String toString() {
    return 'AlbumPost(albumId: $albumId, authorName: $authorName, authorProfileImage: $authorProfileImage, content: $content, mediaUrls: $mediaUrls, thumbnailUrls: $thumbnailUrls, viewers: $viewers, createdAt: $createdAt, canEdit: $canEdit, price: $price)';
  }
}

/// @nodoc
abstract mixin class _$AlbumPostCopyWith<$Res>
    implements $AlbumPostCopyWith<$Res> {
  factory _$AlbumPostCopyWith(
          _AlbumPost value, $Res Function(_AlbumPost) _then) =
      __$AlbumPostCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int albumId,
      String authorName,
      String? authorProfileImage,
      String content,
      List<String> mediaUrls,
      List<String> thumbnailUrls,
      List<Member> viewers,
      DateTime createdAt,
      bool canEdit,
      int price});
}

/// @nodoc
class __$AlbumPostCopyWithImpl<$Res> implements _$AlbumPostCopyWith<$Res> {
  __$AlbumPostCopyWithImpl(this._self, this._then);

  final _AlbumPost _self;
  final $Res Function(_AlbumPost) _then;

  /// Create a copy of AlbumPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? albumId = null,
    Object? authorName = null,
    Object? authorProfileImage = freezed,
    Object? content = null,
    Object? mediaUrls = null,
    Object? thumbnailUrls = null,
    Object? viewers = null,
    Object? createdAt = null,
    Object? canEdit = null,
    Object? price = null,
  }) {
    return _then(_AlbumPost(
      albumId: null == albumId
          ? _self.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: null == authorName
          ? _self.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorProfileImage: freezed == authorProfileImage
          ? _self.authorProfileImage
          : authorProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrls: null == mediaUrls
          ? _self._mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnailUrls: null == thumbnailUrls
          ? _self._thumbnailUrls
          : thumbnailUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      viewers: null == viewers
          ? _self._viewers
          : viewers // ignore: cast_nullable_to_non_nullable
              as List<Member>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      canEdit: null == canEdit
          ? _self.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
