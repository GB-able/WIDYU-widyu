// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_tab_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarTabUiState {
  DateTime get selectedDay;
  DateTime get focusedMonth;
  bool get isCalendarLoading;
  Set<int> get daysWithEvents; // 날짜별 피드. 캐시에 남아 있는(삭제되지 않은) 게시물 id만 담는다.
  Map<DateTime, DateFeedState> get feedStates;
  Set<int> get expandedFeedIds;
  AlbumCache get cache;

  /// Create a copy of CalendarTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CalendarTabUiStateCopyWith<CalendarTabUiState> get copyWith =>
      _$CalendarTabUiStateCopyWithImpl<CalendarTabUiState>(
          this as CalendarTabUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CalendarTabUiState &&
            (identical(other.selectedDay, selectedDay) ||
                other.selectedDay == selectedDay) &&
            (identical(other.focusedMonth, focusedMonth) ||
                other.focusedMonth == focusedMonth) &&
            (identical(other.isCalendarLoading, isCalendarLoading) ||
                other.isCalendarLoading == isCalendarLoading) &&
            const DeepCollectionEquality()
                .equals(other.daysWithEvents, daysWithEvents) &&
            const DeepCollectionEquality()
                .equals(other.feedStates, feedStates) &&
            const DeepCollectionEquality()
                .equals(other.expandedFeedIds, expandedFeedIds) &&
            (identical(other.cache, cache) || other.cache == cache));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedDay,
      focusedMonth,
      isCalendarLoading,
      const DeepCollectionEquality().hash(daysWithEvents),
      const DeepCollectionEquality().hash(feedStates),
      const DeepCollectionEquality().hash(expandedFeedIds),
      cache);

  @override
  String toString() {
    return 'CalendarTabUiState(selectedDay: $selectedDay, focusedMonth: $focusedMonth, isCalendarLoading: $isCalendarLoading, daysWithEvents: $daysWithEvents, feedStates: $feedStates, expandedFeedIds: $expandedFeedIds, cache: $cache)';
  }
}

/// @nodoc
abstract mixin class $CalendarTabUiStateCopyWith<$Res> {
  factory $CalendarTabUiStateCopyWith(
          CalendarTabUiState value, $Res Function(CalendarTabUiState) _then) =
      _$CalendarTabUiStateCopyWithImpl;
  @useResult
  $Res call(
      {DateTime selectedDay,
      DateTime focusedMonth,
      bool isCalendarLoading,
      Set<int> daysWithEvents,
      Map<DateTime, DateFeedState> feedStates,
      Set<int> expandedFeedIds,
      AlbumCache cache});
}

/// @nodoc
class _$CalendarTabUiStateCopyWithImpl<$Res>
    implements $CalendarTabUiStateCopyWith<$Res> {
  _$CalendarTabUiStateCopyWithImpl(this._self, this._then);

  final CalendarTabUiState _self;
  final $Res Function(CalendarTabUiState) _then;

  /// Create a copy of CalendarTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDay = null,
    Object? focusedMonth = null,
    Object? isCalendarLoading = null,
    Object? daysWithEvents = null,
    Object? feedStates = null,
    Object? expandedFeedIds = null,
    Object? cache = null,
  }) {
    return _then(_self.copyWith(
      selectedDay: null == selectedDay
          ? _self.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      focusedMonth: null == focusedMonth
          ? _self.focusedMonth
          : focusedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCalendarLoading: null == isCalendarLoading
          ? _self.isCalendarLoading
          : isCalendarLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      daysWithEvents: null == daysWithEvents
          ? _self.daysWithEvents
          : daysWithEvents // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      feedStates: null == feedStates
          ? _self.feedStates
          : feedStates // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, DateFeedState>,
      expandedFeedIds: null == expandedFeedIds
          ? _self.expandedFeedIds
          : expandedFeedIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      cache: null == cache
          ? _self.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as AlbumCache,
    ));
  }
}

/// Adds pattern-matching-related methods to [CalendarTabUiState].
extension CalendarTabUiStatePatterns on CalendarTabUiState {
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
    TResult Function(_CalendarTabUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarTabUiState() when $default != null:
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
    TResult Function(_CalendarTabUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarTabUiState():
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
    TResult? Function(_CalendarTabUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarTabUiState() when $default != null:
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
            DateTime selectedDay,
            DateTime focusedMonth,
            bool isCalendarLoading,
            Set<int> daysWithEvents,
            Map<DateTime, DateFeedState> feedStates,
            Set<int> expandedFeedIds,
            AlbumCache cache)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarTabUiState() when $default != null:
        return $default(
            _that.selectedDay,
            _that.focusedMonth,
            _that.isCalendarLoading,
            _that.daysWithEvents,
            _that.feedStates,
            _that.expandedFeedIds,
            _that.cache);
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
            DateTime selectedDay,
            DateTime focusedMonth,
            bool isCalendarLoading,
            Set<int> daysWithEvents,
            Map<DateTime, DateFeedState> feedStates,
            Set<int> expandedFeedIds,
            AlbumCache cache)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarTabUiState():
        return $default(
            _that.selectedDay,
            _that.focusedMonth,
            _that.isCalendarLoading,
            _that.daysWithEvents,
            _that.feedStates,
            _that.expandedFeedIds,
            _that.cache);
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
            DateTime selectedDay,
            DateTime focusedMonth,
            bool isCalendarLoading,
            Set<int> daysWithEvents,
            Map<DateTime, DateFeedState> feedStates,
            Set<int> expandedFeedIds,
            AlbumCache cache)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarTabUiState() when $default != null:
        return $default(
            _that.selectedDay,
            _that.focusedMonth,
            _that.isCalendarLoading,
            _that.daysWithEvents,
            _that.feedStates,
            _that.expandedFeedIds,
            _that.cache);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CalendarTabUiState extends CalendarTabUiState {
  const _CalendarTabUiState(
      {required this.selectedDay,
      required this.focusedMonth,
      this.isCalendarLoading = false,
      final Set<int> daysWithEvents = const {},
      final Map<DateTime, DateFeedState> feedStates = const {},
      final Set<int> expandedFeedIds = const {},
      this.cache = const AlbumCache()})
      : _daysWithEvents = daysWithEvents,
        _feedStates = feedStates,
        _expandedFeedIds = expandedFeedIds,
        super._();

  @override
  final DateTime selectedDay;
  @override
  final DateTime focusedMonth;
  @override
  @JsonKey()
  final bool isCalendarLoading;
  final Set<int> _daysWithEvents;
  @override
  @JsonKey()
  Set<int> get daysWithEvents {
    if (_daysWithEvents is EqualUnmodifiableSetView) return _daysWithEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_daysWithEvents);
  }

// 날짜별 피드. 캐시에 남아 있는(삭제되지 않은) 게시물 id만 담는다.
  final Map<DateTime, DateFeedState> _feedStates;
// 날짜별 피드. 캐시에 남아 있는(삭제되지 않은) 게시물 id만 담는다.
  @override
  @JsonKey()
  Map<DateTime, DateFeedState> get feedStates {
    if (_feedStates is EqualUnmodifiableMapView) return _feedStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_feedStates);
  }

  final Set<int> _expandedFeedIds;
  @override
  @JsonKey()
  Set<int> get expandedFeedIds {
    if (_expandedFeedIds is EqualUnmodifiableSetView) return _expandedFeedIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_expandedFeedIds);
  }

  @override
  @JsonKey()
  final AlbumCache cache;

  /// Create a copy of CalendarTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CalendarTabUiStateCopyWith<_CalendarTabUiState> get copyWith =>
      __$CalendarTabUiStateCopyWithImpl<_CalendarTabUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CalendarTabUiState &&
            (identical(other.selectedDay, selectedDay) ||
                other.selectedDay == selectedDay) &&
            (identical(other.focusedMonth, focusedMonth) ||
                other.focusedMonth == focusedMonth) &&
            (identical(other.isCalendarLoading, isCalendarLoading) ||
                other.isCalendarLoading == isCalendarLoading) &&
            const DeepCollectionEquality()
                .equals(other._daysWithEvents, _daysWithEvents) &&
            const DeepCollectionEquality()
                .equals(other._feedStates, _feedStates) &&
            const DeepCollectionEquality()
                .equals(other._expandedFeedIds, _expandedFeedIds) &&
            (identical(other.cache, cache) || other.cache == cache));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedDay,
      focusedMonth,
      isCalendarLoading,
      const DeepCollectionEquality().hash(_daysWithEvents),
      const DeepCollectionEquality().hash(_feedStates),
      const DeepCollectionEquality().hash(_expandedFeedIds),
      cache);

  @override
  String toString() {
    return 'CalendarTabUiState(selectedDay: $selectedDay, focusedMonth: $focusedMonth, isCalendarLoading: $isCalendarLoading, daysWithEvents: $daysWithEvents, feedStates: $feedStates, expandedFeedIds: $expandedFeedIds, cache: $cache)';
  }
}

/// @nodoc
abstract mixin class _$CalendarTabUiStateCopyWith<$Res>
    implements $CalendarTabUiStateCopyWith<$Res> {
  factory _$CalendarTabUiStateCopyWith(
          _CalendarTabUiState value, $Res Function(_CalendarTabUiState) _then) =
      __$CalendarTabUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime selectedDay,
      DateTime focusedMonth,
      bool isCalendarLoading,
      Set<int> daysWithEvents,
      Map<DateTime, DateFeedState> feedStates,
      Set<int> expandedFeedIds,
      AlbumCache cache});
}

/// @nodoc
class __$CalendarTabUiStateCopyWithImpl<$Res>
    implements _$CalendarTabUiStateCopyWith<$Res> {
  __$CalendarTabUiStateCopyWithImpl(this._self, this._then);

  final _CalendarTabUiState _self;
  final $Res Function(_CalendarTabUiState) _then;

  /// Create a copy of CalendarTabUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedDay = null,
    Object? focusedMonth = null,
    Object? isCalendarLoading = null,
    Object? daysWithEvents = null,
    Object? feedStates = null,
    Object? expandedFeedIds = null,
    Object? cache = null,
  }) {
    return _then(_CalendarTabUiState(
      selectedDay: null == selectedDay
          ? _self.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      focusedMonth: null == focusedMonth
          ? _self.focusedMonth
          : focusedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCalendarLoading: null == isCalendarLoading
          ? _self.isCalendarLoading
          : isCalendarLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      daysWithEvents: null == daysWithEvents
          ? _self._daysWithEvents
          : daysWithEvents // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      feedStates: null == feedStates
          ? _self._feedStates
          : feedStates // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, DateFeedState>,
      expandedFeedIds: null == expandedFeedIds
          ? _self._expandedFeedIds
          : expandedFeedIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      cache: null == cache
          ? _self.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as AlbumCache,
    ));
  }
}

// dart format on
