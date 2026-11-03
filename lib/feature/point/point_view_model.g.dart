// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PointViewModel)
final pointViewModelProvider = PointViewModelProvider._();

final class PointViewModelProvider
    extends $NotifierProvider<PointViewModel, PointUiState> {
  PointViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pointViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pointViewModelHash();

  @$internal
  @override
  PointViewModel create() => PointViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PointUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PointUiState>(value),
    );
  }
}

String _$pointViewModelHash() => r'4cbb517d530f0cbe9c316acffff3b0dfd096beb9';

abstract class _$PointViewModel extends $Notifier<PointUiState> {
  PointUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PointUiState, PointUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PointUiState, PointUiState>,
        PointUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
