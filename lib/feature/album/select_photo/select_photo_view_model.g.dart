// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_photo_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectPhotoViewModel)
final selectPhotoViewModelProvider = SelectPhotoViewModelProvider._();

final class SelectPhotoViewModelProvider
    extends $NotifierProvider<SelectPhotoViewModel, SelectPhotoUiState> {
  SelectPhotoViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectPhotoViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectPhotoViewModelHash();

  @$internal
  @override
  SelectPhotoViewModel create() => SelectPhotoViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectPhotoUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectPhotoUiState>(value),
    );
  }
}

String _$selectPhotoViewModelHash() =>
    r'd574790be567bcb47d6153d340c97ef71c9a6de9';

abstract class _$SelectPhotoViewModel extends $Notifier<SelectPhotoUiState> {
  SelectPhotoUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SelectPhotoUiState, SelectPhotoUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SelectPhotoUiState, SelectPhotoUiState>,
        SelectPhotoUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
