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
  bool get isSeniorCardLoading;
  List<NotificationUiModel> get notifications;
  String get name;
  bool get isWearing;
  int? get heartRate;
  HeartRateStatus get heartRateStatus;
  DateTime? get measuredAt;
  List<String> get thumbnails;
  MedicationStatus get medicationStatus;
  int get stepGoal;
  int get steps;
  String? get healthSchedulePlace;
  double? get healthScheduleLatitude;
  double? get healthScheduleLongitude;

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
            (identical(other.isSeniorCardLoading, isSeniorCardLoading) ||
                other.isSeniorCardLoading == isSeniorCardLoading) &&
            const DeepCollectionEquality()
                .equals(other.notifications, notifications) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isWearing, isWearing) ||
                other.isWearing == isWearing) &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.heartRateStatus, heartRateStatus) ||
                other.heartRateStatus == heartRateStatus) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt) &&
            const DeepCollectionEquality()
                .equals(other.thumbnails, thumbnails) &&
            (identical(other.medicationStatus, medicationStatus) ||
                other.medicationStatus == medicationStatus) &&
            (identical(other.stepGoal, stepGoal) ||
                other.stepGoal == stepGoal) &&
            (identical(other.steps, steps) || other.steps == steps) &&
            (identical(other.healthSchedulePlace, healthSchedulePlace) ||
                other.healthSchedulePlace == healthSchedulePlace) &&
            (identical(other.healthScheduleLatitude, healthScheduleLatitude) ||
                other.healthScheduleLatitude == healthScheduleLatitude) &&
            (identical(
                    other.healthScheduleLongitude, healthScheduleLongitude) ||
                other.healthScheduleLongitude == healthScheduleLongitude));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isUserLoading,
      isHeartRateLoading,
      isNotificationLoading,
      isSeniorCardLoading,
      const DeepCollectionEquality().hash(notifications),
      name,
      isWearing,
      heartRate,
      heartRateStatus,
      measuredAt,
      const DeepCollectionEquality().hash(thumbnails),
      medicationStatus,
      stepGoal,
      steps,
      healthSchedulePlace,
      healthScheduleLatitude,
      healthScheduleLongitude);

  @override
  String toString() {
    return 'HomeUiState(isUserLoading: $isUserLoading, isHeartRateLoading: $isHeartRateLoading, isNotificationLoading: $isNotificationLoading, isSeniorCardLoading: $isSeniorCardLoading, notifications: $notifications, name: $name, isWearing: $isWearing, heartRate: $heartRate, heartRateStatus: $heartRateStatus, measuredAt: $measuredAt, thumbnails: $thumbnails, medicationStatus: $medicationStatus, stepGoal: $stepGoal, steps: $steps, healthSchedulePlace: $healthSchedulePlace, healthScheduleLatitude: $healthScheduleLatitude, healthScheduleLongitude: $healthScheduleLongitude)';
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
      bool isSeniorCardLoading,
      List<NotificationUiModel> notifications,
      String name,
      bool isWearing,
      int? heartRate,
      HeartRateStatus heartRateStatus,
      DateTime? measuredAt,
      List<String> thumbnails,
      MedicationStatus medicationStatus,
      int stepGoal,
      int steps,
      String? healthSchedulePlace,
      double? healthScheduleLatitude,
      double? healthScheduleLongitude});

  $MedicationStatusCopyWith<$Res> get medicationStatus;
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
    Object? isSeniorCardLoading = null,
    Object? notifications = null,
    Object? name = null,
    Object? isWearing = null,
    Object? heartRate = freezed,
    Object? heartRateStatus = null,
    Object? measuredAt = freezed,
    Object? thumbnails = null,
    Object? medicationStatus = null,
    Object? stepGoal = null,
    Object? steps = null,
    Object? healthSchedulePlace = freezed,
    Object? healthScheduleLatitude = freezed,
    Object? healthScheduleLongitude = freezed,
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
      isSeniorCardLoading: null == isSeniorCardLoading
          ? _self.isSeniorCardLoading
          : isSeniorCardLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      notifications: null == notifications
          ? _self.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationUiModel>,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isWearing: null == isWearing
          ? _self.isWearing
          : isWearing // ignore: cast_nullable_to_non_nullable
              as bool,
      heartRate: freezed == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      heartRateStatus: null == heartRateStatus
          ? _self.heartRateStatus
          : heartRateStatus // ignore: cast_nullable_to_non_nullable
              as HeartRateStatus,
      measuredAt: freezed == measuredAt
          ? _self.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      thumbnails: null == thumbnails
          ? _self.thumbnails
          : thumbnails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medicationStatus: null == medicationStatus
          ? _self.medicationStatus
          : medicationStatus // ignore: cast_nullable_to_non_nullable
              as MedicationStatus,
      stepGoal: null == stepGoal
          ? _self.stepGoal
          : stepGoal // ignore: cast_nullable_to_non_nullable
              as int,
      steps: null == steps
          ? _self.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      healthSchedulePlace: freezed == healthSchedulePlace
          ? _self.healthSchedulePlace
          : healthSchedulePlace // ignore: cast_nullable_to_non_nullable
              as String?,
      healthScheduleLatitude: freezed == healthScheduleLatitude
          ? _self.healthScheduleLatitude
          : healthScheduleLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      healthScheduleLongitude: freezed == healthScheduleLongitude
          ? _self.healthScheduleLongitude
          : healthScheduleLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationStatusCopyWith<$Res> get medicationStatus {
    return $MedicationStatusCopyWith<$Res>(_self.medicationStatus, (value) {
      return _then(_self.copyWith(medicationStatus: value));
    });
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
            bool isSeniorCardLoading,
            List<NotificationUiModel> notifications,
            String name,
            bool isWearing,
            int? heartRate,
            HeartRateStatus heartRateStatus,
            DateTime? measuredAt,
            List<String> thumbnails,
            MedicationStatus medicationStatus,
            int stepGoal,
            int steps,
            String? healthSchedulePlace,
            double? healthScheduleLatitude,
            double? healthScheduleLongitude)?
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
            _that.isSeniorCardLoading,
            _that.notifications,
            _that.name,
            _that.isWearing,
            _that.heartRate,
            _that.heartRateStatus,
            _that.measuredAt,
            _that.thumbnails,
            _that.medicationStatus,
            _that.stepGoal,
            _that.steps,
            _that.healthSchedulePlace,
            _that.healthScheduleLatitude,
            _that.healthScheduleLongitude);
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
            bool isSeniorCardLoading,
            List<NotificationUiModel> notifications,
            String name,
            bool isWearing,
            int? heartRate,
            HeartRateStatus heartRateStatus,
            DateTime? measuredAt,
            List<String> thumbnails,
            MedicationStatus medicationStatus,
            int stepGoal,
            int steps,
            String? healthSchedulePlace,
            double? healthScheduleLatitude,
            double? healthScheduleLongitude)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeUiState():
        return $default(
            _that.isUserLoading,
            _that.isHeartRateLoading,
            _that.isNotificationLoading,
            _that.isSeniorCardLoading,
            _that.notifications,
            _that.name,
            _that.isWearing,
            _that.heartRate,
            _that.heartRateStatus,
            _that.measuredAt,
            _that.thumbnails,
            _that.medicationStatus,
            _that.stepGoal,
            _that.steps,
            _that.healthSchedulePlace,
            _that.healthScheduleLatitude,
            _that.healthScheduleLongitude);
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
            bool isSeniorCardLoading,
            List<NotificationUiModel> notifications,
            String name,
            bool isWearing,
            int? heartRate,
            HeartRateStatus heartRateStatus,
            DateTime? measuredAt,
            List<String> thumbnails,
            MedicationStatus medicationStatus,
            int stepGoal,
            int steps,
            String? healthSchedulePlace,
            double? healthScheduleLatitude,
            double? healthScheduleLongitude)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeUiState() when $default != null:
        return $default(
            _that.isUserLoading,
            _that.isHeartRateLoading,
            _that.isNotificationLoading,
            _that.isSeniorCardLoading,
            _that.notifications,
            _that.name,
            _that.isWearing,
            _that.heartRate,
            _that.heartRateStatus,
            _that.measuredAt,
            _that.thumbnails,
            _that.medicationStatus,
            _that.stepGoal,
            _that.steps,
            _that.healthSchedulePlace,
            _that.healthScheduleLatitude,
            _that.healthScheduleLongitude);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HomeUiState extends HomeUiState {
  const _HomeUiState(
      {required this.isUserLoading,
      required this.isHeartRateLoading,
      required this.isNotificationLoading,
      required this.isSeniorCardLoading,
      required final List<NotificationUiModel> notifications,
      required this.name,
      required this.isWearing,
      this.heartRate,
      required this.heartRateStatus,
      this.measuredAt,
      required final List<String> thumbnails,
      required this.medicationStatus,
      required this.stepGoal,
      required this.steps,
      required this.healthSchedulePlace,
      required this.healthScheduleLatitude,
      required this.healthScheduleLongitude})
      : _notifications = notifications,
        _thumbnails = thumbnails,
        super._();

  @override
  final bool isUserLoading;
  @override
  final bool isHeartRateLoading;
  @override
  final bool isNotificationLoading;
  @override
  final bool isSeniorCardLoading;
  final List<NotificationUiModel> _notifications;
  @override
  List<NotificationUiModel> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  final String name;
  @override
  final bool isWearing;
  @override
  final int? heartRate;
  @override
  final HeartRateStatus heartRateStatus;
  @override
  final DateTime? measuredAt;
  final List<String> _thumbnails;
  @override
  List<String> get thumbnails {
    if (_thumbnails is EqualUnmodifiableListView) return _thumbnails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thumbnails);
  }

  @override
  final MedicationStatus medicationStatus;
  @override
  final int stepGoal;
  @override
  final int steps;
  @override
  final String? healthSchedulePlace;
  @override
  final double? healthScheduleLatitude;
  @override
  final double? healthScheduleLongitude;

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
            (identical(other.isSeniorCardLoading, isSeniorCardLoading) ||
                other.isSeniorCardLoading == isSeniorCardLoading) &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isWearing, isWearing) ||
                other.isWearing == isWearing) &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.heartRateStatus, heartRateStatus) ||
                other.heartRateStatus == heartRateStatus) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt) &&
            const DeepCollectionEquality()
                .equals(other._thumbnails, _thumbnails) &&
            (identical(other.medicationStatus, medicationStatus) ||
                other.medicationStatus == medicationStatus) &&
            (identical(other.stepGoal, stepGoal) ||
                other.stepGoal == stepGoal) &&
            (identical(other.steps, steps) || other.steps == steps) &&
            (identical(other.healthSchedulePlace, healthSchedulePlace) ||
                other.healthSchedulePlace == healthSchedulePlace) &&
            (identical(other.healthScheduleLatitude, healthScheduleLatitude) ||
                other.healthScheduleLatitude == healthScheduleLatitude) &&
            (identical(
                    other.healthScheduleLongitude, healthScheduleLongitude) ||
                other.healthScheduleLongitude == healthScheduleLongitude));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isUserLoading,
      isHeartRateLoading,
      isNotificationLoading,
      isSeniorCardLoading,
      const DeepCollectionEquality().hash(_notifications),
      name,
      isWearing,
      heartRate,
      heartRateStatus,
      measuredAt,
      const DeepCollectionEquality().hash(_thumbnails),
      medicationStatus,
      stepGoal,
      steps,
      healthSchedulePlace,
      healthScheduleLatitude,
      healthScheduleLongitude);

  @override
  String toString() {
    return 'HomeUiState(isUserLoading: $isUserLoading, isHeartRateLoading: $isHeartRateLoading, isNotificationLoading: $isNotificationLoading, isSeniorCardLoading: $isSeniorCardLoading, notifications: $notifications, name: $name, isWearing: $isWearing, heartRate: $heartRate, heartRateStatus: $heartRateStatus, measuredAt: $measuredAt, thumbnails: $thumbnails, medicationStatus: $medicationStatus, stepGoal: $stepGoal, steps: $steps, healthSchedulePlace: $healthSchedulePlace, healthScheduleLatitude: $healthScheduleLatitude, healthScheduleLongitude: $healthScheduleLongitude)';
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
      bool isSeniorCardLoading,
      List<NotificationUiModel> notifications,
      String name,
      bool isWearing,
      int? heartRate,
      HeartRateStatus heartRateStatus,
      DateTime? measuredAt,
      List<String> thumbnails,
      MedicationStatus medicationStatus,
      int stepGoal,
      int steps,
      String? healthSchedulePlace,
      double? healthScheduleLatitude,
      double? healthScheduleLongitude});

  @override
  $MedicationStatusCopyWith<$Res> get medicationStatus;
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
    Object? isSeniorCardLoading = null,
    Object? notifications = null,
    Object? name = null,
    Object? isWearing = null,
    Object? heartRate = freezed,
    Object? heartRateStatus = null,
    Object? measuredAt = freezed,
    Object? thumbnails = null,
    Object? medicationStatus = null,
    Object? stepGoal = null,
    Object? steps = null,
    Object? healthSchedulePlace = freezed,
    Object? healthScheduleLatitude = freezed,
    Object? healthScheduleLongitude = freezed,
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
      isSeniorCardLoading: null == isSeniorCardLoading
          ? _self.isSeniorCardLoading
          : isSeniorCardLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      notifications: null == notifications
          ? _self._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationUiModel>,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isWearing: null == isWearing
          ? _self.isWearing
          : isWearing // ignore: cast_nullable_to_non_nullable
              as bool,
      heartRate: freezed == heartRate
          ? _self.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      heartRateStatus: null == heartRateStatus
          ? _self.heartRateStatus
          : heartRateStatus // ignore: cast_nullable_to_non_nullable
              as HeartRateStatus,
      measuredAt: freezed == measuredAt
          ? _self.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      thumbnails: null == thumbnails
          ? _self._thumbnails
          : thumbnails // ignore: cast_nullable_to_non_nullable
              as List<String>,
      medicationStatus: null == medicationStatus
          ? _self.medicationStatus
          : medicationStatus // ignore: cast_nullable_to_non_nullable
              as MedicationStatus,
      stepGoal: null == stepGoal
          ? _self.stepGoal
          : stepGoal // ignore: cast_nullable_to_non_nullable
              as int,
      steps: null == steps
          ? _self.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      healthSchedulePlace: freezed == healthSchedulePlace
          ? _self.healthSchedulePlace
          : healthSchedulePlace // ignore: cast_nullable_to_non_nullable
              as String?,
      healthScheduleLatitude: freezed == healthScheduleLatitude
          ? _self.healthScheduleLatitude
          : healthScheduleLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      healthScheduleLongitude: freezed == healthScheduleLongitude
          ? _self.healthScheduleLongitude
          : healthScheduleLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationStatusCopyWith<$Res> get medicationStatus {
    return $MedicationStatusCopyWith<$Res>(_self.medicationStatus, (value) {
      return _then(_self.copyWith(medicationStatus: value));
    });
  }
}

// dart format on
