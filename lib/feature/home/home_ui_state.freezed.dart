// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeUiState {
  bool get isUserLoading;
  bool get isHeartRateLoading;
  bool get isNotificationLoading;
  String get name;
  bool get isWearing;
  int get heartRate;
  HeartRateStatus get heartRateStatus;
  DateTime get measuredAt;

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeUiStateCopyWith<HomeUiState> get copyWith =>
      _$HomeUiStateCopyWithImpl<HomeUiState>(this as HomeUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeUiState &&
            (identical(other.isUserLoading, isUserLoading) ||
                other.isUserLoading == isUserLoading) &&
            (identical(other.isHeartRateLoading, isHeartRateLoading) ||
                other.isHeartRateLoading == isHeartRateLoading) &&
            (identical(other.isNotificationLoading, isNotificationLoading) ||
                other.isNotificationLoading == isNotificationLoading) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isWearing, isWearing) ||
                other.isWearing == isWearing) &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.heartRateStatus, heartRateStatus) ||
                other.heartRateStatus == heartRateStatus) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isUserLoading,
      isHeartRateLoading,
      isNotificationLoading,
      name,
      isWearing,
      heartRate,
      heartRateStatus,
      measuredAt);

  @override
  String toString() {
    return 'HomeUiState(isUserLoading: $isUserLoading, isHeartRateLoading: $isHeartRateLoading, isNotificationLoading: $isNotificationLoading, name: $name, isWearing: $isWearing, heartRate: $heartRate, heartRateStatus: $heartRateStatus, measuredAt: $measuredAt)';
  }
}

/// @nodoc
abstract mixin class $HomeUiStateCopyWith<$Res> {
  factory $HomeUiStateCopyWith(
          HomeUiState value, $Res Function(HomeUiState) _then) =
      _$HomeUiStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isUserLoading,
      bool isHeartRateLoading,
      bool isNotificationLoading,
      String name,
      bool isWearing,
      int heartRate,
      HeartRateStatus heartRateStatus,
      DateTime measuredAt});
}

/// @nodoc
class _$HomeUiStateCopyWithImpl<$Res> implements $HomeUiStateCopyWith<$Res> {
  _$HomeUiStateCopyWithImpl(this._self, this._then);

  final HomeUiState _self;
  final $Res Function(HomeUiState) _then;

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isUserLoading = null,
    Object? isHeartRateLoading = null,
    Object? isNotificationLoading = null,
    Object? name = null,
    Object? isWearing = null,
    Object? heartRate = null,
    Object? heartRateStatus = null,
    Object? measuredAt = null,
  }) {
    return _then(_self.copyWith(
      isUserLoading: null == isUserLoading
          ? _self.isUserLoading
          : isUserLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isHeartRateLoading: null == isHeartRateLoading
          ? _self.isHeartRateLoading
          : isHeartRateLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isNotificationLoading: null == isNotificationLoading
          ? _self.isNotificationLoading
          : isNotificationLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isWearing: null == isWearing
          ? _self.isWearing
          : isWearing // ignore: cast_nullable_to_non_nullable
              as bool,
      heartRate: null == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int,
      heartRateStatus: null == heartRateStatus
          ? _self.heartRateStatus
          : heartRateStatus // ignore: cast_nullable_to_non_nullable
              as HeartRateStatus,
      measuredAt: null == measuredAt
          ? _self.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeUiState].
extension HomeUiStatePatterns on HomeUiState {
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
    TResult Function(_HomeUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeUiState() when $default != null:
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
    TResult Function(_HomeUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeUiState():
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
    TResult? Function(_HomeUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeUiState() when $default != null:
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
            bool isUserLoading,
            bool isHeartRateLoading,
            bool isNotificationLoading,
            String name,
            bool isWearing,
            int heartRate,
            HeartRateStatus heartRateStatus,
            DateTime measuredAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeUiState() when $default != null:
        return $default(
            _that.isUserLoading,
            _that.isHeartRateLoading,
            _that.isNotificationLoading,
            _that.name,
            _that.isWearing,
            _that.heartRate,
            _that.heartRateStatus,
            _that.measuredAt);
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
            bool isUserLoading,
            bool isHeartRateLoading,
            bool isNotificationLoading,
            String name,
            bool isWearing,
            int heartRate,
            HeartRateStatus heartRateStatus,
            DateTime measuredAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeUiState():
        return $default(
            _that.isUserLoading,
            _that.isHeartRateLoading,
            _that.isNotificationLoading,
            _that.name,
            _that.isWearing,
            _that.heartRate,
            _that.heartRateStatus,
            _that.measuredAt);
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
            bool isUserLoading,
            bool isHeartRateLoading,
            bool isNotificationLoading,
            String name,
            bool isWearing,
            int heartRate,
            HeartRateStatus heartRateStatus,
            DateTime measuredAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeUiState() when $default != null:
        return $default(
            _that.isUserLoading,
            _that.isHeartRateLoading,
            _that.isNotificationLoading,
            _that.name,
            _that.isWearing,
            _that.heartRate,
            _that.heartRateStatus,
            _that.measuredAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HomeUiState implements HomeUiState {
  const _HomeUiState(
      {required this.isUserLoading,
      required this.isHeartRateLoading,
      required this.isNotificationLoading,
      required this.name,
      required this.isWearing,
      required this.heartRate,
      required this.heartRateStatus,
      required this.measuredAt});

  @override
  final bool isUserLoading;
  @override
  final bool isHeartRateLoading;
  @override
  final bool isNotificationLoading;
  @override
  final String name;
  @override
  final bool isWearing;
  @override
  final int heartRate;
  @override
  final HeartRateStatus heartRateStatus;
  @override
  final DateTime measuredAt;

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeUiStateCopyWith<_HomeUiState> get copyWith =>
      __$HomeUiStateCopyWithImpl<_HomeUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeUiState &&
            (identical(other.isUserLoading, isUserLoading) ||
                other.isUserLoading == isUserLoading) &&
            (identical(other.isHeartRateLoading, isHeartRateLoading) ||
                other.isHeartRateLoading == isHeartRateLoading) &&
            (identical(other.isNotificationLoading, isNotificationLoading) ||
                other.isNotificationLoading == isNotificationLoading) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isWearing, isWearing) ||
                other.isWearing == isWearing) &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.heartRateStatus, heartRateStatus) ||
                other.heartRateStatus == heartRateStatus) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isUserLoading,
      isHeartRateLoading,
      isNotificationLoading,
      name,
      isWearing,
      heartRate,
      heartRateStatus,
      measuredAt);

  @override
  String toString() {
    return 'HomeUiState(isUserLoading: $isUserLoading, isHeartRateLoading: $isHeartRateLoading, isNotificationLoading: $isNotificationLoading, name: $name, isWearing: $isWearing, heartRate: $heartRate, heartRateStatus: $heartRateStatus, measuredAt: $measuredAt)';
  }
}

/// @nodoc
abstract mixin class _$HomeUiStateCopyWith<$Res>
    implements $HomeUiStateCopyWith<$Res> {
  factory _$HomeUiStateCopyWith(
          _HomeUiState value, $Res Function(_HomeUiState) _then) =
      __$HomeUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isUserLoading,
      bool isHeartRateLoading,
      bool isNotificationLoading,
      String name,
      bool isWearing,
      int heartRate,
      HeartRateStatus heartRateStatus,
      DateTime measuredAt});
}

/// @nodoc
class __$HomeUiStateCopyWithImpl<$Res> implements _$HomeUiStateCopyWith<$Res> {
  __$HomeUiStateCopyWithImpl(this._self, this._then);

  final _HomeUiState _self;
  final $Res Function(_HomeUiState) _then;

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isUserLoading = null,
    Object? isHeartRateLoading = null,
    Object? isNotificationLoading = null,
    Object? name = null,
    Object? isWearing = null,
    Object? heartRate = null,
    Object? heartRateStatus = null,
    Object? measuredAt = null,
  }) {
    return _then(_HomeUiState(
      isUserLoading: null == isUserLoading
          ? _self.isUserLoading
          : isUserLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isHeartRateLoading: null == isHeartRateLoading
          ? _self.isHeartRateLoading
          : isHeartRateLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isNotificationLoading: null == isNotificationLoading
          ? _self.isNotificationLoading
          : isNotificationLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isWearing: null == isWearing
          ? _self.isWearing
          : isWearing // ignore: cast_nullable_to_non_nullable
              as bool,
      heartRate: null == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int,
      heartRateStatus: null == heartRateStatus
          ? _self.heartRateStatus
          : heartRateStatus // ignore: cast_nullable_to_non_nullable
              as HeartRateStatus,
      measuredAt: null == measuredAt
          ? _self.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
