// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SensorConfig {
  String get collectionMode;
  String get gyroMode;
  int get accFsHz;
  int get batchSec;
  double get impactThresholdG;
  int get backfillBeforeSec;
  int get backfillAfterSec;

  /// 재조회 권고 간격(초).
  int get refreshSec;

  /// Create a copy of SensorConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorConfigCopyWith<SensorConfig> get copyWith =>
      _$SensorConfigCopyWithImpl<SensorConfig>(
          this as SensorConfig, _$identity);

  /// Serializes this SensorConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorConfig &&
            (identical(other.collectionMode, collectionMode) ||
                other.collectionMode == collectionMode) &&
            (identical(other.gyroMode, gyroMode) ||
                other.gyroMode == gyroMode) &&
            (identical(other.accFsHz, accFsHz) || other.accFsHz == accFsHz) &&
            (identical(other.batchSec, batchSec) ||
                other.batchSec == batchSec) &&
            (identical(other.impactThresholdG, impactThresholdG) ||
                other.impactThresholdG == impactThresholdG) &&
            (identical(other.backfillBeforeSec, backfillBeforeSec) ||
                other.backfillBeforeSec == backfillBeforeSec) &&
            (identical(other.backfillAfterSec, backfillAfterSec) ||
                other.backfillAfterSec == backfillAfterSec) &&
            (identical(other.refreshSec, refreshSec) ||
                other.refreshSec == refreshSec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      collectionMode,
      gyroMode,
      accFsHz,
      batchSec,
      impactThresholdG,
      backfillBeforeSec,
      backfillAfterSec,
      refreshSec);

  @override
  String toString() {
    return 'SensorConfig(collectionMode: $collectionMode, gyroMode: $gyroMode, accFsHz: $accFsHz, batchSec: $batchSec, impactThresholdG: $impactThresholdG, backfillBeforeSec: $backfillBeforeSec, backfillAfterSec: $backfillAfterSec, refreshSec: $refreshSec)';
  }
}

/// @nodoc
abstract mixin class $SensorConfigCopyWith<$Res> {
  factory $SensorConfigCopyWith(
          SensorConfig value, $Res Function(SensorConfig) _then) =
      _$SensorConfigCopyWithImpl;
  @useResult
  $Res call(
      {String collectionMode,
      String gyroMode,
      int accFsHz,
      int batchSec,
      double impactThresholdG,
      int backfillBeforeSec,
      int backfillAfterSec,
      int refreshSec});
}

/// @nodoc
class _$SensorConfigCopyWithImpl<$Res> implements $SensorConfigCopyWith<$Res> {
  _$SensorConfigCopyWithImpl(this._self, this._then);

  final SensorConfig _self;
  final $Res Function(SensorConfig) _then;

  /// Create a copy of SensorConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? collectionMode = null,
    Object? gyroMode = null,
    Object? accFsHz = null,
    Object? batchSec = null,
    Object? impactThresholdG = null,
    Object? backfillBeforeSec = null,
    Object? backfillAfterSec = null,
    Object? refreshSec = null,
  }) {
    return _then(_self.copyWith(
      collectionMode: null == collectionMode
          ? _self.collectionMode
          : collectionMode // ignore: cast_nullable_to_non_nullable
              as String,
      gyroMode: null == gyroMode
          ? _self.gyroMode
          : gyroMode // ignore: cast_nullable_to_non_nullable
              as String,
      accFsHz: null == accFsHz
          ? _self.accFsHz
          : accFsHz // ignore: cast_nullable_to_non_nullable
              as int,
      batchSec: null == batchSec
          ? _self.batchSec
          : batchSec // ignore: cast_nullable_to_non_nullable
              as int,
      impactThresholdG: null == impactThresholdG
          ? _self.impactThresholdG
          : impactThresholdG // ignore: cast_nullable_to_non_nullable
              as double,
      backfillBeforeSec: null == backfillBeforeSec
          ? _self.backfillBeforeSec
          : backfillBeforeSec // ignore: cast_nullable_to_non_nullable
              as int,
      backfillAfterSec: null == backfillAfterSec
          ? _self.backfillAfterSec
          : backfillAfterSec // ignore: cast_nullable_to_non_nullable
              as int,
      refreshSec: null == refreshSec
          ? _self.refreshSec
          : refreshSec // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [SensorConfig].
extension SensorConfigPatterns on SensorConfig {
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
    TResult Function(_SensorConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorConfig() when $default != null:
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
    TResult Function(_SensorConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorConfig():
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
    TResult? Function(_SensorConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorConfig() when $default != null:
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
            String collectionMode,
            String gyroMode,
            int accFsHz,
            int batchSec,
            double impactThresholdG,
            int backfillBeforeSec,
            int backfillAfterSec,
            int refreshSec)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorConfig() when $default != null:
        return $default(
            _that.collectionMode,
            _that.gyroMode,
            _that.accFsHz,
            _that.batchSec,
            _that.impactThresholdG,
            _that.backfillBeforeSec,
            _that.backfillAfterSec,
            _that.refreshSec);
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
            String collectionMode,
            String gyroMode,
            int accFsHz,
            int batchSec,
            double impactThresholdG,
            int backfillBeforeSec,
            int backfillAfterSec,
            int refreshSec)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorConfig():
        return $default(
            _that.collectionMode,
            _that.gyroMode,
            _that.accFsHz,
            _that.batchSec,
            _that.impactThresholdG,
            _that.backfillBeforeSec,
            _that.backfillAfterSec,
            _that.refreshSec);
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
            String collectionMode,
            String gyroMode,
            int accFsHz,
            int batchSec,
            double impactThresholdG,
            int backfillBeforeSec,
            int backfillAfterSec,
            int refreshSec)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorConfig() when $default != null:
        return $default(
            _that.collectionMode,
            _that.gyroMode,
            _that.accFsHz,
            _that.batchSec,
            _that.impactThresholdG,
            _that.backfillBeforeSec,
            _that.backfillAfterSec,
            _that.refreshSec);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SensorConfig implements SensorConfig {
  const _SensorConfig(
      {this.collectionMode = 'product',
      this.gyroMode = 'continuous',
      this.accFsHz = 50,
      this.batchSec = 1,
      this.impactThresholdG = 1.8,
      this.backfillBeforeSec = 2,
      this.backfillAfterSec = 10,
      this.refreshSec = 60});
  factory _SensorConfig.fromJson(Map<String, dynamic> json) =>
      _$SensorConfigFromJson(json);

  @override
  @JsonKey()
  final String collectionMode;
  @override
  @JsonKey()
  final String gyroMode;
  @override
  @JsonKey()
  final int accFsHz;
  @override
  @JsonKey()
  final int batchSec;
  @override
  @JsonKey()
  final double impactThresholdG;
  @override
  @JsonKey()
  final int backfillBeforeSec;
  @override
  @JsonKey()
  final int backfillAfterSec;

  /// 재조회 권고 간격(초).
  @override
  @JsonKey()
  final int refreshSec;

  /// Create a copy of SensorConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SensorConfigCopyWith<_SensorConfig> get copyWith =>
      __$SensorConfigCopyWithImpl<_SensorConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SensorConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SensorConfig &&
            (identical(other.collectionMode, collectionMode) ||
                other.collectionMode == collectionMode) &&
            (identical(other.gyroMode, gyroMode) ||
                other.gyroMode == gyroMode) &&
            (identical(other.accFsHz, accFsHz) || other.accFsHz == accFsHz) &&
            (identical(other.batchSec, batchSec) ||
                other.batchSec == batchSec) &&
            (identical(other.impactThresholdG, impactThresholdG) ||
                other.impactThresholdG == impactThresholdG) &&
            (identical(other.backfillBeforeSec, backfillBeforeSec) ||
                other.backfillBeforeSec == backfillBeforeSec) &&
            (identical(other.backfillAfterSec, backfillAfterSec) ||
                other.backfillAfterSec == backfillAfterSec) &&
            (identical(other.refreshSec, refreshSec) ||
                other.refreshSec == refreshSec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      collectionMode,
      gyroMode,
      accFsHz,
      batchSec,
      impactThresholdG,
      backfillBeforeSec,
      backfillAfterSec,
      refreshSec);

  @override
  String toString() {
    return 'SensorConfig(collectionMode: $collectionMode, gyroMode: $gyroMode, accFsHz: $accFsHz, batchSec: $batchSec, impactThresholdG: $impactThresholdG, backfillBeforeSec: $backfillBeforeSec, backfillAfterSec: $backfillAfterSec, refreshSec: $refreshSec)';
  }
}

/// @nodoc
abstract mixin class _$SensorConfigCopyWith<$Res>
    implements $SensorConfigCopyWith<$Res> {
  factory _$SensorConfigCopyWith(
          _SensorConfig value, $Res Function(_SensorConfig) _then) =
      __$SensorConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String collectionMode,
      String gyroMode,
      int accFsHz,
      int batchSec,
      double impactThresholdG,
      int backfillBeforeSec,
      int backfillAfterSec,
      int refreshSec});
}

/// @nodoc
class __$SensorConfigCopyWithImpl<$Res>
    implements _$SensorConfigCopyWith<$Res> {
  __$SensorConfigCopyWithImpl(this._self, this._then);

  final _SensorConfig _self;
  final $Res Function(_SensorConfig) _then;

  /// Create a copy of SensorConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? collectionMode = null,
    Object? gyroMode = null,
    Object? accFsHz = null,
    Object? batchSec = null,
    Object? impactThresholdG = null,
    Object? backfillBeforeSec = null,
    Object? backfillAfterSec = null,
    Object? refreshSec = null,
  }) {
    return _then(_SensorConfig(
      collectionMode: null == collectionMode
          ? _self.collectionMode
          : collectionMode // ignore: cast_nullable_to_non_nullable
              as String,
      gyroMode: null == gyroMode
          ? _self.gyroMode
          : gyroMode // ignore: cast_nullable_to_non_nullable
              as String,
      accFsHz: null == accFsHz
          ? _self.accFsHz
          : accFsHz // ignore: cast_nullable_to_non_nullable
              as int,
      batchSec: null == batchSec
          ? _self.batchSec
          : batchSec // ignore: cast_nullable_to_non_nullable
              as int,
      impactThresholdG: null == impactThresholdG
          ? _self.impactThresholdG
          : impactThresholdG // ignore: cast_nullable_to_non_nullable
              as double,
      backfillBeforeSec: null == backfillBeforeSec
          ? _self.backfillBeforeSec
          : backfillBeforeSec // ignore: cast_nullable_to_non_nullable
              as int,
      backfillAfterSec: null == backfillAfterSec
          ? _self.backfillAfterSec
          : backfillAfterSec // ignore: cast_nullable_to_non_nullable
              as int,
      refreshSec: null == refreshSec
          ? _self.refreshSec
          : refreshSec // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
