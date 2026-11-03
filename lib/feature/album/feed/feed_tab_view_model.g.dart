// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_tab_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FeedTabViewModel)
final feedTabViewModelProvider = FeedTabViewModelProvider._();

final class FeedTabViewModelProvider
    extends $NotifierProvider<FeedTabViewModel, FeedTabUiState> {
  FeedTabViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'feedTabViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$feedTabViewModelHash();

  @$internal
  @override
  FeedTabViewModel create() => FeedTabViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedTabUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedTabUiState>(value),
    );
  }
}

String _$feedTabViewModelHash() => r'f52deec601b4ee53f18c7468ec50c8910f99d31e';

abstract class _$FeedTabViewModel extends $Notifier<FeedTabUiState> {
  FeedTabUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FeedTabUiState, FeedTabUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FeedTabUiState, FeedTabUiState>,
        FeedTabUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
