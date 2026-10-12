// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Comment {
  int get commentId;
  String get content;
  DateTime get createdAt;
  Member get author;
  bool get canEdit;
  List<Comment>? get replies;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommentCopyWith<Comment> get copyWith =>
      _$CommentCopyWithImpl<Comment>(this as Comment, _$identity);

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Comment &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            const DeepCollectionEquality().equals(other.replies, replies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, commentId, content, createdAt,
      author, canEdit, const DeepCollectionEquality().hash(replies));

  @override
  String toString() {
    return 'Comment(commentId: $commentId, content: $content, createdAt: $createdAt, author: $author, canEdit: $canEdit, replies: $replies)';
  }
}

/// @nodoc
abstract mixin class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) _then) =
      _$CommentCopyWithImpl;
  @useResult
  $Res call(
      {int commentId,
      String content,
      DateTime createdAt,
      Member author,
      bool canEdit,
      List<Comment>? replies});

  $MemberCopyWith<$Res> get author;
}

/// @nodoc
class _$CommentCopyWithImpl<$Res> implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._self, this._then);

  final Comment _self;
  final $Res Function(Comment) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? content = null,
    Object? createdAt = null,
    Object? author = null,
    Object? canEdit = null,
    Object? replies = freezed,
  }) {
    return _then(_self.copyWith(
      commentId: null == commentId
          ? _self.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as Member,
      canEdit: null == canEdit
          ? _self.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      replies: freezed == replies
          ? _self.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>?,
    ));
  }

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberCopyWith<$Res> get author {
    return $MemberCopyWith<$Res>(_self.author, (value) {
      return _then(_self.copyWith(author: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Comment].
extension CommentPatterns on Comment {
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
    TResult Function(_Comment value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Comment() when $default != null:
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
    TResult Function(_Comment value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Comment():
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
    TResult? Function(_Comment value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Comment() when $default != null:
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
    TResult Function(int commentId, String content, DateTime createdAt,
            Member author, bool canEdit, List<Comment>? replies)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Comment() when $default != null:
        return $default(_that.commentId, _that.content, _that.createdAt,
            _that.author, _that.canEdit, _that.replies);
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
    TResult Function(int commentId, String content, DateTime createdAt,
            Member author, bool canEdit, List<Comment>? replies)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Comment():
        return $default(_that.commentId, _that.content, _that.createdAt,
            _that.author, _that.canEdit, _that.replies);
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
    TResult? Function(int commentId, String content, DateTime createdAt,
            Member author, bool canEdit, List<Comment>? replies)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Comment() when $default != null:
        return $default(_that.commentId, _that.content, _that.createdAt,
            _that.author, _that.canEdit, _that.replies);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Comment implements Comment {
  const _Comment(
      {required this.commentId,
      required this.content,
      required this.createdAt,
      required this.author,
      required this.canEdit,
      final List<Comment>? replies})
      : _replies = replies;
  factory _Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  @override
  final int commentId;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final Member author;
  @override
  final bool canEdit;
  final List<Comment>? _replies;
  @override
  List<Comment>? get replies {
    final value = _replies;
    if (value == null) return null;
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CommentCopyWith<_Comment> get copyWith =>
      __$CommentCopyWithImpl<_Comment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CommentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Comment &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, commentId, content, createdAt,
      author, canEdit, const DeepCollectionEquality().hash(_replies));

  @override
  String toString() {
    return 'Comment(commentId: $commentId, content: $content, createdAt: $createdAt, author: $author, canEdit: $canEdit, replies: $replies)';
  }
}

/// @nodoc
abstract mixin class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) _then) =
      __$CommentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int commentId,
      String content,
      DateTime createdAt,
      Member author,
      bool canEdit,
      List<Comment>? replies});

  @override
  $MemberCopyWith<$Res> get author;
}

/// @nodoc
class __$CommentCopyWithImpl<$Res> implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(this._self, this._then);

  final _Comment _self;
  final $Res Function(_Comment) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? commentId = null,
    Object? content = null,
    Object? createdAt = null,
    Object? author = null,
    Object? canEdit = null,
    Object? replies = freezed,
  }) {
    return _then(_Comment(
      commentId: null == commentId
          ? _self.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as Member,
      canEdit: null == canEdit
          ? _self.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      replies: freezed == replies
          ? _self._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>?,
    ));
  }

  /// Create a copy of Comment
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
