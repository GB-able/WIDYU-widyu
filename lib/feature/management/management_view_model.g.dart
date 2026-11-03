// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'management_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManagementViewModel)
final managementViewModelProvider = ManagementViewModelProvider._();

final class ManagementViewModelProvider
    extends $NotifierProvider<ManagementViewModel, ManagementUiState> {
  ManagementViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'managementViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$managementViewModelHash();

  @$internal
  @override
  ManagementViewModel create() => ManagementViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManagementUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManagementUiState>(value),
    );
  }
}

String _$managementViewModelHash() =>
    r'd056c9cc468f2c6bbc6bc9f2b1eda393545481a6';

abstract class _$ManagementViewModel extends $Notifier<ManagementUiState> {
  ManagementUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ManagementUiState, ManagementUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ManagementUiState, ManagementUiState>,
        ManagementUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
