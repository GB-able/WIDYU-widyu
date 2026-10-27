// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_setting_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSettingUiState {
  bool get isLoading;
  List<NotificationSettingUiModel> get notifications;
  int get policyRevision;

  /// Create a copy of NotificationSettingUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationSettingUiStateCopyWith<NotificationSettingUiState>
      get copyWith =>
          _$NotificationSettingUiStateCopyWithImpl<NotificationSettingUiState>(
              this as NotificationSettingUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationSettingUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other.notifications, notifications) &&
            (identical(other.policyRevision, policyRevision) ||
                other.policyRevision == policyRevision));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(notifications), policyRevision);

  @override
  String toString() {
    return 'NotificationSettingUiState(isLoading: $isLoading, notifications: $notifications, policyRevision: $policyRevision)';
  }
}

/// @nodoc
abstract mixin class $NotificationSettingUiStateCopyWith<$Res> {
  factory $NotificationSettingUiStateCopyWith(NotificationSettingUiState value,
          $Res Function(NotificationSettingUiState) _then) =
      _$NotificationSettingUiStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      List<NotificationSettingUiModel> notifications,
      int policyRevision});
}

/// @nodoc
class _$NotificationSettingUiStateCopyWithImpl<$Res>
    implements $NotificationSettingUiStateCopyWith<$Res> {
  _$NotificationSettingUiStateCopyWithImpl(this._self, this._then);

  final NotificationSettingUiState _self;
  final $Res Function(NotificationSettingUiState) _then;

  /// Create a copy of NotificationSettingUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? notifications = null,
    Object? policyRevision = null,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      notifications: null == notifications
          ? _self.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationSettingUiModel>,
      policyRevision: null == policyRevision
          ? _self.policyRevision
          : policyRevision // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationSettingUiState].
extension NotificationSettingUiStatePatterns on NotificationSettingUiState {
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
    TResult Function(_NotificationSettingUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationSettingUiState() when $default != null:
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
    TResult Function(_NotificationSettingUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationSettingUiState():
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
    TResult? Function(_NotificationSettingUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationSettingUiState() when $default != null:
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
    TResult Function(bool isLoading,
            List<NotificationSettingUiModel> notifications, int policyRevision)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationSettingUiState() when $default != null:
        return $default(
            _that.isLoading, _that.notifications, _that.policyRevision);
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
    TResult Function(bool isLoading,
            List<NotificationSettingUiModel> notifications, int policyRevision)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationSettingUiState():
        return $default(
            _that.isLoading, _that.notifications, _that.policyRevision);
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
    TResult? Function(bool isLoading,
            List<NotificationSettingUiModel> notifications, int policyRevision)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationSettingUiState() when $default != null:
        return $default(
            _that.isLoading, _that.notifications, _that.policyRevision);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _NotificationSettingUiState implements NotificationSettingUiState {
  const _NotificationSettingUiState(
      {this.isLoading = false,
      final List<NotificationSettingUiModel> notifications = const [],
      this.policyRevision = 0})
      : _notifications = notifications;

  @override
  @JsonKey()
  final bool isLoading;
  final List<NotificationSettingUiModel> _notifications;
  @override
  @JsonKey()
  List<NotificationSettingUiModel> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  @JsonKey()
  final int policyRevision;

  /// Create a copy of NotificationSettingUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationSettingUiStateCopyWith<_NotificationSettingUiState>
      get copyWith => __$NotificationSettingUiStateCopyWithImpl<
          _NotificationSettingUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationSettingUiState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications) &&
            (identical(other.policyRevision, policyRevision) ||
                other.policyRevision == policyRevision));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_notifications), policyRevision);

  @override
  String toString() {
    return 'NotificationSettingUiState(isLoading: $isLoading, notifications: $notifications, policyRevision: $policyRevision)';
  }
}

/// @nodoc
abstract mixin class _$NotificationSettingUiStateCopyWith<$Res>
    implements $NotificationSettingUiStateCopyWith<$Res> {
  factory _$NotificationSettingUiStateCopyWith(
          _NotificationSettingUiState value,
          $Res Function(_NotificationSettingUiState) _then) =
      __$NotificationSettingUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<NotificationSettingUiModel> notifications,
      int policyRevision});
}

/// @nodoc
class __$NotificationSettingUiStateCopyWithImpl<$Res>
    implements _$NotificationSettingUiStateCopyWith<$Res> {
  __$NotificationSettingUiStateCopyWithImpl(this._self, this._then);

  final _NotificationSettingUiState _self;
  final $Res Function(_NotificationSettingUiState) _then;

  /// Create a copy of NotificationSettingUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? notifications = null,
    Object? policyRevision = null,
  }) {
    return _then(_NotificationSettingUiState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      notifications: null == notifications
          ? _self._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationSettingUiModel>,
      policyRevision: null == policyRevision
          ? _self.policyRevision
          : policyRevision // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
