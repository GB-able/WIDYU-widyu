// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedDetail {
  @JsonKey(name: 'postId')
  int get albumId;
  String get content;
  List<String> get mediaUrls;
  int get likeCount;
  int get commentCount;
  int get viewCount;
  int? get price;
  Member get author;
  List<Viewer> get viewers;
  List<Comment> get comments;
  DateTime get createdAt;
  bool get canEdit;

  /// Create a copy of FeedDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedDetailCopyWith<FeedDetail> get copyWith =>
      _$FeedDetailCopyWithImpl<FeedDetail>(this as FeedDetail, _$identity);

  /// Serializes this FeedDetail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedDetail &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other.mediaUrls, mediaUrls) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality().equals(other.viewers, viewers) &&
            const DeepCollectionEquality().equals(other.comments, comments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      albumId,
      content,
      const DeepCollectionEquality().hash(mediaUrls),
      likeCount,
      commentCount,
      viewCount,
      price,
      author,
      const DeepCollectionEquality().hash(viewers),
      const DeepCollectionEquality().hash(comments),
      createdAt,
      canEdit);

  @override
  String toString() {
    return 'FeedDetail(albumId: $albumId, content: $content, mediaUrls: $mediaUrls, likeCount: $likeCount, commentCount: $commentCount, viewCount: $viewCount, price: $price, author: $author, viewers: $viewers, comments: $comments, createdAt: $createdAt, canEdit: $canEdit)';
  }
}

/// @nodoc
abstract mixin class $FeedDetailCopyWith<$Res> {
  factory $FeedDetailCopyWith(
          FeedDetail value, $Res Function(FeedDetail) _then) =
      _$FeedDetailCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'postId') int albumId,
      String content,
      List<String> mediaUrls,
      int likeCount,
      int commentCount,
      int viewCount,
      int? price,
      Member author,
      List<Viewer> viewers,
      List<Comment> comments,
      DateTime createdAt,
      bool canEdit});

  $MemberCopyWith<$Res> get author;
}

/// @nodoc
class _$FeedDetailCopyWithImpl<$Res> implements $FeedDetailCopyWith<$Res> {
  _$FeedDetailCopyWithImpl(this._self, this._then);

  final FeedDetail _self;
  final $Res Function(FeedDetail) _then;

  /// Create a copy of FeedDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? albumId = null,
    Object? content = null,
    Object? mediaUrls = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? viewCount = null,
    Object? price = freezed,
    Object? author = null,
    Object? viewers = null,
    Object? comments = null,
    Object? createdAt = null,
    Object? canEdit = null,
  }) {
    return _then(_self.copyWith(
      albumId: null == albumId
          ? _self.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrls: null == mediaUrls
          ? _self.mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _self.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as Member,
      viewers: null == viewers
          ? _self.viewers
          : viewers // ignore: cast_nullable_to_non_nullable
              as List<Viewer>,
      comments: null == comments
          ? _self.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      canEdit: null == canEdit
          ? _self.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of FeedDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberCopyWith<$Res> get author {
    return $MemberCopyWith<$Res>(_self.author, (value) {
      return _then(_self.copyWith(author: value));
    });
  }
}

/// Adds pattern-matching-related methods to [FeedDetail].
extension FeedDetailPatterns on FeedDetail {
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
    TResult Function(_FeedDetail value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedDetail() when $default != null:
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
    TResult Function(_FeedDetail value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedDetail():
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
    TResult? Function(_FeedDetail value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedDetail() when $default != null:
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
            @JsonKey(name: 'postId') int albumId,
            String content,
            List<String> mediaUrls,
            int likeCount,
            int commentCount,
            int viewCount,
            int? price,
            Member author,
            List<Viewer> viewers,
            List<Comment> comments,
            DateTime createdAt,
            bool canEdit)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedDetail() when $default != null:
        return $default(
            _that.albumId,
            _that.content,
            _that.mediaUrls,
            _that.likeCount,
            _that.commentCount,
            _that.viewCount,
            _that.price,
            _that.author,
            _that.viewers,
            _that.comments,
            _that.createdAt,
            _that.canEdit);
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
            @JsonKey(name: 'postId') int albumId,
            String content,
            List<String> mediaUrls,
            int likeCount,
            int commentCount,
            int viewCount,
            int? price,
            Member author,
            List<Viewer> viewers,
            List<Comment> comments,
            DateTime createdAt,
            bool canEdit)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedDetail():
        return $default(
            _that.albumId,
            _that.content,
            _that.mediaUrls,
            _that.likeCount,
            _that.commentCount,
            _that.viewCount,
            _that.price,
            _that.author,
            _that.viewers,
            _that.comments,
            _that.createdAt,
            _that.canEdit);
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
            @JsonKey(name: 'postId') int albumId,
            String content,
            List<String> mediaUrls,
            int likeCount,
            int commentCount,
            int viewCount,
            int? price,
            Member author,
            List<Viewer> viewers,
            List<Comment> comments,
            DateTime createdAt,
            bool canEdit)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedDetail() when $default != null:
        return $default(
            _that.albumId,
            _that.content,
            _that.mediaUrls,
            _that.likeCount,
            _that.commentCount,
            _that.viewCount,
            _that.price,
            _that.author,
            _that.viewers,
            _that.comments,
            _that.createdAt,
            _that.canEdit);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FeedDetail extends FeedDetail {
  const _FeedDetail(
      {@JsonKey(name: 'postId') required this.albumId,
      required this.content,
      required final List<String> mediaUrls,
      required this.likeCount,
      required this.commentCount,
      this.viewCount = 0,
      this.price,
      required this.author,
      final List<Viewer> viewers = const [],
      final List<Comment> comments = const [],
      required this.createdAt,
      required this.canEdit})
      : _mediaUrls = mediaUrls,
        _viewers = viewers,
        _comments = comments,
        super._();
  factory _FeedDetail.fromJson(Map<String, dynamic> json) =>
      _$FeedDetailFromJson(json);

  @override
  @JsonKey(name: 'postId')
  final int albumId;
  @override
  final String content;
  final List<String> _mediaUrls;
  @override
  List<String> get mediaUrls {
    if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaUrls);
  }

  @override
  final int likeCount;
  @override
  final int commentCount;
  @override
  @JsonKey()
  final int viewCount;
  @override
  final int? price;
  @override
  final Member author;
  final List<Viewer> _viewers;
  @override
  @JsonKey()
  List<Viewer> get viewers {
    if (_viewers is EqualUnmodifiableListView) return _viewers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viewers);
  }

  final List<Comment> _comments;
  @override
  @JsonKey()
  List<Comment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  final DateTime createdAt;
  @override
  final bool canEdit;

  /// Create a copy of FeedDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedDetailCopyWith<_FeedDetail> get copyWith =>
      __$FeedDetailCopyWithImpl<_FeedDetail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FeedDetailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedDetail &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._mediaUrls, _mediaUrls) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality().equals(other._viewers, _viewers) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      albumId,
      content,
      const DeepCollectionEquality().hash(_mediaUrls),
      likeCount,
      commentCount,
      viewCount,
      price,
      author,
      const DeepCollectionEquality().hash(_viewers),
      const DeepCollectionEquality().hash(_comments),
      createdAt,
      canEdit);

  @override
  String toString() {
    return 'FeedDetail(albumId: $albumId, content: $content, mediaUrls: $mediaUrls, likeCount: $likeCount, commentCount: $commentCount, viewCount: $viewCount, price: $price, author: $author, viewers: $viewers, comments: $comments, createdAt: $createdAt, canEdit: $canEdit)';
  }
}

/// @nodoc
abstract mixin class _$FeedDetailCopyWith<$Res>
    implements $FeedDetailCopyWith<$Res> {
  factory _$FeedDetailCopyWith(
          _FeedDetail value, $Res Function(_FeedDetail) _then) =
      __$FeedDetailCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'postId') int albumId,
      String content,
      List<String> mediaUrls,
      int likeCount,
      int commentCount,
      int viewCount,
      int? price,
      Member author,
      List<Viewer> viewers,
      List<Comment> comments,
      DateTime createdAt,
      bool canEdit});

  @override
  $MemberCopyWith<$Res> get author;
}

/// @nodoc
class __$FeedDetailCopyWithImpl<$Res> implements _$FeedDetailCopyWith<$Res> {
  __$FeedDetailCopyWithImpl(this._self, this._then);

  final _FeedDetail _self;
  final $Res Function(_FeedDetail) _then;

  /// Create a copy of FeedDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? albumId = null,
    Object? content = null,
    Object? mediaUrls = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? viewCount = null,
    Object? price = freezed,
    Object? author = null,
    Object? viewers = null,
    Object? comments = null,
    Object? createdAt = null,
    Object? canEdit = null,
  }) {
    return _then(_FeedDetail(
      albumId: null == albumId
          ? _self.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrls: null == mediaUrls
          ? _self._mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _self.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as Member,
      viewers: null == viewers
          ? _self._viewers
          : viewers // ignore: cast_nullable_to_non_nullable
              as List<Viewer>,
      comments: null == comments
          ? _self._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      canEdit: null == canEdit
          ? _self.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of FeedDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberCopyWith<$Res> get author {
    return $MemberCopyWith<$Res>(_self.author, (value) {
      return _then(_self.copyWith(author: value));
    });
  }
}

// dart format on
