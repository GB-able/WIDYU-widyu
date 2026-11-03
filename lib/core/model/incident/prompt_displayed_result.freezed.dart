// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prompt_displayed_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PromptDisplayedResult {
  String get incidentId;
  String? get state;
  int? get respondByMs;

  /// Create a copy of PromptDisplayedResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PromptDisplayedResultCopyWith<PromptDisplayedResult> get copyWith =>
      _$PromptDisplayedResultCopyWithImpl<PromptDisplayedResult>(
          this as PromptDisplayedResult, _$identity);

  /// Serializes this PromptDisplayedResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PromptDisplayedResult &&
            (identical(other.incidentId, incidentId) ||
                other.incidentId == incidentId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.respondByMs, respondByMs) ||
                other.respondByMs == respondByMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, incidentId, state, respondByMs);

  @override
  String toString() {
    return 'PromptDisplayedResult(incidentId: $incidentId, state: $state, respondByMs: $respondByMs)';
  }
}

/// @nodoc
abstract mixin class $PromptDisplayedResultCopyWith<$Res> {
  factory $PromptDisplayedResultCopyWith(PromptDisplayedResult value,
          $Res Function(PromptDisplayedResult) _then) =
      _$PromptDisplayedResultCopyWithImpl;
  @useResult
  $Res call({String incidentId, String? state, int? respondByMs});
}

/// @nodoc
class _$PromptDisplayedResultCopyWithImpl<$Res>
    implements $PromptDisplayedResultCopyWith<$Res> {
  _$PromptDisplayedResultCopyWithImpl(this._self, this._then);

  final PromptDisplayedResult _self;
  final $Res Function(PromptDisplayedResult) _then;

  /// Create a copy of PromptDisplayedResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incidentId = null,
    Object? state = freezed,
    Object? respondByMs = freezed,
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
      respondByMs: freezed == respondByMs
          ? _self.respondByMs
          : respondByMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PromptDisplayedResult].
extension PromptDisplayedResultPatterns on PromptDisplayedResult {
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
    TResult Function(_PromptDisplayedResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PromptDisplayedResult() when $default != null:
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
    TResult Function(_PromptDisplayedResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PromptDisplayedResult():
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
    TResult? Function(_PromptDisplayedResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PromptDisplayedResult() when $default != null:
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
    TResult Function(String incidentId, String? state, int? respondByMs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PromptDisplayedResult() when $default != null:
        return $default(_that.incidentId, _that.state, _that.respondByMs);
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
    TResult Function(String incidentId, String? state, int? respondByMs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PromptDisplayedResult():
        return $default(_that.incidentId, _that.state, _that.respondByMs);
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
    TResult? Function(String incidentId, String? state, int? respondByMs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PromptDisplayedResult() when $default != null:
        return $default(_that.incidentId, _that.state, _that.respondByMs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PromptDisplayedResult implements PromptDisplayedResult {
  const _PromptDisplayedResult(
      {required this.incidentId, this.state, this.respondByMs});
  factory _PromptDisplayedResult.fromJson(Map<String, dynamic> json) =>
      _$PromptDisplayedResultFromJson(json);

  @override
  final String incidentId;
  @override
  final String? state;
  @override
  final int? respondByMs;

  /// Create a copy of PromptDisplayedResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PromptDisplayedResultCopyWith<_PromptDisplayedResult> get copyWith =>
      __$PromptDisplayedResultCopyWithImpl<_PromptDisplayedResult>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PromptDisplayedResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PromptDisplayedResult &&
            (identical(other.incidentId, incidentId) ||
                other.incidentId == incidentId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.respondByMs, respondByMs) ||
                other.respondByMs == respondByMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, incidentId, state, respondByMs);

  @override
  String toString() {
    return 'PromptDisplayedResult(incidentId: $incidentId, state: $state, respondByMs: $respondByMs)';
  }
}

/// @nodoc
abstract mixin class _$PromptDisplayedResultCopyWith<$Res>
    implements $PromptDisplayedResultCopyWith<$Res> {
  factory _$PromptDisplayedResultCopyWith(_PromptDisplayedResult value,
          $Res Function(_PromptDisplayedResult) _then) =
      __$PromptDisplayedResultCopyWithImpl;
  @override
  @useResult
  $Res call({String incidentId, String? state, int? respondByMs});
}

/// @nodoc
class __$PromptDisplayedResultCopyWithImpl<$Res>
    implements _$PromptDisplayedResultCopyWith<$Res> {
  __$PromptDisplayedResultCopyWithImpl(this._self, this._then);

  final _PromptDisplayedResult _self;
  final $Res Function(_PromptDisplayedResult) _then;

  /// Create a copy of PromptDisplayedResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? incidentId = null,
    Object? state = freezed,
    Object? respondByMs = freezed,
  }) {
    return _then(_PromptDisplayedResult(
      incidentId: null == incidentId
          ? _self.incidentId
          : incidentId // ignore: cast_nullable_to_non_nullable
              as String,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      respondByMs: freezed == respondByMs
          ? _self.respondByMs
          : respondByMs // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
