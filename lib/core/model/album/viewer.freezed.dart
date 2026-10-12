// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'viewer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Viewer {
  @JsonKey(name: 'memberId')
  int? get id;
  String get name;
  String? get profileImage;

  /// Create a copy of Viewer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ViewerCopyWith<Viewer> get copyWith =>
      _$ViewerCopyWithImpl<Viewer>(this as Viewer, _$identity);

  /// Serializes this Viewer to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Viewer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, profileImage);

  @override
  String toString() {
    return 'Viewer(id: $id, name: $name, profileImage: $profileImage)';
  }
}

/// @nodoc
abstract mixin class $ViewerCopyWith<$Res> {
  factory $ViewerCopyWith(Viewer value, $Res Function(Viewer) _then) =
      _$ViewerCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'memberId') int? id, String name, String? profileImage});
}

/// @nodoc
class _$ViewerCopyWithImpl<$Res> implements $ViewerCopyWith<$Res> {
  _$ViewerCopyWithImpl(this._self, this._then);

  final Viewer _self;
  final $Res Function(Viewer) _then;

  /// Create a copy of Viewer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Viewer].
extension ViewerPatterns on Viewer {
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
    TResult Function(_Viewer value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Viewer() when $default != null:
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
    TResult Function(_Viewer value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Viewer():
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
    TResult? Function(_Viewer value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Viewer() when $default != null:
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
    TResult Function(@JsonKey(name: 'memberId') int? id, String name,
            String? profileImage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Viewer() when $default != null:
        return $default(_that.id, _that.name, _that.profileImage);
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
    TResult Function(@JsonKey(name: 'memberId') int? id, String name,
            String? profileImage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Viewer():
        return $default(_that.id, _that.name, _that.profileImage);
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
    TResult? Function(@JsonKey(name: 'memberId') int? id, String name,
            String? profileImage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Viewer() when $default != null:
        return $default(_that.id, _that.name, _that.profileImage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Viewer implements Viewer {
  const _Viewer(
      {@JsonKey(name: 'memberId') this.id,
      required this.name,
      this.profileImage});
  factory _Viewer.fromJson(Map<String, dynamic> json) => _$ViewerFromJson(json);

  @override
  @JsonKey(name: 'memberId')
  final int? id;
  @override
  final String name;
  @override
  final String? profileImage;

  /// Create a copy of Viewer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ViewerCopyWith<_Viewer> get copyWith =>
      __$ViewerCopyWithImpl<_Viewer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ViewerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Viewer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, profileImage);

  @override
  String toString() {
    return 'Viewer(id: $id, name: $name, profileImage: $profileImage)';
  }
}

/// @nodoc
abstract mixin class _$ViewerCopyWith<$Res> implements $ViewerCopyWith<$Res> {
  factory _$ViewerCopyWith(_Viewer value, $Res Function(_Viewer) _then) =
      __$ViewerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'memberId') int? id, String name, String? profileImage});
}

/// @nodoc
class __$ViewerCopyWithImpl<$Res> implements _$ViewerCopyWith<$Res> {
  __$ViewerCopyWithImpl(this._self, this._then);

  final _Viewer _self;
  final $Res Function(_Viewer) _then;

  /// Create a copy of Viewer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(_Viewer(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
