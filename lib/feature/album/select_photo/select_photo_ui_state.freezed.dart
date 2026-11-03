// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_photo_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SelectPhotoUiState {
  PermissionStatus? get cameraPermission;
  PermissionState? get photoPermission;
  PhotoFilter get filter;
  Map<PhotoFilter, List<AssetEntity>> get assetsByFilter;
  Map<PhotoFilter, int> get totalCountByFilter;
  Map<PhotoFilter, bool> get hasMoreByFilter;
  Set<PhotoFilter> get loadingFilters;
  List<AssetEntity> get selected;
  bool get isCapturing;

  /// Create a copy of SelectPhotoUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SelectPhotoUiStateCopyWith<SelectPhotoUiState> get copyWith =>
      _$SelectPhotoUiStateCopyWithImpl<SelectPhotoUiState>(
          this as SelectPhotoUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SelectPhotoUiState &&
            (identical(other.cameraPermission, cameraPermission) ||
                other.cameraPermission == cameraPermission) &&
            (identical(other.photoPermission, photoPermission) ||
                other.photoPermission == photoPermission) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            const DeepCollectionEquality()
                .equals(other.assetsByFilter, assetsByFilter) &&
            const DeepCollectionEquality()
                .equals(other.totalCountByFilter, totalCountByFilter) &&
            const DeepCollectionEquality()
                .equals(other.hasMoreByFilter, hasMoreByFilter) &&
            const DeepCollectionEquality()
                .equals(other.loadingFilters, loadingFilters) &&
            const DeepCollectionEquality().equals(other.selected, selected) &&
            (identical(other.isCapturing, isCapturing) ||
                other.isCapturing == isCapturing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      cameraPermission,
      photoPermission,
      filter,
      const DeepCollectionEquality().hash(assetsByFilter),
      const DeepCollectionEquality().hash(totalCountByFilter),
      const DeepCollectionEquality().hash(hasMoreByFilter),
      const DeepCollectionEquality().hash(loadingFilters),
      const DeepCollectionEquality().hash(selected),
      isCapturing);

  @override
  String toString() {
    return 'SelectPhotoUiState(cameraPermission: $cameraPermission, photoPermission: $photoPermission, filter: $filter, assetsByFilter: $assetsByFilter, totalCountByFilter: $totalCountByFilter, hasMoreByFilter: $hasMoreByFilter, loadingFilters: $loadingFilters, selected: $selected, isCapturing: $isCapturing)';
  }
}

/// @nodoc
abstract mixin class $SelectPhotoUiStateCopyWith<$Res> {
  factory $SelectPhotoUiStateCopyWith(
          SelectPhotoUiState value, $Res Function(SelectPhotoUiState) _then) =
      _$SelectPhotoUiStateCopyWithImpl;
  @useResult
  $Res call(
      {PermissionStatus? cameraPermission,
      PermissionState? photoPermission,
      PhotoFilter filter,
      Map<PhotoFilter, List<AssetEntity>> assetsByFilter,
      Map<PhotoFilter, int> totalCountByFilter,
      Map<PhotoFilter, bool> hasMoreByFilter,
      Set<PhotoFilter> loadingFilters,
      List<AssetEntity> selected,
      bool isCapturing});
}

/// @nodoc
class _$SelectPhotoUiStateCopyWithImpl<$Res>
    implements $SelectPhotoUiStateCopyWith<$Res> {
  _$SelectPhotoUiStateCopyWithImpl(this._self, this._then);

  final SelectPhotoUiState _self;
  final $Res Function(SelectPhotoUiState) _then;

  /// Create a copy of SelectPhotoUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameraPermission = freezed,
    Object? photoPermission = freezed,
    Object? filter = null,
    Object? assetsByFilter = null,
    Object? totalCountByFilter = null,
    Object? hasMoreByFilter = null,
    Object? loadingFilters = null,
    Object? selected = null,
    Object? isCapturing = null,
  }) {
    return _then(_self.copyWith(
      cameraPermission: freezed == cameraPermission
          ? _self.cameraPermission
          : cameraPermission // ignore: cast_nullable_to_non_nullable
              as PermissionStatus?,
      photoPermission: freezed == photoPermission
          ? _self.photoPermission
          : photoPermission // ignore: cast_nullable_to_non_nullable
              as PermissionState?,
      filter: null == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as PhotoFilter,
      assetsByFilter: null == assetsByFilter
          ? _self.assetsByFilter
          : assetsByFilter // ignore: cast_nullable_to_non_nullable
              as Map<PhotoFilter, List<AssetEntity>>,
      totalCountByFilter: null == totalCountByFilter
          ? _self.totalCountByFilter
          : totalCountByFilter // ignore: cast_nullable_to_non_nullable
              as Map<PhotoFilter, int>,
      hasMoreByFilter: null == hasMoreByFilter
          ? _self.hasMoreByFilter
          : hasMoreByFilter // ignore: cast_nullable_to_non_nullable
              as Map<PhotoFilter, bool>,
      loadingFilters: null == loadingFilters
          ? _self.loadingFilters
          : loadingFilters // ignore: cast_nullable_to_non_nullable
              as Set<PhotoFilter>,
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as List<AssetEntity>,
      isCapturing: null == isCapturing
          ? _self.isCapturing
          : isCapturing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SelectPhotoUiState].
extension SelectPhotoUiStatePatterns on SelectPhotoUiState {
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
    TResult Function(_SelectPhotoUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SelectPhotoUiState() when $default != null:
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
    TResult Function(_SelectPhotoUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SelectPhotoUiState():
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
    TResult? Function(_SelectPhotoUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SelectPhotoUiState() when $default != null:
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
            PermissionStatus? cameraPermission,
            PermissionState? photoPermission,
            PhotoFilter filter,
            Map<PhotoFilter, List<AssetEntity>> assetsByFilter,
            Map<PhotoFilter, int> totalCountByFilter,
            Map<PhotoFilter, bool> hasMoreByFilter,
            Set<PhotoFilter> loadingFilters,
            List<AssetEntity> selected,
            bool isCapturing)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SelectPhotoUiState() when $default != null:
        return $default(
            _that.cameraPermission,
            _that.photoPermission,
            _that.filter,
            _that.assetsByFilter,
            _that.totalCountByFilter,
            _that.hasMoreByFilter,
            _that.loadingFilters,
            _that.selected,
            _that.isCapturing);
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
            PermissionStatus? cameraPermission,
            PermissionState? photoPermission,
            PhotoFilter filter,
            Map<PhotoFilter, List<AssetEntity>> assetsByFilter,
            Map<PhotoFilter, int> totalCountByFilter,
            Map<PhotoFilter, bool> hasMoreByFilter,
            Set<PhotoFilter> loadingFilters,
            List<AssetEntity> selected,
            bool isCapturing)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SelectPhotoUiState():
        return $default(
            _that.cameraPermission,
            _that.photoPermission,
            _that.filter,
            _that.assetsByFilter,
            _that.totalCountByFilter,
            _that.hasMoreByFilter,
            _that.loadingFilters,
            _that.selected,
            _that.isCapturing);
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
            PermissionStatus? cameraPermission,
            PermissionState? photoPermission,
            PhotoFilter filter,
            Map<PhotoFilter, List<AssetEntity>> assetsByFilter,
            Map<PhotoFilter, int> totalCountByFilter,
            Map<PhotoFilter, bool> hasMoreByFilter,
            Set<PhotoFilter> loadingFilters,
            List<AssetEntity> selected,
            bool isCapturing)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SelectPhotoUiState() when $default != null:
        return $default(
            _that.cameraPermission,
            _that.photoPermission,
            _that.filter,
            _that.assetsByFilter,
            _that.totalCountByFilter,
            _that.hasMoreByFilter,
            _that.loadingFilters,
            _that.selected,
            _that.isCapturing);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SelectPhotoUiState extends SelectPhotoUiState {
  const _SelectPhotoUiState(
      {this.cameraPermission,
      this.photoPermission,
      this.filter = PhotoFilter.all,
      final Map<PhotoFilter, List<AssetEntity>> assetsByFilter = const {},
      final Map<PhotoFilter, int> totalCountByFilter = const {},
      final Map<PhotoFilter, bool> hasMoreByFilter = const {},
      final Set<PhotoFilter> loadingFilters = const {},
      final List<AssetEntity> selected = const [],
      this.isCapturing = false})
      : _assetsByFilter = assetsByFilter,
        _totalCountByFilter = totalCountByFilter,
        _hasMoreByFilter = hasMoreByFilter,
        _loadingFilters = loadingFilters,
        _selected = selected,
        super._();

  @override
  final PermissionStatus? cameraPermission;
  @override
  final PermissionState? photoPermission;
  @override
  @JsonKey()
  final PhotoFilter filter;
  final Map<PhotoFilter, List<AssetEntity>> _assetsByFilter;
  @override
  @JsonKey()
  Map<PhotoFilter, List<AssetEntity>> get assetsByFilter {
    if (_assetsByFilter is EqualUnmodifiableMapView) return _assetsByFilter;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_assetsByFilter);
  }

  final Map<PhotoFilter, int> _totalCountByFilter;
  @override
  @JsonKey()
  Map<PhotoFilter, int> get totalCountByFilter {
    if (_totalCountByFilter is EqualUnmodifiableMapView)
      return _totalCountByFilter;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_totalCountByFilter);
  }

  final Map<PhotoFilter, bool> _hasMoreByFilter;
  @override
  @JsonKey()
  Map<PhotoFilter, bool> get hasMoreByFilter {
    if (_hasMoreByFilter is EqualUnmodifiableMapView) return _hasMoreByFilter;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_hasMoreByFilter);
  }

  final Set<PhotoFilter> _loadingFilters;
  @override
  @JsonKey()
  Set<PhotoFilter> get loadingFilters {
    if (_loadingFilters is EqualUnmodifiableSetView) return _loadingFilters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_loadingFilters);
  }

  final List<AssetEntity> _selected;
  @override
  @JsonKey()
  List<AssetEntity> get selected {
    if (_selected is EqualUnmodifiableListView) return _selected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selected);
  }

  @override
  @JsonKey()
  final bool isCapturing;

  /// Create a copy of SelectPhotoUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SelectPhotoUiStateCopyWith<_SelectPhotoUiState> get copyWith =>
      __$SelectPhotoUiStateCopyWithImpl<_SelectPhotoUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SelectPhotoUiState &&
            (identical(other.cameraPermission, cameraPermission) ||
                other.cameraPermission == cameraPermission) &&
            (identical(other.photoPermission, photoPermission) ||
                other.photoPermission == photoPermission) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            const DeepCollectionEquality()
                .equals(other._assetsByFilter, _assetsByFilter) &&
            const DeepCollectionEquality()
                .equals(other._totalCountByFilter, _totalCountByFilter) &&
            const DeepCollectionEquality()
                .equals(other._hasMoreByFilter, _hasMoreByFilter) &&
            const DeepCollectionEquality()
                .equals(other._loadingFilters, _loadingFilters) &&
            const DeepCollectionEquality().equals(other._selected, _selected) &&
            (identical(other.isCapturing, isCapturing) ||
                other.isCapturing == isCapturing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      cameraPermission,
      photoPermission,
      filter,
      const DeepCollectionEquality().hash(_assetsByFilter),
      const DeepCollectionEquality().hash(_totalCountByFilter),
      const DeepCollectionEquality().hash(_hasMoreByFilter),
      const DeepCollectionEquality().hash(_loadingFilters),
      const DeepCollectionEquality().hash(_selected),
      isCapturing);

  @override
  String toString() {
    return 'SelectPhotoUiState(cameraPermission: $cameraPermission, photoPermission: $photoPermission, filter: $filter, assetsByFilter: $assetsByFilter, totalCountByFilter: $totalCountByFilter, hasMoreByFilter: $hasMoreByFilter, loadingFilters: $loadingFilters, selected: $selected, isCapturing: $isCapturing)';
  }
}

/// @nodoc
abstract mixin class _$SelectPhotoUiStateCopyWith<$Res>
    implements $SelectPhotoUiStateCopyWith<$Res> {
  factory _$SelectPhotoUiStateCopyWith(
          _SelectPhotoUiState value, $Res Function(_SelectPhotoUiState) _then) =
      __$SelectPhotoUiStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {PermissionStatus? cameraPermission,
      PermissionState? photoPermission,
      PhotoFilter filter,
      Map<PhotoFilter, List<AssetEntity>> assetsByFilter,
      Map<PhotoFilter, int> totalCountByFilter,
      Map<PhotoFilter, bool> hasMoreByFilter,
      Set<PhotoFilter> loadingFilters,
      List<AssetEntity> selected,
      bool isCapturing});
}

/// @nodoc
class __$SelectPhotoUiStateCopyWithImpl<$Res>
    implements _$SelectPhotoUiStateCopyWith<$Res> {
  __$SelectPhotoUiStateCopyWithImpl(this._self, this._then);

  final _SelectPhotoUiState _self;
  final $Res Function(_SelectPhotoUiState) _then;

  /// Create a copy of SelectPhotoUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cameraPermission = freezed,
    Object? photoPermission = freezed,
    Object? filter = null,
    Object? assetsByFilter = null,
    Object? totalCountByFilter = null,
    Object? hasMoreByFilter = null,
    Object? loadingFilters = null,
    Object? selected = null,
    Object? isCapturing = null,
  }) {
    return _then(_SelectPhotoUiState(
      cameraPermission: freezed == cameraPermission
          ? _self.cameraPermission
          : cameraPermission // ignore: cast_nullable_to_non_nullable
              as PermissionStatus?,
      photoPermission: freezed == photoPermission
          ? _self.photoPermission
          : photoPermission // ignore: cast_nullable_to_non_nullable
              as PermissionState?,
      filter: null == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as PhotoFilter,
      assetsByFilter: null == assetsByFilter
          ? _self._assetsByFilter
          : assetsByFilter // ignore: cast_nullable_to_non_nullable
              as Map<PhotoFilter, List<AssetEntity>>,
      totalCountByFilter: null == totalCountByFilter
          ? _self._totalCountByFilter
          : totalCountByFilter // ignore: cast_nullable_to_non_nullable
              as Map<PhotoFilter, int>,
      hasMoreByFilter: null == hasMoreByFilter
          ? _self._hasMoreByFilter
          : hasMoreByFilter // ignore: cast_nullable_to_non_nullable
              as Map<PhotoFilter, bool>,
      loadingFilters: null == loadingFilters
          ? _self._loadingFilters
          : loadingFilters // ignore: cast_nullable_to_non_nullable
              as Set<PhotoFilter>,
      selected: null == selected
          ? _self._selected
          : selected // ignore: cast_nullable_to_non_nullable
              as List<AssetEntity>,
      isCapturing: null == isCapturing
          ? _self.isCapturing
          : isCapturing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
