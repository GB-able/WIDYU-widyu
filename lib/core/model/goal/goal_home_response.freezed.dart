// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_home_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoalHomeResponse {
  Medication? get medicine;
  @JsonKey(name: 'steps')
  Walk? get walk;
  Hospital? get hospital;

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalHomeResponseCopyWith<GoalHomeResponse> get copyWith =>
      _$GoalHomeResponseCopyWithImpl<GoalHomeResponse>(
          this as GoalHomeResponse, _$identity);

  /// Serializes this GoalHomeResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalHomeResponse &&
            (identical(other.medicine, medicine) ||
                other.medicine == medicine) &&
            (identical(other.walk, walk) || other.walk == walk) &&
            (identical(other.hospital, hospital) ||
                other.hospital == hospital));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, medicine, walk, hospital);

  @override
  String toString() {
    return 'GoalHomeResponse(medicine: $medicine, walk: $walk, hospital: $hospital)';
  }
}

/// @nodoc
abstract mixin class $GoalHomeResponseCopyWith<$Res> {
  factory $GoalHomeResponseCopyWith(
          GoalHomeResponse value, $Res Function(GoalHomeResponse) _then) =
      _$GoalHomeResponseCopyWithImpl;
  @useResult
  $Res call(
      {Medication? medicine,
      @JsonKey(name: 'steps') Walk? walk,
      Hospital? hospital});

  $MedicationCopyWith<$Res>? get medicine;
  $WalkCopyWith<$Res>? get walk;
  $HospitalCopyWith<$Res>? get hospital;
}

/// @nodoc
class _$GoalHomeResponseCopyWithImpl<$Res>
    implements $GoalHomeResponseCopyWith<$Res> {
  _$GoalHomeResponseCopyWithImpl(this._self, this._then);

  final GoalHomeResponse _self;
  final $Res Function(GoalHomeResponse) _then;

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicine = freezed,
    Object? walk = freezed,
    Object? hospital = freezed,
  }) {
    return _then(_self.copyWith(
      medicine: freezed == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medication?,
      walk: freezed == walk
          ? _self.walk
          : walk // ignore: cast_nullable_to_non_nullable
              as Walk?,
      hospital: freezed == hospital
          ? _self.hospital
          : hospital // ignore: cast_nullable_to_non_nullable
              as Hospital?,
    ));
  }

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationCopyWith<$Res>? get medicine {
    if (_self.medicine == null) {
      return null;
    }

    return $MedicationCopyWith<$Res>(_self.medicine!, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalkCopyWith<$Res>? get walk {
    if (_self.walk == null) {
      return null;
    }

    return $WalkCopyWith<$Res>(_self.walk!, (value) {
      return _then(_self.copyWith(walk: value));
    });
  }

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HospitalCopyWith<$Res>? get hospital {
    if (_self.hospital == null) {
      return null;
    }

    return $HospitalCopyWith<$Res>(_self.hospital!, (value) {
      return _then(_self.copyWith(hospital: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GoalHomeResponse].
extension GoalHomeResponsePatterns on GoalHomeResponse {
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
    TResult Function(_GoalHomeResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalHomeResponse() when $default != null:
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
    TResult Function(_GoalHomeResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalHomeResponse():
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
    TResult? Function(_GoalHomeResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalHomeResponse() when $default != null:
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
    TResult Function(Medication? medicine, @JsonKey(name: 'steps') Walk? walk,
            Hospital? hospital)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalHomeResponse() when $default != null:
        return $default(_that.medicine, _that.walk, _that.hospital);
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
    TResult Function(Medication? medicine, @JsonKey(name: 'steps') Walk? walk,
            Hospital? hospital)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalHomeResponse():
        return $default(_that.medicine, _that.walk, _that.hospital);
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
    TResult? Function(Medication? medicine, @JsonKey(name: 'steps') Walk? walk,
            Hospital? hospital)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalHomeResponse() when $default != null:
        return $default(_that.medicine, _that.walk, _that.hospital);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GoalHomeResponse implements GoalHomeResponse {
  const _GoalHomeResponse(
      {required this.medicine,
      @JsonKey(name: 'steps') required this.walk,
      required this.hospital});
  factory _GoalHomeResponse.fromJson(Map<String, dynamic> json) =>
      _$GoalHomeResponseFromJson(json);

  @override
  final Medication? medicine;
  @override
  @JsonKey(name: 'steps')
  final Walk? walk;
  @override
  final Hospital? hospital;

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalHomeResponseCopyWith<_GoalHomeResponse> get copyWith =>
      __$GoalHomeResponseCopyWithImpl<_GoalHomeResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GoalHomeResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoalHomeResponse &&
            (identical(other.medicine, medicine) ||
                other.medicine == medicine) &&
            (identical(other.walk, walk) || other.walk == walk) &&
            (identical(other.hospital, hospital) ||
                other.hospital == hospital));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, medicine, walk, hospital);

  @override
  String toString() {
    return 'GoalHomeResponse(medicine: $medicine, walk: $walk, hospital: $hospital)';
  }
}

/// @nodoc
abstract mixin class _$GoalHomeResponseCopyWith<$Res>
    implements $GoalHomeResponseCopyWith<$Res> {
  factory _$GoalHomeResponseCopyWith(
          _GoalHomeResponse value, $Res Function(_GoalHomeResponse) _then) =
      __$GoalHomeResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Medication? medicine,
      @JsonKey(name: 'steps') Walk? walk,
      Hospital? hospital});

  @override
  $MedicationCopyWith<$Res>? get medicine;
  @override
  $WalkCopyWith<$Res>? get walk;
  @override
  $HospitalCopyWith<$Res>? get hospital;
}

/// @nodoc
class __$GoalHomeResponseCopyWithImpl<$Res>
    implements _$GoalHomeResponseCopyWith<$Res> {
  __$GoalHomeResponseCopyWithImpl(this._self, this._then);

  final _GoalHomeResponse _self;
  final $Res Function(_GoalHomeResponse) _then;

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? medicine = freezed,
    Object? walk = freezed,
    Object? hospital = freezed,
  }) {
    return _then(_GoalHomeResponse(
      medicine: freezed == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medication?,
      walk: freezed == walk
          ? _self.walk
          : walk // ignore: cast_nullable_to_non_nullable
              as Walk?,
      hospital: freezed == hospital
          ? _self.hospital
          : hospital // ignore: cast_nullable_to_non_nullable
              as Hospital?,
    ));
  }

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationCopyWith<$Res>? get medicine {
    if (_self.medicine == null) {
      return null;
    }

    return $MedicationCopyWith<$Res>(_self.medicine!, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalkCopyWith<$Res>? get walk {
    if (_self.walk == null) {
      return null;
    }

    return $WalkCopyWith<$Res>(_self.walk!, (value) {
      return _then(_self.copyWith(walk: value));
    });
  }

  /// Create a copy of GoalHomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HospitalCopyWith<$Res>? get hospital {
    if (_self.hospital == null) {
      return null;
    }

    return $HospitalCopyWith<$Res>(_self.hospital!, (value) {
      return _then(_self.copyWith(hospital: value));
    });
  }
}

// dart format on
