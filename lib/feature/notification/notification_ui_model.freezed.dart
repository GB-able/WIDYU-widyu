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
mixin _$NotificationUiModel {
  NotificationGroup get group;
  bool get enabled;
  bool get isUpdating;

  /// Create a copy of NotificationUiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationUiModelCopyWith<NotificationUiModel> get copyWith =>
      _$NotificationUiModelCopyWithImpl<NotificationUiModel>(
          this as NotificationUiModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationUiModel &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating));
  }

  @override
  int get hashCode => Object.hash(runtimeType, group, enabled, isUpdating);

  @override
  String toString() {
    return 'NotificationUiModel(group: $group, enabled: $enabled, isUpdating: $isUpdating)';
  }
}

/// @nodoc
abstract mixin class $NotificationUiModelCopyWith<$Res> {
  factory $NotificationUiModelCopyWith(
          NotificationUiModel value, $Res Function(NotificationUiModel) _then) =
      _$NotificationUiModelCopyWithImpl;
  @useResult
  $Res call({NotificationGroup group, bool enabled, bool isUpdating});
}

/// @nodoc
class _$NotificationUiModelCopyWithImpl<$Res>
    implements $NotificationUiModelCopyWith<$Res> {
  _$NotificationUiModelCopyWithImpl(this._self, this._then);

  final NotificationUiModel _self;
  final $Res Function(NotificationUiModel) _then;

  /// Create a copy of NotificationUiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = null,
    Object? enabled = null,
    Object? isUpdating = null,
  }) {
    return _then(_self.copyWith(
      group: null == group
          ? _self.group
          : group // ignore: cast_nullable_to_non_nullable
              as NotificationGroup,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _self.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationUiModel].
extension NotificationUiModelPatterns on NotificationUiModel {
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
    TResult Function(_NotificationUiModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationUiModel() when $default != null:
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
    TResult Function(_NotificationUiModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationUiModel():
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
    TResult? Function(_NotificationUiModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationUiModel() when $default != null:
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
    TResult Function(NotificationGroup group, bool enabled, bool isUpdating)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationUiModel() when $default != null:
        return $default(_that.group, _that.enabled, _that.isUpdating);
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
    TResult Function(NotificationGroup group, bool enabled, bool isUpdating)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationUiModel():
        return $default(_that.group, _that.enabled, _that.isUpdating);
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
    TResult? Function(NotificationGroup group, bool enabled, bool isUpdating)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationUiModel() when $default != null:
        return $default(_that.group, _that.enabled, _that.isUpdating);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _NotificationUiModel implements NotificationUiModel {
  const _NotificationUiModel(
      {required this.group, required this.enabled, this.isUpdating = false});

  @override
  final NotificationGroup group;
  @override
  final bool enabled;
  @override
  @JsonKey()
  final bool isUpdating;

  /// Create a copy of NotificationUiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationUiModelCopyWith<_NotificationUiModel> get copyWith =>
      __$NotificationUiModelCopyWithImpl<_NotificationUiModel>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationUiModel &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating));
  }

  @override
  int get hashCode => Object.hash(runtimeType, group, enabled, isUpdating);

  @override
  String toString() {
    return 'NotificationUiModel(group: $group, enabled: $enabled, isUpdating: $isUpdating)';
  }
}

/// @nodoc
abstract mixin class _$NotificationUiModelCopyWith<$Res>
    implements $NotificationUiModelCopyWith<$Res> {
  factory _$NotificationUiModelCopyWith(_NotificationUiModel value,
          $Res Function(_NotificationUiModel) _then) =
      __$NotificationUiModelCopyWithImpl;
  @override
  @useResult
  $Res call({NotificationGroup group, bool enabled, bool isUpdating});
}

/// @nodoc
class __$NotificationUiModelCopyWithImpl<$Res>
    implements _$NotificationUiModelCopyWith<$Res> {
  __$NotificationUiModelCopyWithImpl(this._self, this._then);

  final _NotificationUiModel _self;
  final $Res Function(_NotificationUiModel) _then;

  /// Create a copy of NotificationUiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? group = null,
    Object? enabled = null,
    Object? isUpdating = null,
  }) {
    return _then(_NotificationUiModel(
      group: null == group
          ? _self.group
          : group // ignore: cast_nullable_to_non_nullable
              as NotificationGroup,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _self.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
