// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostUiState {
  PostStatus get status;
  bool get isBusy;
  FeedDetail? get feed;
  User? get me;
  int? get replyParentId;
  int? get editingCommentId;

  /// Create a copy of PostUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostUiStateCopyWith<PostUiState> get copyWith =>
      _$PostUiStateCopyWithImpl<PostUiState>(this as PostUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostUiState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.feed, feed) || other.feed == feed) &&
            (identical(other.me, me) || other.me == me) &&
            (identical(other.replyParentId, replyParentId) ||
                other.replyParentId == replyParentId) &&
            (identical(other.editingCommentId, editingCommentId) ||
                other.editingCommentId == editingCommentId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, status, isBusy, feed, me, replyParentId, editingCommentId);

  @override
  String toString() {
    return 'PostUiState(status: $status, isBusy: $isBusy, feed: $feed, me: $me, replyParentId: $replyParentId, editingCommentId: $editingCommentId)';
  }
}

/// @nodoc
abstract mixin class $PostUiStateCopyWith<$Res> {
  factory $PostUiStateCopyWith(
          PostUiState value, $Res Function(PostUiState) _then) =
      _$PostUiStateCopyWithImpl;
  @useResult
  $Res call(
      {PostStatus status,
      bool isBusy,
      FeedDetail? feed,
      User? me,
      int? replyParentId,
      int? editingCommentId});

  $FeedDetailCopyWith<$Res>? get feed;
  $UserCopyWith<$Res>? get me;
}

/// @nodoc
class _$PostUiStateCopyWithImpl<$Res> implements $PostUiStateCopyWith<$Res> {
  _$PostUiStateCopyWithImpl(this._self, this._then);

  final PostUiState _self;
  final $Res Function(PostUiState) _then;

  /// Create a copy of PostUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isBusy = null,
    Object? feed = freezed,
    Object? me = freezed,
    Object? replyParentId = freezed,
    Object? editingCommentId = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PostStatus,
      isBusy: null == isBusy
          ? _self.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      feed: freezed == feed
          ? _self.feed
          : feed // ignore: cast_nullable_to_non_nullable
              as FeedDetail?,
      me: freezed == me
          ? _self.me
          : me // ignore: cast_nullable_to_non_nullable
              as User?,
      replyParentId: freezed == replyParentId
          ? _self.replyParentId
          : replyParentId // ignore: cast_nullable_to_non_nullable
              as int?,
      editingCommentId: freezed == editingCommentId
          ? _self.editingCommentId
          : editingCommentId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of PostUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeedDetailCopyWith<$Res>? get feed {
    if (_self.feed == null) {
      return null;
    }

    return $FeedDetailCopyWith<$Res>(_self.feed!, (value) {
      return _then(_self.copyWith(feed: value));
    });
  }

  /// Create a copy of PostUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get me {
    if (_self.me == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.me!, (value) {
      return _then(_self.copyWith(me: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PostUiState].
extension PostUiStatePatterns on PostUiState {
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
    TResult Function(_PostUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostUiState() when $default != null:
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
    TResult Function(_PostUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostUiState():
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
    TResult? Function(_PostUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostUiState() when $default != null:
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
    TResult Function(PostStatus status, bool isBusy, FeedDetail? feed, User? me,
            int? replyParentId, int? editingCommentId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostUiState() when $default != null:
        return $default(_that.status, _that.isBusy, _that.feed, _that.me,
            _that.replyParentId, _that.editingCommentId);
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
    TResult Function(PostStatus status, bool isBusy, FeedDetail? feed, User? me,
            int? replyParentId, int? editingCommentId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostUiState():
        return $default(_that.status, _that.isBusy, _that.feed, _that.me,
            _that.replyParentId, _that.editingCommentId);
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
    TResult? Function(PostStatus status, bool isBusy, FeedDetail? feed,
            User? me, int? replyParentId, int? editingCommentId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostUiState() when $default != null:
        return $default(_that.status, _that.isBusy, _that.feed, _that.me,
            _that.replyParentId, _that.editingCommentId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PostUiState implements PostUiState {
  const _PostUiState(
      {this.status = PostStatus.loading,
      this.isBusy = false,
      this.feed,
      this.me,
      this.replyParentId,
      this.editingCommentId});

  @override
  @JsonKey()
  final PostStatus status;
  @override
  @JsonKey()
  final bool isBusy;
  @override
  final FeedDetail? feed;
  @override
  final User? me;
  @override
  final int? replyParentId;
  @override
  final int? editingCommentId;

  /// Create a copy of PostUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostUiStateCopyWith<_PostUiState> get copyWith =>
      __$PostUiStateCopyWithImpl<_PostUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostUiState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.feed, feed) || other.feed == feed) &&
            (identical(other.me, me) || other.me == me) &&
            (identical(other.replyParentId, replyParentId) ||
                other.replyParentId == replyParentId) &&
            (identical(other.editingCommentId, editingCommentId) ||
                other.editingCommentId == editingCommentId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, status, isBusy, feed, me, replyParentId, editingCommentId);

  @override
  String toString() {
    return 'PostUiState(status: $status, isBusy: $isBusy, feed: $feed, me: $me, replyParentId: $replyParentId, editingCommentId: $editingCommentId)';
  }
}

/// @nodoc
abstract mixin class _$PostUiStateCopyWith<$Res>
    implements $PostUiStateCopyWith<$Res> {
  factory _$PostUiStateCopyWith(
          _PostUiState value, $Res Function(_PostUiState) _then) =
      __$PostUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {PostStatus status,
      bool isBusy,
      FeedDetail? feed,
      User? me,
      int? replyParentId,
      int? editingCommentId});

  @override
  $FeedDetailCopyWith<$Res>? get feed;
  @override
  $UserCopyWith<$Res>? get me;
}

/// @nodoc
class __$PostUiStateCopyWithImpl<$Res> implements _$PostUiStateCopyWith<$Res> {
  __$PostUiStateCopyWithImpl(this._self, this._then);

  final _PostUiState _self;
  final $Res Function(_PostUiState) _then;

  /// Create a copy of PostUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? isBusy = null,
    Object? feed = freezed,
    Object? me = freezed,
    Object? replyParentId = freezed,
    Object? editingCommentId = freezed,
  }) {
    return _then(_PostUiState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PostStatus,
      isBusy: null == isBusy
          ? _self.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      feed: freezed == feed
          ? _self.feed
          : feed // ignore: cast_nullable_to_non_nullable
              as FeedDetail?,
      me: freezed == me
          ? _self.me
          : me // ignore: cast_nullable_to_non_nullable
              as User?,
      replyParentId: freezed == replyParentId
          ? _self.replyParentId
          : replyParentId // ignore: cast_nullable_to_non_nullable
              as int?,
      editingCommentId: freezed == editingCommentId
          ? _self.editingCommentId
          : editingCommentId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of PostUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeedDetailCopyWith<$Res>? get feed {
    if (_self.feed == null) {
      return null;
    }

    return $FeedDetailCopyWith<$Res>(_self.feed!, (value) {
      return _then(_self.copyWith(feed: value));
    });
  }

  /// Create a copy of PostUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get me {
    if (_self.me == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.me!, (value) {
      return _then(_self.copyWith(me: value));
    });
  }
}

// dart format on
