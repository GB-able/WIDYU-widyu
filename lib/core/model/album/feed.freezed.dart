// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Feed {
  int get albumId;
  String get authorName;
  String? get authorProfileImage;
  String get content;
  List<String> get mediaUrls;
  List<String> get thumbnailUrls;
  String? get primaryMediaType;
  int get mediaCount;
  int get photoCount;
  int get videoCount;
  int get likeCount;
  int get commentCount;
  List<Viewer> get viewers;
  DateTime get createdAt;
  bool get canEdit;
  String? get videoDuration;

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedCopyWith<Feed> get copyWith =>
      _$FeedCopyWithImpl<Feed>(this as Feed, _$identity);

  /// Serializes this Feed to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Feed &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorProfileImage, authorProfileImage) ||
                other.authorProfileImage == authorProfileImage) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other.mediaUrls, mediaUrls) &&
            const DeepCollectionEquality()
                .equals(other.thumbnailUrls, thumbnailUrls) &&
            (identical(other.primaryMediaType, primaryMediaType) ||
                other.primaryMediaType == primaryMediaType) &&
            (identical(other.mediaCount, mediaCount) ||
                other.mediaCount == mediaCount) &&
            (identical(other.photoCount, photoCount) ||
                other.photoCount == photoCount) &&
            (identical(other.videoCount, videoCount) ||
                other.videoCount == videoCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            const DeepCollectionEquality().equals(other.viewers, viewers) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            (identical(other.videoDuration, videoDuration) ||
                other.videoDuration == videoDuration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      albumId,
      authorName,
      authorProfileImage,
      content,
      const DeepCollectionEquality().hash(mediaUrls),
      const DeepCollectionEquality().hash(thumbnailUrls),
      primaryMediaType,
      mediaCount,
      photoCount,
      videoCount,
      likeCount,
      commentCount,
      const DeepCollectionEquality().hash(viewers),
      createdAt,
      canEdit,
      videoDuration);

  @override
  String toString() {
    return 'Feed(albumId: $albumId, authorName: $authorName, authorProfileImage: $authorProfileImage, content: $content, mediaUrls: $mediaUrls, thumbnailUrls: $thumbnailUrls, primaryMediaType: $primaryMediaType, mediaCount: $mediaCount, photoCount: $photoCount, videoCount: $videoCount, likeCount: $likeCount, commentCount: $commentCount, viewers: $viewers, createdAt: $createdAt, canEdit: $canEdit, videoDuration: $videoDuration)';
  }
}

/// @nodoc
abstract mixin class $FeedCopyWith<$Res> {
  factory $FeedCopyWith(Feed value, $Res Function(Feed) _then) =
      _$FeedCopyWithImpl;
  @useResult
  $Res call(
      {int albumId,
      String authorName,
      String? authorProfileImage,
      String content,
      List<String> mediaUrls,
      List<String> thumbnailUrls,
      String? primaryMediaType,
      int mediaCount,
      int photoCount,
      int videoCount,
      int likeCount,
      int commentCount,
      List<Viewer> viewers,
      DateTime createdAt,
      bool canEdit,
      String? videoDuration});
}

/// @nodoc
class _$FeedCopyWithImpl<$Res> implements $FeedCopyWith<$Res> {
  _$FeedCopyWithImpl(this._self, this._then);

  final Feed _self;
  final $Res Function(Feed) _then;

  /// Create a copy of Feed
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
    Object? primaryMediaType = freezed,
    Object? mediaCount = null,
    Object? photoCount = null,
    Object? videoCount = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? viewers = null,
    Object? createdAt = null,
    Object? canEdit = null,
    Object? videoDuration = freezed,
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
      primaryMediaType: freezed == primaryMediaType
          ? _self.primaryMediaType
          : primaryMediaType // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaCount: null == mediaCount
          ? _self.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
      photoCount: null == photoCount
          ? _self.photoCount
          : photoCount // ignore: cast_nullable_to_non_nullable
              as int,
      videoCount: null == videoCount
          ? _self.videoCount
          : videoCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewers: null == viewers
          ? _self.viewers
          : viewers // ignore: cast_nullable_to_non_nullable
              as List<Viewer>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      canEdit: null == canEdit
          ? _self.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      videoDuration: freezed == videoDuration
          ? _self.videoDuration
          : videoDuration // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Feed].
extension FeedPatterns on Feed {
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
    TResult Function(_Feed value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Feed() when $default != null:
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
    TResult Function(_Feed value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Feed():
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
    TResult? Function(_Feed value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Feed() when $default != null:
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
            String? primaryMediaType,
            int mediaCount,
            int photoCount,
            int videoCount,
            int likeCount,
            int commentCount,
            List<Viewer> viewers,
            DateTime createdAt,
            bool canEdit,
            String? videoDuration)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Feed() when $default != null:
        return $default(
            _that.albumId,
            _that.authorName,
            _that.authorProfileImage,
            _that.content,
            _that.mediaUrls,
            _that.thumbnailUrls,
            _that.primaryMediaType,
            _that.mediaCount,
            _that.photoCount,
            _that.videoCount,
            _that.likeCount,
            _that.commentCount,
            _that.viewers,
            _that.createdAt,
            _that.canEdit,
            _that.videoDuration);
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
            String? primaryMediaType,
            int mediaCount,
            int photoCount,
            int videoCount,
            int likeCount,
            int commentCount,
            List<Viewer> viewers,
            DateTime createdAt,
            bool canEdit,
            String? videoDuration)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Feed():
        return $default(
            _that.albumId,
            _that.authorName,
            _that.authorProfileImage,
            _that.content,
            _that.mediaUrls,
            _that.thumbnailUrls,
            _that.primaryMediaType,
            _that.mediaCount,
            _that.photoCount,
            _that.videoCount,
            _that.likeCount,
            _that.commentCount,
            _that.viewers,
            _that.createdAt,
            _that.canEdit,
            _that.videoDuration);
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
            String? primaryMediaType,
            int mediaCount,
            int photoCount,
            int videoCount,
            int likeCount,
            int commentCount,
            List<Viewer> viewers,
            DateTime createdAt,
            bool canEdit,
            String? videoDuration)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Feed() when $default != null:
        return $default(
            _that.albumId,
            _that.authorName,
            _that.authorProfileImage,
            _that.content,
            _that.mediaUrls,
            _that.thumbnailUrls,
            _that.primaryMediaType,
            _that.mediaCount,
            _that.photoCount,
            _that.videoCount,
            _that.likeCount,
            _that.commentCount,
            _that.viewers,
            _that.createdAt,
            _that.canEdit,
            _that.videoDuration);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Feed implements Feed {
  const _Feed(
      {required this.albumId,
      required this.authorName,
      this.authorProfileImage,
      required this.content,
      required final List<String> mediaUrls,
      required final List<String> thumbnailUrls,
      required this.primaryMediaType,
      required this.mediaCount,
      required this.photoCount,
      required this.videoCount,
      required this.likeCount,
      required this.commentCount,
      required final List<Viewer> viewers,
      required this.createdAt,
      required this.canEdit,
      this.videoDuration})
      : _mediaUrls = mediaUrls,
        _thumbnailUrls = thumbnailUrls,
        _viewers = viewers;
  factory _Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

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

  @override
  final String? primaryMediaType;
  @override
  final int mediaCount;
  @override
  final int photoCount;
  @override
  final int videoCount;
  @override
  final int likeCount;
  @override
  final int commentCount;
  final List<Viewer> _viewers;
  @override
  List<Viewer> get viewers {
    if (_viewers is EqualUnmodifiableListView) return _viewers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viewers);
  }

  @override
  final DateTime createdAt;
  @override
  final bool canEdit;
  @override
  final String? videoDuration;

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedCopyWith<_Feed> get copyWith =>
      __$FeedCopyWithImpl<_Feed>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FeedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Feed &&
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
            (identical(other.primaryMediaType, primaryMediaType) ||
                other.primaryMediaType == primaryMediaType) &&
            (identical(other.mediaCount, mediaCount) ||
                other.mediaCount == mediaCount) &&
            (identical(other.photoCount, photoCount) ||
                other.photoCount == photoCount) &&
            (identical(other.videoCount, videoCount) ||
                other.videoCount == videoCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            const DeepCollectionEquality().equals(other._viewers, _viewers) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            (identical(other.videoDuration, videoDuration) ||
                other.videoDuration == videoDuration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      albumId,
      authorName,
      authorProfileImage,
      content,
      const DeepCollectionEquality().hash(_mediaUrls),
      const DeepCollectionEquality().hash(_thumbnailUrls),
      primaryMediaType,
      mediaCount,
      photoCount,
      videoCount,
      likeCount,
      commentCount,
      const DeepCollectionEquality().hash(_viewers),
      createdAt,
      canEdit,
      videoDuration);

  @override
  String toString() {
    return 'Feed(albumId: $albumId, authorName: $authorName, authorProfileImage: $authorProfileImage, content: $content, mediaUrls: $mediaUrls, thumbnailUrls: $thumbnailUrls, primaryMediaType: $primaryMediaType, mediaCount: $mediaCount, photoCount: $photoCount, videoCount: $videoCount, likeCount: $likeCount, commentCount: $commentCount, viewers: $viewers, createdAt: $createdAt, canEdit: $canEdit, videoDuration: $videoDuration)';
  }
}

/// @nodoc
abstract mixin class _$FeedCopyWith<$Res> implements $FeedCopyWith<$Res> {
  factory _$FeedCopyWith(_Feed value, $Res Function(_Feed) _then) =
      __$FeedCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int albumId,
      String authorName,
      String? authorProfileImage,
      String content,
      List<String> mediaUrls,
      List<String> thumbnailUrls,
      String? primaryMediaType,
      int mediaCount,
      int photoCount,
      int videoCount,
      int likeCount,
      int commentCount,
      List<Viewer> viewers,
      DateTime createdAt,
      bool canEdit,
      String? videoDuration});
}

/// @nodoc
class __$FeedCopyWithImpl<$Res> implements _$FeedCopyWith<$Res> {
  __$FeedCopyWithImpl(this._self, this._then);

  final _Feed _self;
  final $Res Function(_Feed) _then;

  /// Create a copy of Feed
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
    Object? primaryMediaType = freezed,
    Object? mediaCount = null,
    Object? photoCount = null,
    Object? videoCount = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? viewers = null,
    Object? createdAt = null,
    Object? canEdit = null,
    Object? videoDuration = freezed,
  }) {
    return _then(_Feed(
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
      primaryMediaType: freezed == primaryMediaType
          ? _self.primaryMediaType
          : primaryMediaType // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaCount: null == mediaCount
          ? _self.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
      photoCount: null == photoCount
          ? _self.photoCount
          : photoCount // ignore: cast_nullable_to_non_nullable
              as int,
      videoCount: null == videoCount
          ? _self.videoCount
          : videoCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewers: null == viewers
          ? _self._viewers
          : viewers // ignore: cast_nullable_to_non_nullable
              as List<Viewer>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      canEdit: null == canEdit
          ? _self.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      videoDuration: freezed == videoDuration
          ? _self.videoDuration
          : videoDuration // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
