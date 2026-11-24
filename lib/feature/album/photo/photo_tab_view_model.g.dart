// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_tab_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PhotoTabViewModel)
final photoTabViewModelProvider = PhotoTabViewModelProvider._();

final class PhotoTabViewModelProvider
    extends $NotifierProvider<PhotoTabViewModel, PhotoTabUiState> {
  PhotoTabViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'photoTabViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$photoTabViewModelHash();

  @$internal
  @override
  PhotoTabViewModel create() => PhotoTabViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoTabUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoTabUiState>(value),
    );
  }
}

String _$photoTabViewModelHash() => r'3e1f2507ea14961d4b0fa36c44fd7fb4c2e83708';

abstract class _$PhotoTabViewModel extends $Notifier<PhotoTabUiState> {
  PhotoTabUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PhotoTabUiState, PhotoTabUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PhotoTabUiState, PhotoTabUiState>,
        PhotoTabUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
