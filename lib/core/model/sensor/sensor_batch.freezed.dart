// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClockInfo {
  @JsonKey(name: 'boot_id')
  String get bootId;
  @JsonKey(name: 'clock_mapping_id')
  String get clockMappingId;
  @JsonKey(name: 'anchor_elapsed_ns')
  String get anchorElapsedNs;
  @JsonKey(name: 'anchor_epoch_ms')
  int get anchorEpochMs;
  @JsonKey(name: 'uncertainty_ms')
  double get uncertaintyMs;

  /// Create a copy of ClockInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClockInfoCopyWith<ClockInfo> get copyWith =>
      _$ClockInfoCopyWithImpl<ClockInfo>(this as ClockInfo, _$identity);

  /// Serializes this ClockInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClockInfo &&
            (identical(other.bootId, bootId) || other.bootId == bootId) &&
            (identical(other.clockMappingId, clockMappingId) ||
                other.clockMappingId == clockMappingId) &&
            (identical(other.anchorElapsedNs, anchorElapsedNs) ||
                other.anchorElapsedNs == anchorElapsedNs) &&
            (identical(other.anchorEpochMs, anchorEpochMs) ||
                other.anchorEpochMs == anchorEpochMs) &&
            (identical(other.uncertaintyMs, uncertaintyMs) ||
                other.uncertaintyMs == uncertaintyMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bootId, clockMappingId,
      anchorElapsedNs, anchorEpochMs, uncertaintyMs);

  @override
  String toString() {
    return 'ClockInfo(bootId: $bootId, clockMappingId: $clockMappingId, anchorElapsedNs: $anchorElapsedNs, anchorEpochMs: $anchorEpochMs, uncertaintyMs: $uncertaintyMs)';
  }
}

/// @nodoc
abstract mixin class $ClockInfoCopyWith<$Res> {
  factory $ClockInfoCopyWith(ClockInfo value, $Res Function(ClockInfo) _then) =
      _$ClockInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'boot_id') String bootId,
      @JsonKey(name: 'clock_mapping_id') String clockMappingId,
      @JsonKey(name: 'anchor_elapsed_ns') String anchorElapsedNs,
      @JsonKey(name: 'anchor_epoch_ms') int anchorEpochMs,
      @JsonKey(name: 'uncertainty_ms') double uncertaintyMs});
}

/// @nodoc
class _$ClockInfoCopyWithImpl<$Res> implements $ClockInfoCopyWith<$Res> {
  _$ClockInfoCopyWithImpl(this._self, this._then);

  final ClockInfo _self;
  final $Res Function(ClockInfo) _then;

  /// Create a copy of ClockInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bootId = null,
    Object? clockMappingId = null,
    Object? anchorElapsedNs = null,
    Object? anchorEpochMs = null,
    Object? uncertaintyMs = null,
  }) {
    return _then(_self.copyWith(
      bootId: null == bootId
          ? _self.bootId
          : bootId // ignore: cast_nullable_to_non_nullable
              as String,
      clockMappingId: null == clockMappingId
          ? _self.clockMappingId
          : clockMappingId // ignore: cast_nullable_to_non_nullable
              as String,
      anchorElapsedNs: null == anchorElapsedNs
          ? _self.anchorElapsedNs
          : anchorElapsedNs // ignore: cast_nullable_to_non_nullable
              as String,
      anchorEpochMs: null == anchorEpochMs
          ? _self.anchorEpochMs
          : anchorEpochMs // ignore: cast_nullable_to_non_nullable
              as int,
      uncertaintyMs: null == uncertaintyMs
          ? _self.uncertaintyMs
          : uncertaintyMs // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ClockInfo].
extension ClockInfoPatterns on ClockInfo {
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
    TResult Function(_ClockInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClockInfo() when $default != null:
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
    TResult Function(_ClockInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClockInfo():
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
    TResult? Function(_ClockInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClockInfo() when $default != null:
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
            @JsonKey(name: 'boot_id') String bootId,
            @JsonKey(name: 'clock_mapping_id') String clockMappingId,
            @JsonKey(name: 'anchor_elapsed_ns') String anchorElapsedNs,
            @JsonKey(name: 'anchor_epoch_ms') int anchorEpochMs,
            @JsonKey(name: 'uncertainty_ms') double uncertaintyMs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClockInfo() when $default != null:
        return $default(_that.bootId, _that.clockMappingId,
            _that.anchorElapsedNs, _that.anchorEpochMs, _that.uncertaintyMs);
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
            @JsonKey(name: 'boot_id') String bootId,
            @JsonKey(name: 'clock_mapping_id') String clockMappingId,
            @JsonKey(name: 'anchor_elapsed_ns') String anchorElapsedNs,
            @JsonKey(name: 'anchor_epoch_ms') int anchorEpochMs,
            @JsonKey(name: 'uncertainty_ms') double uncertaintyMs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClockInfo():
        return $default(_that.bootId, _that.clockMappingId,
            _that.anchorElapsedNs, _that.anchorEpochMs, _that.uncertaintyMs);
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
            @JsonKey(name: 'boot_id') String bootId,
            @JsonKey(name: 'clock_mapping_id') String clockMappingId,
            @JsonKey(name: 'anchor_elapsed_ns') String anchorElapsedNs,
            @JsonKey(name: 'anchor_epoch_ms') int anchorEpochMs,
            @JsonKey(name: 'uncertainty_ms') double uncertaintyMs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClockInfo() when $default != null:
        return $default(_that.bootId, _that.clockMappingId,
            _that.anchorElapsedNs, _that.anchorEpochMs, _that.uncertaintyMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ClockInfo implements ClockInfo {
  const _ClockInfo(
      {@JsonKey(name: 'boot_id') required this.bootId,
      @JsonKey(name: 'clock_mapping_id') required this.clockMappingId,
      @JsonKey(name: 'anchor_elapsed_ns') required this.anchorElapsedNs,
      @JsonKey(name: 'anchor_epoch_ms') required this.anchorEpochMs,
      @JsonKey(name: 'uncertainty_ms') required this.uncertaintyMs});
  factory _ClockInfo.fromJson(Map<String, dynamic> json) =>
      _$ClockInfoFromJson(json);

  @override
  @JsonKey(name: 'boot_id')
  final String bootId;
  @override
  @JsonKey(name: 'clock_mapping_id')
  final String clockMappingId;
  @override
  @JsonKey(name: 'anchor_elapsed_ns')
  final String anchorElapsedNs;
  @override
  @JsonKey(name: 'anchor_epoch_ms')
  final int anchorEpochMs;
  @override
  @JsonKey(name: 'uncertainty_ms')
  final double uncertaintyMs;

  /// Create a copy of ClockInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ClockInfoCopyWith<_ClockInfo> get copyWith =>
      __$ClockInfoCopyWithImpl<_ClockInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ClockInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ClockInfo &&
            (identical(other.bootId, bootId) || other.bootId == bootId) &&
            (identical(other.clockMappingId, clockMappingId) ||
                other.clockMappingId == clockMappingId) &&
            (identical(other.anchorElapsedNs, anchorElapsedNs) ||
                other.anchorElapsedNs == anchorElapsedNs) &&
            (identical(other.anchorEpochMs, anchorEpochMs) ||
                other.anchorEpochMs == anchorEpochMs) &&
            (identical(other.uncertaintyMs, uncertaintyMs) ||
                other.uncertaintyMs == uncertaintyMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bootId, clockMappingId,
      anchorElapsedNs, anchorEpochMs, uncertaintyMs);

  @override
  String toString() {
    return 'ClockInfo(bootId: $bootId, clockMappingId: $clockMappingId, anchorElapsedNs: $anchorElapsedNs, anchorEpochMs: $anchorEpochMs, uncertaintyMs: $uncertaintyMs)';
  }
}

/// @nodoc
abstract mixin class _$ClockInfoCopyWith<$Res>
    implements $ClockInfoCopyWith<$Res> {
  factory _$ClockInfoCopyWith(
          _ClockInfo value, $Res Function(_ClockInfo) _then) =
      __$ClockInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'boot_id') String bootId,
      @JsonKey(name: 'clock_mapping_id') String clockMappingId,
      @JsonKey(name: 'anchor_elapsed_ns') String anchorElapsedNs,
      @JsonKey(name: 'anchor_epoch_ms') int anchorEpochMs,
      @JsonKey(name: 'uncertainty_ms') double uncertaintyMs});
}

/// @nodoc
class __$ClockInfoCopyWithImpl<$Res> implements _$ClockInfoCopyWith<$Res> {
  __$ClockInfoCopyWithImpl(this._self, this._then);

  final _ClockInfo _self;
  final $Res Function(_ClockInfo) _then;

  /// Create a copy of ClockInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bootId = null,
    Object? clockMappingId = null,
    Object? anchorElapsedNs = null,
    Object? anchorEpochMs = null,
    Object? uncertaintyMs = null,
  }) {
    return _then(_ClockInfo(
      bootId: null == bootId
          ? _self.bootId
          : bootId // ignore: cast_nullable_to_non_nullable
              as String,
      clockMappingId: null == clockMappingId
          ? _self.clockMappingId
          : clockMappingId // ignore: cast_nullable_to_non_nullable
              as String,
      anchorElapsedNs: null == anchorElapsedNs
          ? _self.anchorElapsedNs
          : anchorElapsedNs // ignore: cast_nullable_to_non_nullable
              as String,
      anchorEpochMs: null == anchorEpochMs
          ? _self.anchorEpochMs
          : anchorEpochMs // ignore: cast_nullable_to_non_nullable
              as int,
      uncertaintyMs: null == uncertaintyMs
          ? _self.uncertaintyMs
          : uncertaintyMs // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$AccSeries {
  @JsonKey(name: 'fs_hz_requested')
  int get fsHzRequested;
  int get n;
  @JsonKey(name: 't0_elapsed_ns')
  String get t0ElapsedNs;
  @JsonKey(name: 'dt_ns')
  List<int> get dtNs;
  List<List<int>> get mg;

  /// Create a copy of AccSeries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccSeriesCopyWith<AccSeries> get copyWith =>
      _$AccSeriesCopyWithImpl<AccSeries>(this as AccSeries, _$identity);

  /// Serializes this AccSeries to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccSeries &&
            (identical(other.fsHzRequested, fsHzRequested) ||
                other.fsHzRequested == fsHzRequested) &&
            (identical(other.n, n) || other.n == n) &&
            (identical(other.t0ElapsedNs, t0ElapsedNs) ||
                other.t0ElapsedNs == t0ElapsedNs) &&
            const DeepCollectionEquality().equals(other.dtNs, dtNs) &&
            const DeepCollectionEquality().equals(other.mg, mg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fsHzRequested,
      n,
      t0ElapsedNs,
      const DeepCollectionEquality().hash(dtNs),
      const DeepCollectionEquality().hash(mg));

  @override
  String toString() {
    return 'AccSeries(fsHzRequested: $fsHzRequested, n: $n, t0ElapsedNs: $t0ElapsedNs, dtNs: $dtNs, mg: $mg)';
  }
}

/// @nodoc
abstract mixin class $AccSeriesCopyWith<$Res> {
  factory $AccSeriesCopyWith(AccSeries value, $Res Function(AccSeries) _then) =
      _$AccSeriesCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'fs_hz_requested') int fsHzRequested,
      int n,
      @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
      @JsonKey(name: 'dt_ns') List<int> dtNs,
      List<List<int>> mg});
}

/// @nodoc
class _$AccSeriesCopyWithImpl<$Res> implements $AccSeriesCopyWith<$Res> {
  _$AccSeriesCopyWithImpl(this._self, this._then);

  final AccSeries _self;
  final $Res Function(AccSeries) _then;

  /// Create a copy of AccSeries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fsHzRequested = null,
    Object? n = null,
    Object? t0ElapsedNs = null,
    Object? dtNs = null,
    Object? mg = null,
  }) {
    return _then(_self.copyWith(
      fsHzRequested: null == fsHzRequested
          ? _self.fsHzRequested
          : fsHzRequested // ignore: cast_nullable_to_non_nullable
              as int,
      n: null == n
          ? _self.n
          : n // ignore: cast_nullable_to_non_nullable
              as int,
      t0ElapsedNs: null == t0ElapsedNs
          ? _self.t0ElapsedNs
          : t0ElapsedNs // ignore: cast_nullable_to_non_nullable
              as String,
      dtNs: null == dtNs
          ? _self.dtNs
          : dtNs // ignore: cast_nullable_to_non_nullable
              as List<int>,
      mg: null == mg
          ? _self.mg
          : mg // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AccSeries].
extension AccSeriesPatterns on AccSeries {
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
    TResult Function(_AccSeries value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccSeries() when $default != null:
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
    TResult Function(_AccSeries value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccSeries():
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
    TResult? Function(_AccSeries value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccSeries() when $default != null:
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
            @JsonKey(name: 'fs_hz_requested') int fsHzRequested,
            int n,
            @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
            @JsonKey(name: 'dt_ns') List<int> dtNs,
            List<List<int>> mg)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccSeries() when $default != null:
        return $default(_that.fsHzRequested, _that.n, _that.t0ElapsedNs,
            _that.dtNs, _that.mg);
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
            @JsonKey(name: 'fs_hz_requested') int fsHzRequested,
            int n,
            @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
            @JsonKey(name: 'dt_ns') List<int> dtNs,
            List<List<int>> mg)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccSeries():
        return $default(_that.fsHzRequested, _that.n, _that.t0ElapsedNs,
            _that.dtNs, _that.mg);
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
            @JsonKey(name: 'fs_hz_requested') int fsHzRequested,
            int n,
            @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
            @JsonKey(name: 'dt_ns') List<int> dtNs,
            List<List<int>> mg)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccSeries() when $default != null:
        return $default(_that.fsHzRequested, _that.n, _that.t0ElapsedNs,
            _that.dtNs, _that.mg);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccSeries implements AccSeries {
  const _AccSeries(
      {@JsonKey(name: 'fs_hz_requested') required this.fsHzRequested,
      required this.n,
      @JsonKey(name: 't0_elapsed_ns') required this.t0ElapsedNs,
      @JsonKey(name: 'dt_ns') required final List<int> dtNs,
      required final List<List<int>> mg})
      : _dtNs = dtNs,
        _mg = mg;
  factory _AccSeries.fromJson(Map<String, dynamic> json) =>
      _$AccSeriesFromJson(json);

  @override
  @JsonKey(name: 'fs_hz_requested')
  final int fsHzRequested;
  @override
  final int n;
  @override
  @JsonKey(name: 't0_elapsed_ns')
  final String t0ElapsedNs;
  final List<int> _dtNs;
  @override
  @JsonKey(name: 'dt_ns')
  List<int> get dtNs {
    if (_dtNs is EqualUnmodifiableListView) return _dtNs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dtNs);
  }

  final List<List<int>> _mg;
  @override
  List<List<int>> get mg {
    if (_mg is EqualUnmodifiableListView) return _mg;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mg);
  }

  /// Create a copy of AccSeries
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccSeriesCopyWith<_AccSeries> get copyWith =>
      __$AccSeriesCopyWithImpl<_AccSeries>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccSeriesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccSeries &&
            (identical(other.fsHzRequested, fsHzRequested) ||
                other.fsHzRequested == fsHzRequested) &&
            (identical(other.n, n) || other.n == n) &&
            (identical(other.t0ElapsedNs, t0ElapsedNs) ||
                other.t0ElapsedNs == t0ElapsedNs) &&
            const DeepCollectionEquality().equals(other._dtNs, _dtNs) &&
            const DeepCollectionEquality().equals(other._mg, _mg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fsHzRequested,
      n,
      t0ElapsedNs,
      const DeepCollectionEquality().hash(_dtNs),
      const DeepCollectionEquality().hash(_mg));

  @override
  String toString() {
    return 'AccSeries(fsHzRequested: $fsHzRequested, n: $n, t0ElapsedNs: $t0ElapsedNs, dtNs: $dtNs, mg: $mg)';
  }
}

/// @nodoc
abstract mixin class _$AccSeriesCopyWith<$Res>
    implements $AccSeriesCopyWith<$Res> {
  factory _$AccSeriesCopyWith(
          _AccSeries value, $Res Function(_AccSeries) _then) =
      __$AccSeriesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'fs_hz_requested') int fsHzRequested,
      int n,
      @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
      @JsonKey(name: 'dt_ns') List<int> dtNs,
      List<List<int>> mg});
}

/// @nodoc
class __$AccSeriesCopyWithImpl<$Res> implements _$AccSeriesCopyWith<$Res> {
  __$AccSeriesCopyWithImpl(this._self, this._then);

  final _AccSeries _self;
  final $Res Function(_AccSeries) _then;

  /// Create a copy of AccSeries
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fsHzRequested = null,
    Object? n = null,
    Object? t0ElapsedNs = null,
    Object? dtNs = null,
    Object? mg = null,
  }) {
    return _then(_AccSeries(
      fsHzRequested: null == fsHzRequested
          ? _self.fsHzRequested
          : fsHzRequested // ignore: cast_nullable_to_non_nullable
              as int,
      n: null == n
          ? _self.n
          : n // ignore: cast_nullable_to_non_nullable
              as int,
      t0ElapsedNs: null == t0ElapsedNs
          ? _self.t0ElapsedNs
          : t0ElapsedNs // ignore: cast_nullable_to_non_nullable
              as String,
      dtNs: null == dtNs
          ? _self._dtNs
          : dtNs // ignore: cast_nullable_to_non_nullable
              as List<int>,
      mg: null == mg
          ? _self._mg
          : mg // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
    ));
  }
}

/// @nodoc
mixin _$GyroSeries {
  @JsonKey(name: 'fs_hz_requested')
  int get fsHzRequested;
  int get n;
  @JsonKey(name: 't0_elapsed_ns')
  String get t0ElapsedNs;
  @JsonKey(name: 'dt_ns')
  List<int> get dtNs;
  List<List<int>> get mrads;

  /// Create a copy of GyroSeries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GyroSeriesCopyWith<GyroSeries> get copyWith =>
      _$GyroSeriesCopyWithImpl<GyroSeries>(this as GyroSeries, _$identity);

  /// Serializes this GyroSeries to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GyroSeries &&
            (identical(other.fsHzRequested, fsHzRequested) ||
                other.fsHzRequested == fsHzRequested) &&
            (identical(other.n, n) || other.n == n) &&
            (identical(other.t0ElapsedNs, t0ElapsedNs) ||
                other.t0ElapsedNs == t0ElapsedNs) &&
            const DeepCollectionEquality().equals(other.dtNs, dtNs) &&
            const DeepCollectionEquality().equals(other.mrads, mrads));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fsHzRequested,
      n,
      t0ElapsedNs,
      const DeepCollectionEquality().hash(dtNs),
      const DeepCollectionEquality().hash(mrads));

  @override
  String toString() {
    return 'GyroSeries(fsHzRequested: $fsHzRequested, n: $n, t0ElapsedNs: $t0ElapsedNs, dtNs: $dtNs, mrads: $mrads)';
  }
}

/// @nodoc
abstract mixin class $GyroSeriesCopyWith<$Res> {
  factory $GyroSeriesCopyWith(
          GyroSeries value, $Res Function(GyroSeries) _then) =
      _$GyroSeriesCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'fs_hz_requested') int fsHzRequested,
      int n,
      @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
      @JsonKey(name: 'dt_ns') List<int> dtNs,
      List<List<int>> mrads});
}

/// @nodoc
class _$GyroSeriesCopyWithImpl<$Res> implements $GyroSeriesCopyWith<$Res> {
  _$GyroSeriesCopyWithImpl(this._self, this._then);

  final GyroSeries _self;
  final $Res Function(GyroSeries) _then;

  /// Create a copy of GyroSeries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fsHzRequested = null,
    Object? n = null,
    Object? t0ElapsedNs = null,
    Object? dtNs = null,
    Object? mrads = null,
  }) {
    return _then(_self.copyWith(
      fsHzRequested: null == fsHzRequested
          ? _self.fsHzRequested
          : fsHzRequested // ignore: cast_nullable_to_non_nullable
              as int,
      n: null == n
          ? _self.n
          : n // ignore: cast_nullable_to_non_nullable
              as int,
      t0ElapsedNs: null == t0ElapsedNs
          ? _self.t0ElapsedNs
          : t0ElapsedNs // ignore: cast_nullable_to_non_nullable
              as String,
      dtNs: null == dtNs
          ? _self.dtNs
          : dtNs // ignore: cast_nullable_to_non_nullable
              as List<int>,
      mrads: null == mrads
          ? _self.mrads
          : mrads // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
    ));
  }
}

/// Adds pattern-matching-related methods to [GyroSeries].
extension GyroSeriesPatterns on GyroSeries {
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
    TResult Function(_GyroSeries value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GyroSeries() when $default != null:
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
    TResult Function(_GyroSeries value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GyroSeries():
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
    TResult? Function(_GyroSeries value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GyroSeries() when $default != null:
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
            @JsonKey(name: 'fs_hz_requested') int fsHzRequested,
            int n,
            @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
            @JsonKey(name: 'dt_ns') List<int> dtNs,
            List<List<int>> mrads)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GyroSeries() when $default != null:
        return $default(_that.fsHzRequested, _that.n, _that.t0ElapsedNs,
            _that.dtNs, _that.mrads);
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
            @JsonKey(name: 'fs_hz_requested') int fsHzRequested,
            int n,
            @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
            @JsonKey(name: 'dt_ns') List<int> dtNs,
            List<List<int>> mrads)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GyroSeries():
        return $default(_that.fsHzRequested, _that.n, _that.t0ElapsedNs,
            _that.dtNs, _that.mrads);
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
            @JsonKey(name: 'fs_hz_requested') int fsHzRequested,
            int n,
            @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
            @JsonKey(name: 'dt_ns') List<int> dtNs,
            List<List<int>> mrads)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GyroSeries() when $default != null:
        return $default(_that.fsHzRequested, _that.n, _that.t0ElapsedNs,
            _that.dtNs, _that.mrads);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GyroSeries implements GyroSeries {
  const _GyroSeries(
      {@JsonKey(name: 'fs_hz_requested') required this.fsHzRequested,
      required this.n,
      @JsonKey(name: 't0_elapsed_ns') required this.t0ElapsedNs,
      @JsonKey(name: 'dt_ns') required final List<int> dtNs,
      required final List<List<int>> mrads})
      : _dtNs = dtNs,
        _mrads = mrads;
  factory _GyroSeries.fromJson(Map<String, dynamic> json) =>
      _$GyroSeriesFromJson(json);

  @override
  @JsonKey(name: 'fs_hz_requested')
  final int fsHzRequested;
  @override
  final int n;
  @override
  @JsonKey(name: 't0_elapsed_ns')
  final String t0ElapsedNs;
  final List<int> _dtNs;
  @override
  @JsonKey(name: 'dt_ns')
  List<int> get dtNs {
    if (_dtNs is EqualUnmodifiableListView) return _dtNs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dtNs);
  }

  final List<List<int>> _mrads;
  @override
  List<List<int>> get mrads {
    if (_mrads is EqualUnmodifiableListView) return _mrads;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mrads);
  }

  /// Create a copy of GyroSeries
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GyroSeriesCopyWith<_GyroSeries> get copyWith =>
      __$GyroSeriesCopyWithImpl<_GyroSeries>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GyroSeriesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GyroSeries &&
            (identical(other.fsHzRequested, fsHzRequested) ||
                other.fsHzRequested == fsHzRequested) &&
            (identical(other.n, n) || other.n == n) &&
            (identical(other.t0ElapsedNs, t0ElapsedNs) ||
                other.t0ElapsedNs == t0ElapsedNs) &&
            const DeepCollectionEquality().equals(other._dtNs, _dtNs) &&
            const DeepCollectionEquality().equals(other._mrads, _mrads));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fsHzRequested,
      n,
      t0ElapsedNs,
      const DeepCollectionEquality().hash(_dtNs),
      const DeepCollectionEquality().hash(_mrads));

  @override
  String toString() {
    return 'GyroSeries(fsHzRequested: $fsHzRequested, n: $n, t0ElapsedNs: $t0ElapsedNs, dtNs: $dtNs, mrads: $mrads)';
  }
}

/// @nodoc
abstract mixin class _$GyroSeriesCopyWith<$Res>
    implements $GyroSeriesCopyWith<$Res> {
  factory _$GyroSeriesCopyWith(
          _GyroSeries value, $Res Function(_GyroSeries) _then) =
      __$GyroSeriesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'fs_hz_requested') int fsHzRequested,
      int n,
      @JsonKey(name: 't0_elapsed_ns') String t0ElapsedNs,
      @JsonKey(name: 'dt_ns') List<int> dtNs,
      List<List<int>> mrads});
}

/// @nodoc
class __$GyroSeriesCopyWithImpl<$Res> implements _$GyroSeriesCopyWith<$Res> {
  __$GyroSeriesCopyWithImpl(this._self, this._then);

  final _GyroSeries _self;
  final $Res Function(_GyroSeries) _then;

  /// Create a copy of GyroSeries
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fsHzRequested = null,
    Object? n = null,
    Object? t0ElapsedNs = null,
    Object? dtNs = null,
    Object? mrads = null,
  }) {
    return _then(_GyroSeries(
      fsHzRequested: null == fsHzRequested
          ? _self.fsHzRequested
          : fsHzRequested // ignore: cast_nullable_to_non_nullable
              as int,
      n: null == n
          ? _self.n
          : n // ignore: cast_nullable_to_non_nullable
              as int,
      t0ElapsedNs: null == t0ElapsedNs
          ? _self.t0ElapsedNs
          : t0ElapsedNs // ignore: cast_nullable_to_non_nullable
              as String,
      dtNs: null == dtNs
          ? _self._dtNs
          : dtNs // ignore: cast_nullable_to_non_nullable
              as List<int>,
      mrads: null == mrads
          ? _self._mrads
          : mrads // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
    ));
  }
}

/// @nodoc
mixin _$ImpactTrigger {
  String get kind;
  @JsonKey(name: 'smv_g')
  double get smvG;
  @JsonKey(name: 'event_elapsed_ns')
  String get eventElapsedNs;
  @JsonKey(name: 'ts_ms')
  int get tsMs;

  /// Create a copy of ImpactTrigger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImpactTriggerCopyWith<ImpactTrigger> get copyWith =>
      _$ImpactTriggerCopyWithImpl<ImpactTrigger>(
          this as ImpactTrigger, _$identity);

  /// Serializes this ImpactTrigger to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImpactTrigger &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.smvG, smvG) || other.smvG == smvG) &&
            (identical(other.eventElapsedNs, eventElapsedNs) ||
                other.eventElapsedNs == eventElapsedNs) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, kind, smvG, eventElapsedNs, tsMs);

  @override
  String toString() {
    return 'ImpactTrigger(kind: $kind, smvG: $smvG, eventElapsedNs: $eventElapsedNs, tsMs: $tsMs)';
  }
}

/// @nodoc
abstract mixin class $ImpactTriggerCopyWith<$Res> {
  factory $ImpactTriggerCopyWith(
          ImpactTrigger value, $Res Function(ImpactTrigger) _then) =
      _$ImpactTriggerCopyWithImpl;
  @useResult
  $Res call(
      {String kind,
      @JsonKey(name: 'smv_g') double smvG,
      @JsonKey(name: 'event_elapsed_ns') String eventElapsedNs,
      @JsonKey(name: 'ts_ms') int tsMs});
}

/// @nodoc
class _$ImpactTriggerCopyWithImpl<$Res>
    implements $ImpactTriggerCopyWith<$Res> {
  _$ImpactTriggerCopyWithImpl(this._self, this._then);

  final ImpactTrigger _self;
  final $Res Function(ImpactTrigger) _then;

  /// Create a copy of ImpactTrigger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? smvG = null,
    Object? eventElapsedNs = null,
    Object? tsMs = null,
  }) {
    return _then(_self.copyWith(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      smvG: null == smvG
          ? _self.smvG
          : smvG // ignore: cast_nullable_to_non_nullable
              as double,
      eventElapsedNs: null == eventElapsedNs
          ? _self.eventElapsedNs
          : eventElapsedNs // ignore: cast_nullable_to_non_nullable
              as String,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ImpactTrigger].
extension ImpactTriggerPatterns on ImpactTrigger {
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
    TResult Function(_ImpactTrigger value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImpactTrigger() when $default != null:
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
    TResult Function(_ImpactTrigger value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImpactTrigger():
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
    TResult? Function(_ImpactTrigger value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImpactTrigger() when $default != null:
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
            String kind,
            @JsonKey(name: 'smv_g') double smvG,
            @JsonKey(name: 'event_elapsed_ns') String eventElapsedNs,
            @JsonKey(name: 'ts_ms') int tsMs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImpactTrigger() when $default != null:
        return $default(
            _that.kind, _that.smvG, _that.eventElapsedNs, _that.tsMs);
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
            String kind,
            @JsonKey(name: 'smv_g') double smvG,
            @JsonKey(name: 'event_elapsed_ns') String eventElapsedNs,
            @JsonKey(name: 'ts_ms') int tsMs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImpactTrigger():
        return $default(
            _that.kind, _that.smvG, _that.eventElapsedNs, _that.tsMs);
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
            String kind,
            @JsonKey(name: 'smv_g') double smvG,
            @JsonKey(name: 'event_elapsed_ns') String eventElapsedNs,
            @JsonKey(name: 'ts_ms') int tsMs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImpactTrigger() when $default != null:
        return $default(
            _that.kind, _that.smvG, _that.eventElapsedNs, _that.tsMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ImpactTrigger implements ImpactTrigger {
  const _ImpactTrigger(
      {required this.kind,
      @JsonKey(name: 'smv_g') required this.smvG,
      @JsonKey(name: 'event_elapsed_ns') required this.eventElapsedNs,
      @JsonKey(name: 'ts_ms') required this.tsMs});
  factory _ImpactTrigger.fromJson(Map<String, dynamic> json) =>
      _$ImpactTriggerFromJson(json);

  @override
  final String kind;
  @override
  @JsonKey(name: 'smv_g')
  final double smvG;
  @override
  @JsonKey(name: 'event_elapsed_ns')
  final String eventElapsedNs;
  @override
  @JsonKey(name: 'ts_ms')
  final int tsMs;

  /// Create a copy of ImpactTrigger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ImpactTriggerCopyWith<_ImpactTrigger> get copyWith =>
      __$ImpactTriggerCopyWithImpl<_ImpactTrigger>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ImpactTriggerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ImpactTrigger &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.smvG, smvG) || other.smvG == smvG) &&
            (identical(other.eventElapsedNs, eventElapsedNs) ||
                other.eventElapsedNs == eventElapsedNs) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, kind, smvG, eventElapsedNs, tsMs);

  @override
  String toString() {
    return 'ImpactTrigger(kind: $kind, smvG: $smvG, eventElapsedNs: $eventElapsedNs, tsMs: $tsMs)';
  }
}

/// @nodoc
abstract mixin class _$ImpactTriggerCopyWith<$Res>
    implements $ImpactTriggerCopyWith<$Res> {
  factory _$ImpactTriggerCopyWith(
          _ImpactTrigger value, $Res Function(_ImpactTrigger) _then) =
      __$ImpactTriggerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String kind,
      @JsonKey(name: 'smv_g') double smvG,
      @JsonKey(name: 'event_elapsed_ns') String eventElapsedNs,
      @JsonKey(name: 'ts_ms') int tsMs});
}

/// @nodoc
class __$ImpactTriggerCopyWithImpl<$Res>
    implements _$ImpactTriggerCopyWith<$Res> {
  __$ImpactTriggerCopyWithImpl(this._self, this._then);

  final _ImpactTrigger _self;
  final $Res Function(_ImpactTrigger) _then;

  /// Create a copy of ImpactTrigger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kind = null,
    Object? smvG = null,
    Object? eventElapsedNs = null,
    Object? tsMs = null,
  }) {
    return _then(_ImpactTrigger(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      smvG: null == smvG
          ? _self.smvG
          : smvG // ignore: cast_nullable_to_non_nullable
              as double,
      eventElapsedNs: null == eventElapsedNs
          ? _self.eventElapsedNs
          : eventElapsedNs // ignore: cast_nullable_to_non_nullable
              as String,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ResendInfo {
  @JsonKey(name: 'is_resend')
  bool get isResend;
  @JsonKey(name: 'original_batch_id')
  String get originalBatchId;
  @JsonKey(name: 'original_seq')
  int get originalSeq;
  @JsonKey(name: 'original_run_id')
  String? get originalRunId;
  @JsonKey(name: 'original_session_id')
  String get originalSessionId;
  @JsonKey(name: 'resent_at_ms')
  int get resentAtMs;

  /// Create a copy of ResendInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResendInfoCopyWith<ResendInfo> get copyWith =>
      _$ResendInfoCopyWithImpl<ResendInfo>(this as ResendInfo, _$identity);

  /// Serializes this ResendInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResendInfo &&
            (identical(other.isResend, isResend) ||
                other.isResend == isResend) &&
            (identical(other.originalBatchId, originalBatchId) ||
                other.originalBatchId == originalBatchId) &&
            (identical(other.originalSeq, originalSeq) ||
                other.originalSeq == originalSeq) &&
            (identical(other.originalRunId, originalRunId) ||
                other.originalRunId == originalRunId) &&
            (identical(other.originalSessionId, originalSessionId) ||
                other.originalSessionId == originalSessionId) &&
            (identical(other.resentAtMs, resentAtMs) ||
                other.resentAtMs == resentAtMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isResend, originalBatchId,
      originalSeq, originalRunId, originalSessionId, resentAtMs);

  @override
  String toString() {
    return 'ResendInfo(isResend: $isResend, originalBatchId: $originalBatchId, originalSeq: $originalSeq, originalRunId: $originalRunId, originalSessionId: $originalSessionId, resentAtMs: $resentAtMs)';
  }
}

/// @nodoc
abstract mixin class $ResendInfoCopyWith<$Res> {
  factory $ResendInfoCopyWith(
          ResendInfo value, $Res Function(ResendInfo) _then) =
      _$ResendInfoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'is_resend') bool isResend,
      @JsonKey(name: 'original_batch_id') String originalBatchId,
      @JsonKey(name: 'original_seq') int originalSeq,
      @JsonKey(name: 'original_run_id') String? originalRunId,
      @JsonKey(name: 'original_session_id') String originalSessionId,
      @JsonKey(name: 'resent_at_ms') int resentAtMs});
}

/// @nodoc
class _$ResendInfoCopyWithImpl<$Res> implements $ResendInfoCopyWith<$Res> {
  _$ResendInfoCopyWithImpl(this._self, this._then);

  final ResendInfo _self;
  final $Res Function(ResendInfo) _then;

  /// Create a copy of ResendInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isResend = null,
    Object? originalBatchId = null,
    Object? originalSeq = null,
    Object? originalRunId = freezed,
    Object? originalSessionId = null,
    Object? resentAtMs = null,
  }) {
    return _then(_self.copyWith(
      isResend: null == isResend
          ? _self.isResend
          : isResend // ignore: cast_nullable_to_non_nullable
              as bool,
      originalBatchId: null == originalBatchId
          ? _self.originalBatchId
          : originalBatchId // ignore: cast_nullable_to_non_nullable
              as String,
      originalSeq: null == originalSeq
          ? _self.originalSeq
          : originalSeq // ignore: cast_nullable_to_non_nullable
              as int,
      originalRunId: freezed == originalRunId
          ? _self.originalRunId
          : originalRunId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalSessionId: null == originalSessionId
          ? _self.originalSessionId
          : originalSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      resentAtMs: null == resentAtMs
          ? _self.resentAtMs
          : resentAtMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ResendInfo].
extension ResendInfoPatterns on ResendInfo {
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
    TResult Function(_ResendInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResendInfo() when $default != null:
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
    TResult Function(_ResendInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResendInfo():
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
    TResult? Function(_ResendInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResendInfo() when $default != null:
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
            @JsonKey(name: 'is_resend') bool isResend,
            @JsonKey(name: 'original_batch_id') String originalBatchId,
            @JsonKey(name: 'original_seq') int originalSeq,
            @JsonKey(name: 'original_run_id') String? originalRunId,
            @JsonKey(name: 'original_session_id') String originalSessionId,
            @JsonKey(name: 'resent_at_ms') int resentAtMs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResendInfo() when $default != null:
        return $default(
            _that.isResend,
            _that.originalBatchId,
            _that.originalSeq,
            _that.originalRunId,
            _that.originalSessionId,
            _that.resentAtMs);
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
            @JsonKey(name: 'is_resend') bool isResend,
            @JsonKey(name: 'original_batch_id') String originalBatchId,
            @JsonKey(name: 'original_seq') int originalSeq,
            @JsonKey(name: 'original_run_id') String? originalRunId,
            @JsonKey(name: 'original_session_id') String originalSessionId,
            @JsonKey(name: 'resent_at_ms') int resentAtMs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResendInfo():
        return $default(
            _that.isResend,
            _that.originalBatchId,
            _that.originalSeq,
            _that.originalRunId,
            _that.originalSessionId,
            _that.resentAtMs);
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
            @JsonKey(name: 'is_resend') bool isResend,
            @JsonKey(name: 'original_batch_id') String originalBatchId,
            @JsonKey(name: 'original_seq') int originalSeq,
            @JsonKey(name: 'original_run_id') String? originalRunId,
            @JsonKey(name: 'original_session_id') String originalSessionId,
            @JsonKey(name: 'resent_at_ms') int resentAtMs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResendInfo() when $default != null:
        return $default(
            _that.isResend,
            _that.originalBatchId,
            _that.originalSeq,
            _that.originalRunId,
            _that.originalSessionId,
            _that.resentAtMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ResendInfo implements ResendInfo {
  const _ResendInfo(
      {@JsonKey(name: 'is_resend') required this.isResend,
      @JsonKey(name: 'original_batch_id') required this.originalBatchId,
      @JsonKey(name: 'original_seq') required this.originalSeq,
      @JsonKey(name: 'original_run_id') required this.originalRunId,
      @JsonKey(name: 'original_session_id') required this.originalSessionId,
      @JsonKey(name: 'resent_at_ms') required this.resentAtMs});
  factory _ResendInfo.fromJson(Map<String, dynamic> json) =>
      _$ResendInfoFromJson(json);

  @override
  @JsonKey(name: 'is_resend')
  final bool isResend;
  @override
  @JsonKey(name: 'original_batch_id')
  final String originalBatchId;
  @override
  @JsonKey(name: 'original_seq')
  final int originalSeq;
  @override
  @JsonKey(name: 'original_run_id')
  final String? originalRunId;
  @override
  @JsonKey(name: 'original_session_id')
  final String originalSessionId;
  @override
  @JsonKey(name: 'resent_at_ms')
  final int resentAtMs;

  /// Create a copy of ResendInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResendInfoCopyWith<_ResendInfo> get copyWith =>
      __$ResendInfoCopyWithImpl<_ResendInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ResendInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResendInfo &&
            (identical(other.isResend, isResend) ||
                other.isResend == isResend) &&
            (identical(other.originalBatchId, originalBatchId) ||
                other.originalBatchId == originalBatchId) &&
            (identical(other.originalSeq, originalSeq) ||
                other.originalSeq == originalSeq) &&
            (identical(other.originalRunId, originalRunId) ||
                other.originalRunId == originalRunId) &&
            (identical(other.originalSessionId, originalSessionId) ||
                other.originalSessionId == originalSessionId) &&
            (identical(other.resentAtMs, resentAtMs) ||
                other.resentAtMs == resentAtMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isResend, originalBatchId,
      originalSeq, originalRunId, originalSessionId, resentAtMs);

  @override
  String toString() {
    return 'ResendInfo(isResend: $isResend, originalBatchId: $originalBatchId, originalSeq: $originalSeq, originalRunId: $originalRunId, originalSessionId: $originalSessionId, resentAtMs: $resentAtMs)';
  }
}

/// @nodoc
abstract mixin class _$ResendInfoCopyWith<$Res>
    implements $ResendInfoCopyWith<$Res> {
  factory _$ResendInfoCopyWith(
          _ResendInfo value, $Res Function(_ResendInfo) _then) =
      __$ResendInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'is_resend') bool isResend,
      @JsonKey(name: 'original_batch_id') String originalBatchId,
      @JsonKey(name: 'original_seq') int originalSeq,
      @JsonKey(name: 'original_run_id') String? originalRunId,
      @JsonKey(name: 'original_session_id') String originalSessionId,
      @JsonKey(name: 'resent_at_ms') int resentAtMs});
}

/// @nodoc
class __$ResendInfoCopyWithImpl<$Res> implements _$ResendInfoCopyWith<$Res> {
  __$ResendInfoCopyWithImpl(this._self, this._then);

  final _ResendInfo _self;
  final $Res Function(_ResendInfo) _then;

  /// Create a copy of ResendInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isResend = null,
    Object? originalBatchId = null,
    Object? originalSeq = null,
    Object? originalRunId = freezed,
    Object? originalSessionId = null,
    Object? resentAtMs = null,
  }) {
    return _then(_ResendInfo(
      isResend: null == isResend
          ? _self.isResend
          : isResend // ignore: cast_nullable_to_non_nullable
              as bool,
      originalBatchId: null == originalBatchId
          ? _self.originalBatchId
          : originalBatchId // ignore: cast_nullable_to_non_nullable
              as String,
      originalSeq: null == originalSeq
          ? _self.originalSeq
          : originalSeq // ignore: cast_nullable_to_non_nullable
              as int,
      originalRunId: freezed == originalRunId
          ? _self.originalRunId
          : originalRunId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalSessionId: null == originalSessionId
          ? _self.originalSessionId
          : originalSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      resentAtMs: null == resentAtMs
          ? _self.resentAtMs
          : resentAtMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$SensorBatch {
  int get v;
  String get stream;
  String get source;
  @JsonKey(name: 'batch_id')
  String get batchId;
  @JsonKey(name: 'device_id')
  String get deviceId;
  @JsonKey(name: 'session_id')
  String get sessionId;
  int get seq;
  @JsonKey(name: 'study_id')
  String? get studyId;
  @JsonKey(name: 'participation_id')
  String? get participationId;
  @JsonKey(name: 'run_id')
  String? get runId;
  @JsonKey(toJson: _nestedToJson)
  ClockInfo get clock;
  @JsonKey(toJson: _nestedToJson)
  AccSeries? get acc;
  @JsonKey(toJson: _nestedToJson)
  GyroSeries? get gyro;
  @JsonKey(toJson: _nestedToJson)
  ImpactTrigger? get trigger;
  @JsonKey(name: 'gyro_backfill')
  bool get gyroBackfill;
  @JsonKey(name: 'backfill_for')
  String? get backfillFor;
  @JsonKey(toJson: _nestedToJson)
  ResendInfo? get resend;
  @JsonKey(name: 'collection_mode')
  String get collectionMode;
  @JsonKey(name: 'gyro_mode')
  String get gyroMode;
  @JsonKey(name: 'on_body')
  bool? get onBody;
  @JsonKey(name: 'wear_state')
  String? get wearState;
  @JsonKey(name: 'missing_reason')
  String? get missingReason;
  @JsonKey(name: 'watch_battery_pct')
  int? get watchBatteryPct;
  @JsonKey(name: 'phone_received_at_ms')
  int? get phoneReceivedAtMs;

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorBatchCopyWith<SensorBatch> get copyWith =>
      _$SensorBatchCopyWithImpl<SensorBatch>(this as SensorBatch, _$identity);

  /// Serializes this SensorBatch to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorBatch &&
            (identical(other.v, v) || other.v == v) &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.studyId, studyId) || other.studyId == studyId) &&
            (identical(other.participationId, participationId) ||
                other.participationId == participationId) &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.clock, clock) || other.clock == clock) &&
            (identical(other.acc, acc) || other.acc == acc) &&
            (identical(other.gyro, gyro) || other.gyro == gyro) &&
            (identical(other.trigger, trigger) || other.trigger == trigger) &&
            (identical(other.gyroBackfill, gyroBackfill) ||
                other.gyroBackfill == gyroBackfill) &&
            (identical(other.backfillFor, backfillFor) ||
                other.backfillFor == backfillFor) &&
            (identical(other.resend, resend) || other.resend == resend) &&
            (identical(other.collectionMode, collectionMode) ||
                other.collectionMode == collectionMode) &&
            (identical(other.gyroMode, gyroMode) ||
                other.gyroMode == gyroMode) &&
            (identical(other.onBody, onBody) || other.onBody == onBody) &&
            (identical(other.wearState, wearState) ||
                other.wearState == wearState) &&
            (identical(other.missingReason, missingReason) ||
                other.missingReason == missingReason) &&
            (identical(other.watchBatteryPct, watchBatteryPct) ||
                other.watchBatteryPct == watchBatteryPct) &&
            (identical(other.phoneReceivedAtMs, phoneReceivedAtMs) ||
                other.phoneReceivedAtMs == phoneReceivedAtMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        v,
        stream,
        source,
        batchId,
        deviceId,
        sessionId,
        seq,
        studyId,
        participationId,
        runId,
        clock,
        acc,
        gyro,
        trigger,
        gyroBackfill,
        backfillFor,
        resend,
        collectionMode,
        gyroMode,
        onBody,
        wearState,
        missingReason,
        watchBatteryPct,
        phoneReceivedAtMs
      ]);

  @override
  String toString() {
    return 'SensorBatch(v: $v, stream: $stream, source: $source, batchId: $batchId, deviceId: $deviceId, sessionId: $sessionId, seq: $seq, studyId: $studyId, participationId: $participationId, runId: $runId, clock: $clock, acc: $acc, gyro: $gyro, trigger: $trigger, gyroBackfill: $gyroBackfill, backfillFor: $backfillFor, resend: $resend, collectionMode: $collectionMode, gyroMode: $gyroMode, onBody: $onBody, wearState: $wearState, missingReason: $missingReason, watchBatteryPct: $watchBatteryPct, phoneReceivedAtMs: $phoneReceivedAtMs)';
  }
}

/// @nodoc
abstract mixin class $SensorBatchCopyWith<$Res> {
  factory $SensorBatchCopyWith(
          SensorBatch value, $Res Function(SensorBatch) _then) =
      _$SensorBatchCopyWithImpl;
  @useResult
  $Res call(
      {int v,
      String stream,
      String source,
      @JsonKey(name: 'batch_id') String batchId,
      @JsonKey(name: 'device_id') String deviceId,
      @JsonKey(name: 'session_id') String sessionId,
      int seq,
      @JsonKey(name: 'study_id') String? studyId,
      @JsonKey(name: 'participation_id') String? participationId,
      @JsonKey(name: 'run_id') String? runId,
      @JsonKey(toJson: _nestedToJson) ClockInfo clock,
      @JsonKey(toJson: _nestedToJson) AccSeries? acc,
      @JsonKey(toJson: _nestedToJson) GyroSeries? gyro,
      @JsonKey(toJson: _nestedToJson) ImpactTrigger? trigger,
      @JsonKey(name: 'gyro_backfill') bool gyroBackfill,
      @JsonKey(name: 'backfill_for') String? backfillFor,
      @JsonKey(toJson: _nestedToJson) ResendInfo? resend,
      @JsonKey(name: 'collection_mode') String collectionMode,
      @JsonKey(name: 'gyro_mode') String gyroMode,
      @JsonKey(name: 'on_body') bool? onBody,
      @JsonKey(name: 'wear_state') String? wearState,
      @JsonKey(name: 'missing_reason') String? missingReason,
      @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
      @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs});

  $ClockInfoCopyWith<$Res> get clock;
  $AccSeriesCopyWith<$Res>? get acc;
  $GyroSeriesCopyWith<$Res>? get gyro;
  $ImpactTriggerCopyWith<$Res>? get trigger;
  $ResendInfoCopyWith<$Res>? get resend;
}

/// @nodoc
class _$SensorBatchCopyWithImpl<$Res> implements $SensorBatchCopyWith<$Res> {
  _$SensorBatchCopyWithImpl(this._self, this._then);

  final SensorBatch _self;
  final $Res Function(SensorBatch) _then;

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? v = null,
    Object? stream = null,
    Object? source = null,
    Object? batchId = null,
    Object? deviceId = null,
    Object? sessionId = null,
    Object? seq = null,
    Object? studyId = freezed,
    Object? participationId = freezed,
    Object? runId = freezed,
    Object? clock = null,
    Object? acc = freezed,
    Object? gyro = freezed,
    Object? trigger = freezed,
    Object? gyroBackfill = null,
    Object? backfillFor = freezed,
    Object? resend = freezed,
    Object? collectionMode = null,
    Object? gyroMode = null,
    Object? onBody = freezed,
    Object? wearState = freezed,
    Object? missingReason = freezed,
    Object? watchBatteryPct = freezed,
    Object? phoneReceivedAtMs = freezed,
  }) {
    return _then(_self.copyWith(
      v: null == v
          ? _self.v
          : v // ignore: cast_nullable_to_non_nullable
              as int,
      stream: null == stream
          ? _self.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      batchId: null == batchId
          ? _self.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      seq: null == seq
          ? _self.seq
          : seq // ignore: cast_nullable_to_non_nullable
              as int,
      studyId: freezed == studyId
          ? _self.studyId
          : studyId // ignore: cast_nullable_to_non_nullable
              as String?,
      participationId: freezed == participationId
          ? _self.participationId
          : participationId // ignore: cast_nullable_to_non_nullable
              as String?,
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as String?,
      clock: null == clock
          ? _self.clock
          : clock // ignore: cast_nullable_to_non_nullable
              as ClockInfo,
      acc: freezed == acc
          ? _self.acc
          : acc // ignore: cast_nullable_to_non_nullable
              as AccSeries?,
      gyro: freezed == gyro
          ? _self.gyro
          : gyro // ignore: cast_nullable_to_non_nullable
              as GyroSeries?,
      trigger: freezed == trigger
          ? _self.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as ImpactTrigger?,
      gyroBackfill: null == gyroBackfill
          ? _self.gyroBackfill
          : gyroBackfill // ignore: cast_nullable_to_non_nullable
              as bool,
      backfillFor: freezed == backfillFor
          ? _self.backfillFor
          : backfillFor // ignore: cast_nullable_to_non_nullable
              as String?,
      resend: freezed == resend
          ? _self.resend
          : resend // ignore: cast_nullable_to_non_nullable
              as ResendInfo?,
      collectionMode: null == collectionMode
          ? _self.collectionMode
          : collectionMode // ignore: cast_nullable_to_non_nullable
              as String,
      gyroMode: null == gyroMode
          ? _self.gyroMode
          : gyroMode // ignore: cast_nullable_to_non_nullable
              as String,
      onBody: freezed == onBody
          ? _self.onBody
          : onBody // ignore: cast_nullable_to_non_nullable
              as bool?,
      wearState: freezed == wearState
          ? _self.wearState
          : wearState // ignore: cast_nullable_to_non_nullable
              as String?,
      missingReason: freezed == missingReason
          ? _self.missingReason
          : missingReason // ignore: cast_nullable_to_non_nullable
              as String?,
      watchBatteryPct: freezed == watchBatteryPct
          ? _self.watchBatteryPct
          : watchBatteryPct // ignore: cast_nullable_to_non_nullable
              as int?,
      phoneReceivedAtMs: freezed == phoneReceivedAtMs
          ? _self.phoneReceivedAtMs
          : phoneReceivedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClockInfoCopyWith<$Res> get clock {
    return $ClockInfoCopyWith<$Res>(_self.clock, (value) {
      return _then(_self.copyWith(clock: value));
    });
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccSeriesCopyWith<$Res>? get acc {
    if (_self.acc == null) {
      return null;
    }

    return $AccSeriesCopyWith<$Res>(_self.acc!, (value) {
      return _then(_self.copyWith(acc: value));
    });
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GyroSeriesCopyWith<$Res>? get gyro {
    if (_self.gyro == null) {
      return null;
    }

    return $GyroSeriesCopyWith<$Res>(_self.gyro!, (value) {
      return _then(_self.copyWith(gyro: value));
    });
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImpactTriggerCopyWith<$Res>? get trigger {
    if (_self.trigger == null) {
      return null;
    }

    return $ImpactTriggerCopyWith<$Res>(_self.trigger!, (value) {
      return _then(_self.copyWith(trigger: value));
    });
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResendInfoCopyWith<$Res>? get resend {
    if (_self.resend == null) {
      return null;
    }

    return $ResendInfoCopyWith<$Res>(_self.resend!, (value) {
      return _then(_self.copyWith(resend: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SensorBatch].
extension SensorBatchPatterns on SensorBatch {
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
    TResult Function(_SensorBatch value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorBatch() when $default != null:
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
    TResult Function(_SensorBatch value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorBatch():
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
    TResult? Function(_SensorBatch value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorBatch() when $default != null:
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
            int v,
            String stream,
            String source,
            @JsonKey(name: 'batch_id') String batchId,
            @JsonKey(name: 'device_id') String deviceId,
            @JsonKey(name: 'session_id') String sessionId,
            int seq,
            @JsonKey(name: 'study_id') String? studyId,
            @JsonKey(name: 'participation_id') String? participationId,
            @JsonKey(name: 'run_id') String? runId,
            @JsonKey(toJson: _nestedToJson) ClockInfo clock,
            @JsonKey(toJson: _nestedToJson) AccSeries? acc,
            @JsonKey(toJson: _nestedToJson) GyroSeries? gyro,
            @JsonKey(toJson: _nestedToJson) ImpactTrigger? trigger,
            @JsonKey(name: 'gyro_backfill') bool gyroBackfill,
            @JsonKey(name: 'backfill_for') String? backfillFor,
            @JsonKey(toJson: _nestedToJson) ResendInfo? resend,
            @JsonKey(name: 'collection_mode') String collectionMode,
            @JsonKey(name: 'gyro_mode') String gyroMode,
            @JsonKey(name: 'on_body') bool? onBody,
            @JsonKey(name: 'wear_state') String? wearState,
            @JsonKey(name: 'missing_reason') String? missingReason,
            @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
            @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorBatch() when $default != null:
        return $default(
            _that.v,
            _that.stream,
            _that.source,
            _that.batchId,
            _that.deviceId,
            _that.sessionId,
            _that.seq,
            _that.studyId,
            _that.participationId,
            _that.runId,
            _that.clock,
            _that.acc,
            _that.gyro,
            _that.trigger,
            _that.gyroBackfill,
            _that.backfillFor,
            _that.resend,
            _that.collectionMode,
            _that.gyroMode,
            _that.onBody,
            _that.wearState,
            _that.missingReason,
            _that.watchBatteryPct,
            _that.phoneReceivedAtMs);
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
            int v,
            String stream,
            String source,
            @JsonKey(name: 'batch_id') String batchId,
            @JsonKey(name: 'device_id') String deviceId,
            @JsonKey(name: 'session_id') String sessionId,
            int seq,
            @JsonKey(name: 'study_id') String? studyId,
            @JsonKey(name: 'participation_id') String? participationId,
            @JsonKey(name: 'run_id') String? runId,
            @JsonKey(toJson: _nestedToJson) ClockInfo clock,
            @JsonKey(toJson: _nestedToJson) AccSeries? acc,
            @JsonKey(toJson: _nestedToJson) GyroSeries? gyro,
            @JsonKey(toJson: _nestedToJson) ImpactTrigger? trigger,
            @JsonKey(name: 'gyro_backfill') bool gyroBackfill,
            @JsonKey(name: 'backfill_for') String? backfillFor,
            @JsonKey(toJson: _nestedToJson) ResendInfo? resend,
            @JsonKey(name: 'collection_mode') String collectionMode,
            @JsonKey(name: 'gyro_mode') String gyroMode,
            @JsonKey(name: 'on_body') bool? onBody,
            @JsonKey(name: 'wear_state') String? wearState,
            @JsonKey(name: 'missing_reason') String? missingReason,
            @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
            @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorBatch():
        return $default(
            _that.v,
            _that.stream,
            _that.source,
            _that.batchId,
            _that.deviceId,
            _that.sessionId,
            _that.seq,
            _that.studyId,
            _that.participationId,
            _that.runId,
            _that.clock,
            _that.acc,
            _that.gyro,
            _that.trigger,
            _that.gyroBackfill,
            _that.backfillFor,
            _that.resend,
            _that.collectionMode,
            _that.gyroMode,
            _that.onBody,
            _that.wearState,
            _that.missingReason,
            _that.watchBatteryPct,
            _that.phoneReceivedAtMs);
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
            int v,
            String stream,
            String source,
            @JsonKey(name: 'batch_id') String batchId,
            @JsonKey(name: 'device_id') String deviceId,
            @JsonKey(name: 'session_id') String sessionId,
            int seq,
            @JsonKey(name: 'study_id') String? studyId,
            @JsonKey(name: 'participation_id') String? participationId,
            @JsonKey(name: 'run_id') String? runId,
            @JsonKey(toJson: _nestedToJson) ClockInfo clock,
            @JsonKey(toJson: _nestedToJson) AccSeries? acc,
            @JsonKey(toJson: _nestedToJson) GyroSeries? gyro,
            @JsonKey(toJson: _nestedToJson) ImpactTrigger? trigger,
            @JsonKey(name: 'gyro_backfill') bool gyroBackfill,
            @JsonKey(name: 'backfill_for') String? backfillFor,
            @JsonKey(toJson: _nestedToJson) ResendInfo? resend,
            @JsonKey(name: 'collection_mode') String collectionMode,
            @JsonKey(name: 'gyro_mode') String gyroMode,
            @JsonKey(name: 'on_body') bool? onBody,
            @JsonKey(name: 'wear_state') String? wearState,
            @JsonKey(name: 'missing_reason') String? missingReason,
            @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
            @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorBatch() when $default != null:
        return $default(
            _that.v,
            _that.stream,
            _that.source,
            _that.batchId,
            _that.deviceId,
            _that.sessionId,
            _that.seq,
            _that.studyId,
            _that.participationId,
            _that.runId,
            _that.clock,
            _that.acc,
            _that.gyro,
            _that.trigger,
            _that.gyroBackfill,
            _that.backfillFor,
            _that.resend,
            _that.collectionMode,
            _that.gyroMode,
            _that.onBody,
            _that.wearState,
            _that.missingReason,
            _that.watchBatteryPct,
            _that.phoneReceivedAtMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SensorBatch implements SensorBatch {
  const _SensorBatch(
      {this.v = 2,
      this.stream = 'imu_watch',
      this.source = 'watch',
      @JsonKey(name: 'batch_id') required this.batchId,
      @JsonKey(name: 'device_id') required this.deviceId,
      @JsonKey(name: 'session_id') required this.sessionId,
      required this.seq,
      @JsonKey(name: 'study_id') this.studyId,
      @JsonKey(name: 'participation_id') this.participationId,
      @JsonKey(name: 'run_id') this.runId,
      @JsonKey(toJson: _nestedToJson) required this.clock,
      @JsonKey(toJson: _nestedToJson) this.acc,
      @JsonKey(toJson: _nestedToJson) this.gyro,
      @JsonKey(toJson: _nestedToJson) this.trigger,
      @JsonKey(name: 'gyro_backfill') this.gyroBackfill = false,
      @JsonKey(name: 'backfill_for') this.backfillFor,
      @JsonKey(toJson: _nestedToJson) this.resend,
      @JsonKey(name: 'collection_mode') required this.collectionMode,
      @JsonKey(name: 'gyro_mode') required this.gyroMode,
      @JsonKey(name: 'on_body') this.onBody,
      @JsonKey(name: 'wear_state') this.wearState,
      @JsonKey(name: 'missing_reason') this.missingReason,
      @JsonKey(name: 'watch_battery_pct') this.watchBatteryPct,
      @JsonKey(name: 'phone_received_at_ms') this.phoneReceivedAtMs});
  factory _SensorBatch.fromJson(Map<String, dynamic> json) =>
      _$SensorBatchFromJson(json);

  @override
  @JsonKey()
  final int v;
  @override
  @JsonKey()
  final String stream;
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey(name: 'batch_id')
  final String batchId;
  @override
  @JsonKey(name: 'device_id')
  final String deviceId;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  final int seq;
  @override
  @JsonKey(name: 'study_id')
  final String? studyId;
  @override
  @JsonKey(name: 'participation_id')
  final String? participationId;
  @override
  @JsonKey(name: 'run_id')
  final String? runId;
  @override
  @JsonKey(toJson: _nestedToJson)
  final ClockInfo clock;
  @override
  @JsonKey(toJson: _nestedToJson)
  final AccSeries? acc;
  @override
  @JsonKey(toJson: _nestedToJson)
  final GyroSeries? gyro;
  @override
  @JsonKey(toJson: _nestedToJson)
  final ImpactTrigger? trigger;
  @override
  @JsonKey(name: 'gyro_backfill')
  final bool gyroBackfill;
  @override
  @JsonKey(name: 'backfill_for')
  final String? backfillFor;
  @override
  @JsonKey(toJson: _nestedToJson)
  final ResendInfo? resend;
  @override
  @JsonKey(name: 'collection_mode')
  final String collectionMode;
  @override
  @JsonKey(name: 'gyro_mode')
  final String gyroMode;
  @override
  @JsonKey(name: 'on_body')
  final bool? onBody;
  @override
  @JsonKey(name: 'wear_state')
  final String? wearState;
  @override
  @JsonKey(name: 'missing_reason')
  final String? missingReason;
  @override
  @JsonKey(name: 'watch_battery_pct')
  final int? watchBatteryPct;
  @override
  @JsonKey(name: 'phone_received_at_ms')
  final int? phoneReceivedAtMs;

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SensorBatchCopyWith<_SensorBatch> get copyWith =>
      __$SensorBatchCopyWithImpl<_SensorBatch>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SensorBatchToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SensorBatch &&
            (identical(other.v, v) || other.v == v) &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.studyId, studyId) || other.studyId == studyId) &&
            (identical(other.participationId, participationId) ||
                other.participationId == participationId) &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.clock, clock) || other.clock == clock) &&
            (identical(other.acc, acc) || other.acc == acc) &&
            (identical(other.gyro, gyro) || other.gyro == gyro) &&
            (identical(other.trigger, trigger) || other.trigger == trigger) &&
            (identical(other.gyroBackfill, gyroBackfill) ||
                other.gyroBackfill == gyroBackfill) &&
            (identical(other.backfillFor, backfillFor) ||
                other.backfillFor == backfillFor) &&
            (identical(other.resend, resend) || other.resend == resend) &&
            (identical(other.collectionMode, collectionMode) ||
                other.collectionMode == collectionMode) &&
            (identical(other.gyroMode, gyroMode) ||
                other.gyroMode == gyroMode) &&
            (identical(other.onBody, onBody) || other.onBody == onBody) &&
            (identical(other.wearState, wearState) ||
                other.wearState == wearState) &&
            (identical(other.missingReason, missingReason) ||
                other.missingReason == missingReason) &&
            (identical(other.watchBatteryPct, watchBatteryPct) ||
                other.watchBatteryPct == watchBatteryPct) &&
            (identical(other.phoneReceivedAtMs, phoneReceivedAtMs) ||
                other.phoneReceivedAtMs == phoneReceivedAtMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        v,
        stream,
        source,
        batchId,
        deviceId,
        sessionId,
        seq,
        studyId,
        participationId,
        runId,
        clock,
        acc,
        gyro,
        trigger,
        gyroBackfill,
        backfillFor,
        resend,
        collectionMode,
        gyroMode,
        onBody,
        wearState,
        missingReason,
        watchBatteryPct,
        phoneReceivedAtMs
      ]);

  @override
  String toString() {
    return 'SensorBatch(v: $v, stream: $stream, source: $source, batchId: $batchId, deviceId: $deviceId, sessionId: $sessionId, seq: $seq, studyId: $studyId, participationId: $participationId, runId: $runId, clock: $clock, acc: $acc, gyro: $gyro, trigger: $trigger, gyroBackfill: $gyroBackfill, backfillFor: $backfillFor, resend: $resend, collectionMode: $collectionMode, gyroMode: $gyroMode, onBody: $onBody, wearState: $wearState, missingReason: $missingReason, watchBatteryPct: $watchBatteryPct, phoneReceivedAtMs: $phoneReceivedAtMs)';
  }
}

/// @nodoc
abstract mixin class _$SensorBatchCopyWith<$Res>
    implements $SensorBatchCopyWith<$Res> {
  factory _$SensorBatchCopyWith(
          _SensorBatch value, $Res Function(_SensorBatch) _then) =
      __$SensorBatchCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int v,
      String stream,
      String source,
      @JsonKey(name: 'batch_id') String batchId,
      @JsonKey(name: 'device_id') String deviceId,
      @JsonKey(name: 'session_id') String sessionId,
      int seq,
      @JsonKey(name: 'study_id') String? studyId,
      @JsonKey(name: 'participation_id') String? participationId,
      @JsonKey(name: 'run_id') String? runId,
      @JsonKey(toJson: _nestedToJson) ClockInfo clock,
      @JsonKey(toJson: _nestedToJson) AccSeries? acc,
      @JsonKey(toJson: _nestedToJson) GyroSeries? gyro,
      @JsonKey(toJson: _nestedToJson) ImpactTrigger? trigger,
      @JsonKey(name: 'gyro_backfill') bool gyroBackfill,
      @JsonKey(name: 'backfill_for') String? backfillFor,
      @JsonKey(toJson: _nestedToJson) ResendInfo? resend,
      @JsonKey(name: 'collection_mode') String collectionMode,
      @JsonKey(name: 'gyro_mode') String gyroMode,
      @JsonKey(name: 'on_body') bool? onBody,
      @JsonKey(name: 'wear_state') String? wearState,
      @JsonKey(name: 'missing_reason') String? missingReason,
      @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
      @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs});

  @override
  $ClockInfoCopyWith<$Res> get clock;
  @override
  $AccSeriesCopyWith<$Res>? get acc;
  @override
  $GyroSeriesCopyWith<$Res>? get gyro;
  @override
  $ImpactTriggerCopyWith<$Res>? get trigger;
  @override
  $ResendInfoCopyWith<$Res>? get resend;
}

/// @nodoc
class __$SensorBatchCopyWithImpl<$Res> implements _$SensorBatchCopyWith<$Res> {
  __$SensorBatchCopyWithImpl(this._self, this._then);

  final _SensorBatch _self;
  final $Res Function(_SensorBatch) _then;

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? v = null,
    Object? stream = null,
    Object? source = null,
    Object? batchId = null,
    Object? deviceId = null,
    Object? sessionId = null,
    Object? seq = null,
    Object? studyId = freezed,
    Object? participationId = freezed,
    Object? runId = freezed,
    Object? clock = null,
    Object? acc = freezed,
    Object? gyro = freezed,
    Object? trigger = freezed,
    Object? gyroBackfill = null,
    Object? backfillFor = freezed,
    Object? resend = freezed,
    Object? collectionMode = null,
    Object? gyroMode = null,
    Object? onBody = freezed,
    Object? wearState = freezed,
    Object? missingReason = freezed,
    Object? watchBatteryPct = freezed,
    Object? phoneReceivedAtMs = freezed,
  }) {
    return _then(_SensorBatch(
      v: null == v
          ? _self.v
          : v // ignore: cast_nullable_to_non_nullable
              as int,
      stream: null == stream
          ? _self.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      batchId: null == batchId
          ? _self.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      seq: null == seq
          ? _self.seq
          : seq // ignore: cast_nullable_to_non_nullable
              as int,
      studyId: freezed == studyId
          ? _self.studyId
          : studyId // ignore: cast_nullable_to_non_nullable
              as String?,
      participationId: freezed == participationId
          ? _self.participationId
          : participationId // ignore: cast_nullable_to_non_nullable
              as String?,
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as String?,
      clock: null == clock
          ? _self.clock
          : clock // ignore: cast_nullable_to_non_nullable
              as ClockInfo,
      acc: freezed == acc
          ? _self.acc
          : acc // ignore: cast_nullable_to_non_nullable
              as AccSeries?,
      gyro: freezed == gyro
          ? _self.gyro
          : gyro // ignore: cast_nullable_to_non_nullable
              as GyroSeries?,
      trigger: freezed == trigger
          ? _self.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as ImpactTrigger?,
      gyroBackfill: null == gyroBackfill
          ? _self.gyroBackfill
          : gyroBackfill // ignore: cast_nullable_to_non_nullable
              as bool,
      backfillFor: freezed == backfillFor
          ? _self.backfillFor
          : backfillFor // ignore: cast_nullable_to_non_nullable
              as String?,
      resend: freezed == resend
          ? _self.resend
          : resend // ignore: cast_nullable_to_non_nullable
              as ResendInfo?,
      collectionMode: null == collectionMode
          ? _self.collectionMode
          : collectionMode // ignore: cast_nullable_to_non_nullable
              as String,
      gyroMode: null == gyroMode
          ? _self.gyroMode
          : gyroMode // ignore: cast_nullable_to_non_nullable
              as String,
      onBody: freezed == onBody
          ? _self.onBody
          : onBody // ignore: cast_nullable_to_non_nullable
              as bool?,
      wearState: freezed == wearState
          ? _self.wearState
          : wearState // ignore: cast_nullable_to_non_nullable
              as String?,
      missingReason: freezed == missingReason
          ? _self.missingReason
          : missingReason // ignore: cast_nullable_to_non_nullable
              as String?,
      watchBatteryPct: freezed == watchBatteryPct
          ? _self.watchBatteryPct
          : watchBatteryPct // ignore: cast_nullable_to_non_nullable
              as int?,
      phoneReceivedAtMs: freezed == phoneReceivedAtMs
          ? _self.phoneReceivedAtMs
          : phoneReceivedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClockInfoCopyWith<$Res> get clock {
    return $ClockInfoCopyWith<$Res>(_self.clock, (value) {
      return _then(_self.copyWith(clock: value));
    });
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccSeriesCopyWith<$Res>? get acc {
    if (_self.acc == null) {
      return null;
    }

    return $AccSeriesCopyWith<$Res>(_self.acc!, (value) {
      return _then(_self.copyWith(acc: value));
    });
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GyroSeriesCopyWith<$Res>? get gyro {
    if (_self.gyro == null) {
      return null;
    }

    return $GyroSeriesCopyWith<$Res>(_self.gyro!, (value) {
      return _then(_self.copyWith(gyro: value));
    });
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImpactTriggerCopyWith<$Res>? get trigger {
    if (_self.trigger == null) {
      return null;
    }

    return $ImpactTriggerCopyWith<$Res>(_self.trigger!, (value) {
      return _then(_self.copyWith(trigger: value));
    });
  }

  /// Create a copy of SensorBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResendInfoCopyWith<$Res>? get resend {
    if (_self.resend == null) {
      return null;
    }

    return $ResendInfoCopyWith<$Res>(_self.resend!, (value) {
      return _then(_self.copyWith(resend: value));
    });
  }
}

/// @nodoc
mixin _$SensorDroppedRecord {
  String get stream;
  @JsonKey(name: 'session_id')
  String get sessionId;
  @JsonKey(name: 'from_seq')
  int get fromSeq;
  @JsonKey(name: 'to_seq')
  int get toSeq;
  String get reason;
  @JsonKey(name: 'ts_ms')
  int get tsMs;

  /// Create a copy of SensorDroppedRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorDroppedRecordCopyWith<SensorDroppedRecord> get copyWith =>
      _$SensorDroppedRecordCopyWithImpl<SensorDroppedRecord>(
          this as SensorDroppedRecord, _$identity);

  /// Serializes this SensorDroppedRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorDroppedRecord &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.fromSeq, fromSeq) || other.fromSeq == fromSeq) &&
            (identical(other.toSeq, toSeq) || other.toSeq == toSeq) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stream, sessionId, fromSeq, toSeq, reason, tsMs);

  @override
  String toString() {
    return 'SensorDroppedRecord(stream: $stream, sessionId: $sessionId, fromSeq: $fromSeq, toSeq: $toSeq, reason: $reason, tsMs: $tsMs)';
  }
}

/// @nodoc
abstract mixin class $SensorDroppedRecordCopyWith<$Res> {
  factory $SensorDroppedRecordCopyWith(
          SensorDroppedRecord value, $Res Function(SensorDroppedRecord) _then) =
      _$SensorDroppedRecordCopyWithImpl;
  @useResult
  $Res call(
      {String stream,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'from_seq') int fromSeq,
      @JsonKey(name: 'to_seq') int toSeq,
      String reason,
      @JsonKey(name: 'ts_ms') int tsMs});
}

/// @nodoc
class _$SensorDroppedRecordCopyWithImpl<$Res>
    implements $SensorDroppedRecordCopyWith<$Res> {
  _$SensorDroppedRecordCopyWithImpl(this._self, this._then);

  final SensorDroppedRecord _self;
  final $Res Function(SensorDroppedRecord) _then;

  /// Create a copy of SensorDroppedRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stream = null,
    Object? sessionId = null,
    Object? fromSeq = null,
    Object? toSeq = null,
    Object? reason = null,
    Object? tsMs = null,
  }) {
    return _then(_self.copyWith(
      stream: null == stream
          ? _self.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      fromSeq: null == fromSeq
          ? _self.fromSeq
          : fromSeq // ignore: cast_nullable_to_non_nullable
              as int,
      toSeq: null == toSeq
          ? _self.toSeq
          : toSeq // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [SensorDroppedRecord].
extension SensorDroppedRecordPatterns on SensorDroppedRecord {
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
    TResult Function(_SensorDroppedRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord() when $default != null:
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
    TResult Function(_SensorDroppedRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord():
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
    TResult? Function(_SensorDroppedRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord() when $default != null:
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
            String stream,
            @JsonKey(name: 'session_id') String sessionId,
            @JsonKey(name: 'from_seq') int fromSeq,
            @JsonKey(name: 'to_seq') int toSeq,
            String reason,
            @JsonKey(name: 'ts_ms') int tsMs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord() when $default != null:
        return $default(_that.stream, _that.sessionId, _that.fromSeq,
            _that.toSeq, _that.reason, _that.tsMs);
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
            String stream,
            @JsonKey(name: 'session_id') String sessionId,
            @JsonKey(name: 'from_seq') int fromSeq,
            @JsonKey(name: 'to_seq') int toSeq,
            String reason,
            @JsonKey(name: 'ts_ms') int tsMs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord():
        return $default(_that.stream, _that.sessionId, _that.fromSeq,
            _that.toSeq, _that.reason, _that.tsMs);
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
            String stream,
            @JsonKey(name: 'session_id') String sessionId,
            @JsonKey(name: 'from_seq') int fromSeq,
            @JsonKey(name: 'to_seq') int toSeq,
            String reason,
            @JsonKey(name: 'ts_ms') int tsMs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorDroppedRecord() when $default != null:
        return $default(_that.stream, _that.sessionId, _that.fromSeq,
            _that.toSeq, _that.reason, _that.tsMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SensorDroppedRecord implements SensorDroppedRecord {
  const _SensorDroppedRecord(
      {this.stream = 'imu_dropped',
      @JsonKey(name: 'session_id') required this.sessionId,
      @JsonKey(name: 'from_seq') required this.fromSeq,
      @JsonKey(name: 'to_seq') required this.toSeq,
      required this.reason,
      @JsonKey(name: 'ts_ms') required this.tsMs});
  factory _SensorDroppedRecord.fromJson(Map<String, dynamic> json) =>
      _$SensorDroppedRecordFromJson(json);

  @override
  @JsonKey()
  final String stream;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  @JsonKey(name: 'from_seq')
  final int fromSeq;
  @override
  @JsonKey(name: 'to_seq')
  final int toSeq;
  @override
  final String reason;
  @override
  @JsonKey(name: 'ts_ms')
  final int tsMs;

  /// Create a copy of SensorDroppedRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SensorDroppedRecordCopyWith<_SensorDroppedRecord> get copyWith =>
      __$SensorDroppedRecordCopyWithImpl<_SensorDroppedRecord>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SensorDroppedRecordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SensorDroppedRecord &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.fromSeq, fromSeq) || other.fromSeq == fromSeq) &&
            (identical(other.toSeq, toSeq) || other.toSeq == toSeq) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.tsMs, tsMs) || other.tsMs == tsMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stream, sessionId, fromSeq, toSeq, reason, tsMs);

  @override
  String toString() {
    return 'SensorDroppedRecord(stream: $stream, sessionId: $sessionId, fromSeq: $fromSeq, toSeq: $toSeq, reason: $reason, tsMs: $tsMs)';
  }
}

/// @nodoc
abstract mixin class _$SensorDroppedRecordCopyWith<$Res>
    implements $SensorDroppedRecordCopyWith<$Res> {
  factory _$SensorDroppedRecordCopyWith(_SensorDroppedRecord value,
          $Res Function(_SensorDroppedRecord) _then) =
      __$SensorDroppedRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String stream,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'from_seq') int fromSeq,
      @JsonKey(name: 'to_seq') int toSeq,
      String reason,
      @JsonKey(name: 'ts_ms') int tsMs});
}

/// @nodoc
class __$SensorDroppedRecordCopyWithImpl<$Res>
    implements _$SensorDroppedRecordCopyWith<$Res> {
  __$SensorDroppedRecordCopyWithImpl(this._self, this._then);

  final _SensorDroppedRecord _self;
  final $Res Function(_SensorDroppedRecord) _then;

  /// Create a copy of SensorDroppedRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stream = null,
    Object? sessionId = null,
    Object? fromSeq = null,
    Object? toSeq = null,
    Object? reason = null,
    Object? tsMs = null,
  }) {
    return _then(_SensorDroppedRecord(
      stream: null == stream
          ? _self.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      fromSeq: null == fromSeq
          ? _self.fromSeq
          : fromSeq // ignore: cast_nullable_to_non_nullable
              as int,
      toSeq: null == toSeq
          ? _self.toSeq
          : toSeq // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      tsMs: null == tsMs
          ? _self.tsMs
          : tsMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$SensorMessage {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SensorMessage);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SensorMessage()';
  }
}

/// @nodoc
class $SensorMessageCopyWith<$Res> {
  $SensorMessageCopyWith(SensorMessage _, $Res Function(SensorMessage) __);
}

/// Adds pattern-matching-related methods to [SensorMessage].
extension SensorMessagePatterns on SensorMessage {
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
    TResult Function(SensorMessageBatch value)? batch,
    TResult Function(SensorMessageDropped value)? dropped,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch() when batch != null:
        return batch(_that);
      case SensorMessageDropped() when dropped != null:
        return dropped(_that);
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
    required TResult Function(SensorMessageBatch value) batch,
    required TResult Function(SensorMessageDropped value) dropped,
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch():
        return batch(_that);
      case SensorMessageDropped():
        return dropped(_that);
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
    TResult? Function(SensorMessageBatch value)? batch,
    TResult? Function(SensorMessageDropped value)? dropped,
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch() when batch != null:
        return batch(_that);
      case SensorMessageDropped() when dropped != null:
        return dropped(_that);
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
    TResult Function(SensorBatch batch)? batch,
    TResult Function(SensorDroppedRecord record)? dropped,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch() when batch != null:
        return batch(_that.batch);
      case SensorMessageDropped() when dropped != null:
        return dropped(_that.record);
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
    required TResult Function(SensorBatch batch) batch,
    required TResult Function(SensorDroppedRecord record) dropped,
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch():
        return batch(_that.batch);
      case SensorMessageDropped():
        return dropped(_that.record);
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
    TResult? Function(SensorBatch batch)? batch,
    TResult? Function(SensorDroppedRecord record)? dropped,
  }) {
    final _that = this;
    switch (_that) {
      case SensorMessageBatch() when batch != null:
        return batch(_that.batch);
      case SensorMessageDropped() when dropped != null:
        return dropped(_that.record);
      case _:
        return null;
    }
  }
}

/// @nodoc

class SensorMessageBatch implements SensorMessage {
  const SensorMessageBatch(this.batch);

  final SensorBatch batch;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorMessageBatchCopyWith<SensorMessageBatch> get copyWith =>
      _$SensorMessageBatchCopyWithImpl<SensorMessageBatch>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorMessageBatch &&
            (identical(other.batch, batch) || other.batch == batch));
  }

  @override
  int get hashCode => Object.hash(runtimeType, batch);

  @override
  String toString() {
    return 'SensorMessage.batch(batch: $batch)';
  }
}

/// @nodoc
abstract mixin class $SensorMessageBatchCopyWith<$Res>
    implements $SensorMessageCopyWith<$Res> {
  factory $SensorMessageBatchCopyWith(
          SensorMessageBatch value, $Res Function(SensorMessageBatch) _then) =
      _$SensorMessageBatchCopyWithImpl;
  @useResult
  $Res call({SensorBatch batch});

  $SensorBatchCopyWith<$Res> get batch;
}

/// @nodoc
class _$SensorMessageBatchCopyWithImpl<$Res>
    implements $SensorMessageBatchCopyWith<$Res> {
  _$SensorMessageBatchCopyWithImpl(this._self, this._then);

  final SensorMessageBatch _self;
  final $Res Function(SensorMessageBatch) _then;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? batch = null,
  }) {
    return _then(SensorMessageBatch(
      null == batch
          ? _self.batch
          : batch // ignore: cast_nullable_to_non_nullable
              as SensorBatch,
    ));
  }

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SensorBatchCopyWith<$Res> get batch {
    return $SensorBatchCopyWith<$Res>(_self.batch, (value) {
      return _then(_self.copyWith(batch: value));
    });
  }
}

/// @nodoc

class SensorMessageDropped implements SensorMessage {
  const SensorMessageDropped(this.record);

  final SensorDroppedRecord record;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorMessageDroppedCopyWith<SensorMessageDropped> get copyWith =>
      _$SensorMessageDroppedCopyWithImpl<SensorMessageDropped>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorMessageDropped &&
            (identical(other.record, record) || other.record == record));
  }

  @override
  int get hashCode => Object.hash(runtimeType, record);

  @override
  String toString() {
    return 'SensorMessage.dropped(record: $record)';
  }
}

/// @nodoc
abstract mixin class $SensorMessageDroppedCopyWith<$Res>
    implements $SensorMessageCopyWith<$Res> {
  factory $SensorMessageDroppedCopyWith(SensorMessageDropped value,
          $Res Function(SensorMessageDropped) _then) =
      _$SensorMessageDroppedCopyWithImpl;
  @useResult
  $Res call({SensorDroppedRecord record});

  $SensorDroppedRecordCopyWith<$Res> get record;
}

/// @nodoc
class _$SensorMessageDroppedCopyWithImpl<$Res>
    implements $SensorMessageDroppedCopyWith<$Res> {
  _$SensorMessageDroppedCopyWithImpl(this._self, this._then);

  final SensorMessageDropped _self;
  final $Res Function(SensorMessageDropped) _then;

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? record = null,
  }) {
    return _then(SensorMessageDropped(
      null == record
          ? _self.record
          : record // ignore: cast_nullable_to_non_nullable
              as SensorDroppedRecord,
    ));
  }

  /// Create a copy of SensorMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SensorDroppedRecordCopyWith<$Res> get record {
    return $SensorDroppedRecordCopyWith<$Res>(_self.record, (value) {
      return _then(_self.copyWith(record: value));
    });
  }
}

// dart format on
