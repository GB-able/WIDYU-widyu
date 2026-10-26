// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incident_respond_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IncidentRespondResult {
  String get incidentId;
  String? get state;

  /// Create a copy of IncidentRespondResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IncidentRespondResultCopyWith<IncidentRespondResult> get copyWith =>
      _$IncidentRespondResultCopyWithImpl<IncidentRespondResult>(
          this as IncidentRespondResult, _$identity);

  /// Serializes this IncidentRespondResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IncidentRespondResult &&
            (identical(other.incidentId, incidentId) ||
                other.incidentId == incidentId) &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, incidentId, state);

  @override
  String toString() {
    return 'IncidentRespondResult(incidentId: $incidentId, state: $state)';
  }
}

/// @nodoc
abstract mixin class $IncidentRespondResultCopyWith<$Res> {
  factory $IncidentRespondResultCopyWith(IncidentRespondResult value,
          $Res Function(IncidentRespondResult) _then) =
      _$IncidentRespondResultCopyWithImpl;
  @useResult
  $Res call({String incidentId, String? state});
}

/// @nodoc
class _$IncidentRespondResultCopyWithImpl<$Res>
    implements $IncidentRespondResultCopyWith<$Res> {
  _$IncidentRespondResultCopyWithImpl(this._self, this._then);

  final IncidentRespondResult _self;
  final $Res Function(IncidentRespondResult) _then;

  /// Create a copy of IncidentRespondResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incidentId = null,
    Object? state = freezed,
  }) {
    return _then(_self.copyWith(
      incidentId: null == incidentId
          ? _self.incidentId
          : incidentId // ignore: cast_nullable_to_non_nullable
              as String,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [IncidentRespondResult].
extension IncidentRespondResultPatterns on IncidentRespondResult {
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
    TResult Function(_IncidentRespondResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IncidentRespondResult() when $default != null:
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
    TResult Function(_IncidentRespondResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncidentRespondResult():
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
    TResult? Function(_IncidentRespondResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncidentRespondResult() when $default != null:
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
    TResult Function(String incidentId, String? state)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IncidentRespondResult() when $default != null:
        return $default(_that.incidentId, _that.state);
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
    TResult Function(String incidentId, String? state) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncidentRespondResult():
        return $default(_that.incidentId, _that.state);
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
    TResult? Function(String incidentId, String? state)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IncidentRespondResult() when $default != null:
        return $default(_that.incidentId, _that.state);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _IncidentRespondResult implements IncidentRespondResult {
  const _IncidentRespondResult({required this.incidentId, this.state});
  factory _IncidentRespondResult.fromJson(Map<String, dynamic> json) =>
      _$IncidentRespondResultFromJson(json);

  @override
  final String incidentId;
  @override
  final String? state;

  /// Create a copy of IncidentRespondResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IncidentRespondResultCopyWith<_IncidentRespondResult> get copyWith =>
      __$IncidentRespondResultCopyWithImpl<_IncidentRespondResult>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IncidentRespondResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IncidentRespondResult &&
            (identical(other.incidentId, incidentId) ||
                other.incidentId == incidentId) &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, incidentId, state);

  @override
  String toString() {
    return 'IncidentRespondResult(incidentId: $incidentId, state: $state)';
  }
}

/// @nodoc
abstract mixin class _$IncidentRespondResultCopyWith<$Res>
    implements $IncidentRespondResultCopyWith<$Res> {
  factory _$IncidentRespondResultCopyWith(_IncidentRespondResult value,
          $Res Function(_IncidentRespondResult) _then) =
      __$IncidentRespondResultCopyWithImpl;
  @override
  @useResult
  $Res call({String incidentId, String? state});
}

/// @nodoc
class __$IncidentRespondResultCopyWithImpl<$Res>
    implements _$IncidentRespondResultCopyWith<$Res> {
  __$IncidentRespondResultCopyWithImpl(this._self, this._then);

  final _IncidentRespondResult _self;
  final $Res Function(_IncidentRespondResult) _then;

  /// Create a copy of IncidentRespondResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? incidentId = null,
    Object? state = freezed,
  }) {
    return _then(_IncidentRespondResult(
      incidentId: null == incidentId
          ? _self.incidentId
          : incidentId // ignore: cast_nullable_to_non_nullable
              as String,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
