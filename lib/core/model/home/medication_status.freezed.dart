// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationStatus {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MedicationStatus);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MedicationStatus()';
  }
}

/// @nodoc
class $MedicationStatusCopyWith<$Res> {
  $MedicationStatusCopyWith(
      MedicationStatus _, $Res Function(MedicationStatus) __);
}

/// Adds pattern-matching-related methods to [MedicationStatus].
extension MedicationStatusPatterns on MedicationStatus {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MedicationAvailable value)? available,
    TResult Function(MedicationUpcoming value)? upcoming,
    TResult Function(MedicationCompleted value)? completed,
    TResult Function(MedicationMissed value)? missed,
    TResult Function(MedicationNone value)? none,
    TResult Function(MedicationUnknown value)? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MedicationAvailable() when available != null:
        return available(_that);
      case MedicationUpcoming() when upcoming != null:
        return upcoming(_that);
      case MedicationCompleted() when completed != null:
        return completed(_that);
      case MedicationMissed() when missed != null:
        return missed(_that);
      case MedicationNone() when none != null:
        return none(_that);
      case MedicationUnknown() when unknown != null:
        return unknown(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(MedicationAvailable value) available,
    required TResult Function(MedicationUpcoming value) upcoming,
    required TResult Function(MedicationCompleted value) completed,
    required TResult Function(MedicationMissed value) missed,
    required TResult Function(MedicationNone value) none,
    required TResult Function(MedicationUnknown value) unknown,
  }) {
    final _that = this;
    switch (_that) {
      case MedicationAvailable():
        return available(_that);
      case MedicationUpcoming():
        return upcoming(_that);
      case MedicationCompleted():
        return completed(_that);
      case MedicationMissed():
        return missed(_that);
      case MedicationNone():
        return none(_that);
      case MedicationUnknown():
        return unknown(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MedicationAvailable value)? available,
    TResult? Function(MedicationUpcoming value)? upcoming,
    TResult? Function(MedicationCompleted value)? completed,
    TResult? Function(MedicationMissed value)? missed,
    TResult? Function(MedicationNone value)? none,
    TResult? Function(MedicationUnknown value)? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case MedicationAvailable() when available != null:
        return available(_that);
      case MedicationUpcoming() when upcoming != null:
        return upcoming(_that);
      case MedicationCompleted() when completed != null:
        return completed(_that);
      case MedicationMissed() when missed != null:
        return missed(_that);
      case MedicationNone() when none != null:
        return none(_that);
      case MedicationUnknown() when unknown != null:
        return unknown(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime doseAt, DateTime closesAt, int takenCount,
            int totalCount, int? doseCount, int? scheduleId)?
        available,
    TResult Function(
            DateTime doseAt, DateTime opensAt, int takenCount, int totalCount)?
        upcoming,
    TResult Function(int totalCount)? completed,
    TResult Function(int takenCount, int totalCount)? missed,
    TResult Function()? none,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MedicationAvailable() when available != null:
        return available(_that.doseAt, _that.closesAt, _that.takenCount,
            _that.totalCount, _that.doseCount, _that.scheduleId);
      case MedicationUpcoming() when upcoming != null:
        return upcoming(
            _that.doseAt, _that.opensAt, _that.takenCount, _that.totalCount);
      case MedicationCompleted() when completed != null:
        return completed(_that.totalCount);
      case MedicationMissed() when missed != null:
        return missed(_that.takenCount, _that.totalCount);
      case MedicationNone() when none != null:
        return none();
      case MedicationUnknown() when unknown != null:
        return unknown();
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
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime doseAt, DateTime closesAt,
            int takenCount, int totalCount, int? doseCount, int? scheduleId)
        available,
    required TResult Function(
            DateTime doseAt, DateTime opensAt, int takenCount, int totalCount)
        upcoming,
    required TResult Function(int totalCount) completed,
    required TResult Function(int takenCount, int totalCount) missed,
    required TResult Function() none,
    required TResult Function() unknown,
  }) {
    final _that = this;
    switch (_that) {
      case MedicationAvailable():
        return available(_that.doseAt, _that.closesAt, _that.takenCount,
            _that.totalCount, _that.doseCount, _that.scheduleId);
      case MedicationUpcoming():
        return upcoming(
            _that.doseAt, _that.opensAt, _that.takenCount, _that.totalCount);
      case MedicationCompleted():
        return completed(_that.totalCount);
      case MedicationMissed():
        return missed(_that.takenCount, _that.totalCount);
      case MedicationNone():
        return none();
      case MedicationUnknown():
        return unknown();
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime doseAt, DateTime closesAt, int takenCount,
            int totalCount, int? doseCount, int? scheduleId)?
        available,
    TResult? Function(
            DateTime doseAt, DateTime opensAt, int takenCount, int totalCount)?
        upcoming,
    TResult? Function(int totalCount)? completed,
    TResult? Function(int takenCount, int totalCount)? missed,
    TResult? Function()? none,
    TResult? Function()? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case MedicationAvailable() when available != null:
        return available(_that.doseAt, _that.closesAt, _that.takenCount,
            _that.totalCount, _that.doseCount, _that.scheduleId);
      case MedicationUpcoming() when upcoming != null:
        return upcoming(
            _that.doseAt, _that.opensAt, _that.takenCount, _that.totalCount);
      case MedicationCompleted() when completed != null:
        return completed(_that.totalCount);
      case MedicationMissed() when missed != null:
        return missed(_that.takenCount, _that.totalCount);
      case MedicationNone() when none != null:
        return none();
      case MedicationUnknown() when unknown != null:
        return unknown();
      case _:
        return null;
    }
  }
}

/// @nodoc

class MedicationAvailable implements MedicationStatus {
  const MedicationAvailable(
      {required this.doseAt,
      required this.closesAt,
      required this.takenCount,
      required this.totalCount,
      this.doseCount,
      this.scheduleId});

  final DateTime doseAt;
  final DateTime closesAt;
  final int takenCount;
  final int totalCount;
  final int? doseCount;
  final int? scheduleId;

  /// Create a copy of MedicationStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationAvailableCopyWith<MedicationAvailable> get copyWith =>
      _$MedicationAvailableCopyWithImpl<MedicationAvailable>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationAvailable &&
            (identical(other.doseAt, doseAt) || other.doseAt == doseAt) &&
            (identical(other.closesAt, closesAt) ||
                other.closesAt == closesAt) &&
            (identical(other.takenCount, takenCount) ||
                other.takenCount == takenCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.doseCount, doseCount) ||
                other.doseCount == doseCount) &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, doseAt, closesAt, takenCount,
      totalCount, doseCount, scheduleId);

  @override
  String toString() {
    return 'MedicationStatus.available(doseAt: $doseAt, closesAt: $closesAt, takenCount: $takenCount, totalCount: $totalCount, doseCount: $doseCount, scheduleId: $scheduleId)';
  }
}

/// @nodoc
abstract mixin class $MedicationAvailableCopyWith<$Res>
    implements $MedicationStatusCopyWith<$Res> {
  factory $MedicationAvailableCopyWith(
          MedicationAvailable value, $Res Function(MedicationAvailable) _then) =
      _$MedicationAvailableCopyWithImpl;
  @useResult
  $Res call(
      {DateTime doseAt,
      DateTime closesAt,
      int takenCount,
      int totalCount,
      int? doseCount,
      int? scheduleId});
}

/// @nodoc
class _$MedicationAvailableCopyWithImpl<$Res>
    implements $MedicationAvailableCopyWith<$Res> {
  _$MedicationAvailableCopyWithImpl(this._self, this._then);

  final MedicationAvailable _self;
  final $Res Function(MedicationAvailable) _then;

  /// Create a copy of MedicationStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? doseAt = null,
    Object? closesAt = null,
    Object? takenCount = null,
    Object? totalCount = null,
    Object? doseCount = freezed,
    Object? scheduleId = freezed,
  }) {
    return _then(MedicationAvailable(
      doseAt: null == doseAt
          ? _self.doseAt
          : doseAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      closesAt: null == closesAt
          ? _self.closesAt
          : closesAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      takenCount: null == takenCount
          ? _self.takenCount
          : takenCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      doseCount: freezed == doseCount
          ? _self.doseCount
          : doseCount // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduleId: freezed == scheduleId
          ? _self.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class MedicationUpcoming implements MedicationStatus {
  const MedicationUpcoming(
      {required this.doseAt,
      required this.opensAt,
      required this.takenCount,
      required this.totalCount});

  final DateTime doseAt;
  final DateTime opensAt;
  final int takenCount;
  final int totalCount;

  /// Create a copy of MedicationStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationUpcomingCopyWith<MedicationUpcoming> get copyWith =>
      _$MedicationUpcomingCopyWithImpl<MedicationUpcoming>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationUpcoming &&
            (identical(other.doseAt, doseAt) || other.doseAt == doseAt) &&
            (identical(other.opensAt, opensAt) || other.opensAt == opensAt) &&
            (identical(other.takenCount, takenCount) ||
                other.takenCount == takenCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, doseAt, opensAt, takenCount, totalCount);

  @override
  String toString() {
    return 'MedicationStatus.upcoming(doseAt: $doseAt, opensAt: $opensAt, takenCount: $takenCount, totalCount: $totalCount)';
  }
}

/// @nodoc
abstract mixin class $MedicationUpcomingCopyWith<$Res>
    implements $MedicationStatusCopyWith<$Res> {
  factory $MedicationUpcomingCopyWith(
          MedicationUpcoming value, $Res Function(MedicationUpcoming) _then) =
      _$MedicationUpcomingCopyWithImpl;
  @useResult
  $Res call(
      {DateTime doseAt, DateTime opensAt, int takenCount, int totalCount});
}

/// @nodoc
class _$MedicationUpcomingCopyWithImpl<$Res>
    implements $MedicationUpcomingCopyWith<$Res> {
  _$MedicationUpcomingCopyWithImpl(this._self, this._then);

  final MedicationUpcoming _self;
  final $Res Function(MedicationUpcoming) _then;

  /// Create a copy of MedicationStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? doseAt = null,
    Object? opensAt = null,
    Object? takenCount = null,
    Object? totalCount = null,
  }) {
    return _then(MedicationUpcoming(
      doseAt: null == doseAt
          ? _self.doseAt
          : doseAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      opensAt: null == opensAt
          ? _self.opensAt
          : opensAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      takenCount: null == takenCount
          ? _self.takenCount
          : takenCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class MedicationCompleted implements MedicationStatus {
  const MedicationCompleted({required this.totalCount});

  final int totalCount;

  /// Create a copy of MedicationStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationCompletedCopyWith<MedicationCompleted> get copyWith =>
      _$MedicationCompletedCopyWithImpl<MedicationCompleted>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationCompleted &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalCount);

  @override
  String toString() {
    return 'MedicationStatus.completed(totalCount: $totalCount)';
  }
}

/// @nodoc
abstract mixin class $MedicationCompletedCopyWith<$Res>
    implements $MedicationStatusCopyWith<$Res> {
  factory $MedicationCompletedCopyWith(
          MedicationCompleted value, $Res Function(MedicationCompleted) _then) =
      _$MedicationCompletedCopyWithImpl;
  @useResult
  $Res call({int totalCount});
}

/// @nodoc
class _$MedicationCompletedCopyWithImpl<$Res>
    implements $MedicationCompletedCopyWith<$Res> {
  _$MedicationCompletedCopyWithImpl(this._self, this._then);

  final MedicationCompleted _self;
  final $Res Function(MedicationCompleted) _then;

  /// Create a copy of MedicationStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalCount = null,
  }) {
    return _then(MedicationCompleted(
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class MedicationMissed implements MedicationStatus {
  const MedicationMissed({required this.takenCount, required this.totalCount});

  final int takenCount;
  final int totalCount;

  /// Create a copy of MedicationStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationMissedCopyWith<MedicationMissed> get copyWith =>
      _$MedicationMissedCopyWithImpl<MedicationMissed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationMissed &&
            (identical(other.takenCount, takenCount) ||
                other.takenCount == takenCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, takenCount, totalCount);

  @override
  String toString() {
    return 'MedicationStatus.missed(takenCount: $takenCount, totalCount: $totalCount)';
  }
}

/// @nodoc
abstract mixin class $MedicationMissedCopyWith<$Res>
    implements $MedicationStatusCopyWith<$Res> {
  factory $MedicationMissedCopyWith(
          MedicationMissed value, $Res Function(MedicationMissed) _then) =
      _$MedicationMissedCopyWithImpl;
  @useResult
  $Res call({int takenCount, int totalCount});
}

/// @nodoc
class _$MedicationMissedCopyWithImpl<$Res>
    implements $MedicationMissedCopyWith<$Res> {
  _$MedicationMissedCopyWithImpl(this._self, this._then);

  final MedicationMissed _self;
  final $Res Function(MedicationMissed) _then;

  /// Create a copy of MedicationStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? takenCount = null,
    Object? totalCount = null,
  }) {
    return _then(MedicationMissed(
      takenCount: null == takenCount
          ? _self.takenCount
          : takenCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class MedicationNone implements MedicationStatus {
  const MedicationNone();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MedicationNone);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MedicationStatus.none()';
  }
}

/// @nodoc

class MedicationUnknown implements MedicationStatus {
  const MedicationUnknown();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MedicationUnknown);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MedicationStatus.unknown()';
  }
}

// dart format on
