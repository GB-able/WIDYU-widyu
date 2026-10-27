// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_comment_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumCommentCreateRequest {
  String get content;
  int? get parentCommentId;

  /// Create a copy of AlbumCommentCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AlbumCommentCreateRequestCopyWith<AlbumCommentCreateRequest> get copyWith =>
      _$AlbumCommentCreateRequestCopyWithImpl<AlbumCommentCreateRequest>(
          this as AlbumCommentCreateRequest, _$identity);

  /// Serializes this AlbumCommentCreateRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AlbumCommentCreateRequest &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content, parentCommentId);

  @override
  String toString() {
    return 'AlbumCommentCreateRequest(content: $content, parentCommentId: $parentCommentId)';
  }
}

/// @nodoc
abstract mixin class $AlbumCommentCreateRequestCopyWith<$Res> {
  factory $AlbumCommentCreateRequestCopyWith(AlbumCommentCreateRequest value,
          $Res Function(AlbumCommentCreateRequest) _then) =
      _$AlbumCommentCreateRequestCopyWithImpl;
  @useResult
  $Res call({String content, int? parentCommentId});
}

/// @nodoc
class _$AlbumCommentCreateRequestCopyWithImpl<$Res>
    implements $AlbumCommentCreateRequestCopyWith<$Res> {
  _$AlbumCommentCreateRequestCopyWithImpl(this._self, this._then);

  final AlbumCommentCreateRequest _self;
  final $Res Function(AlbumCommentCreateRequest) _then;

  /// Create a copy of AlbumCommentCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? parentCommentId = freezed,
  }) {
    return _then(_self.copyWith(
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _self.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AlbumCommentCreateRequest].
extension AlbumCommentCreateRequestPatterns on AlbumCommentCreateRequest {
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
    TResult Function(_AlbumCommentCreateRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumCommentCreateRequest() when $default != null:
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
    TResult Function(_AlbumCommentCreateRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumCommentCreateRequest():
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
    TResult? Function(_AlbumCommentCreateRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumCommentCreateRequest() when $default != null:
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
    TResult Function(String content, int? parentCommentId)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumCommentCreateRequest() when $default != null:
        return $default(_that.content, _that.parentCommentId);
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
    TResult Function(String content, int? parentCommentId) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumCommentCreateRequest():
        return $default(_that.content, _that.parentCommentId);
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
    TResult? Function(String content, int? parentCommentId)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumCommentCreateRequest() when $default != null:
        return $default(_that.content, _that.parentCommentId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AlbumCommentCreateRequest implements AlbumCommentCreateRequest {
  const _AlbumCommentCreateRequest(
      {required this.content, this.parentCommentId});
  factory _AlbumCommentCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$AlbumCommentCreateRequestFromJson(json);

  @override
  final String content;
  @override
  final int? parentCommentId;

  /// Create a copy of AlbumCommentCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AlbumCommentCreateRequestCopyWith<_AlbumCommentCreateRequest>
      get copyWith =>
          __$AlbumCommentCreateRequestCopyWithImpl<_AlbumCommentCreateRequest>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AlbumCommentCreateRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AlbumCommentCreateRequest &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content, parentCommentId);

  @override
  String toString() {
    return 'AlbumCommentCreateRequest(content: $content, parentCommentId: $parentCommentId)';
  }
}

/// @nodoc
abstract mixin class _$AlbumCommentCreateRequestCopyWith<$Res>
    implements $AlbumCommentCreateRequestCopyWith<$Res> {
  factory _$AlbumCommentCreateRequestCopyWith(_AlbumCommentCreateRequest value,
          $Res Function(_AlbumCommentCreateRequest) _then) =
      __$AlbumCommentCreateRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String content, int? parentCommentId});
}

/// @nodoc
class __$AlbumCommentCreateRequestCopyWithImpl<$Res>
    implements _$AlbumCommentCreateRequestCopyWith<$Res> {
  __$AlbumCommentCreateRequestCopyWithImpl(this._self, this._then);

  final _AlbumCommentCreateRequest _self;
  final $Res Function(_AlbumCommentCreateRequest) _then;

  /// Create a copy of AlbumCommentCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? content = null,
    Object? parentCommentId = freezed,
  }) {
    return _then(_AlbumCommentCreateRequest(
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _self.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
