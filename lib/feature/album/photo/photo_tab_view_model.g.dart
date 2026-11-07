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

String _$photoTabViewModelHash() => r'942e0c4d0a8d59e372e99c1fba594f6a9189cf7a';

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
