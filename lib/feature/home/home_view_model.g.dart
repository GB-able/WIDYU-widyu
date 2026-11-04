// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeViewModel)
final homeViewModelProvider = HomeViewModelProvider._();

final class HomeViewModelProvider
    extends $NotifierProvider<HomeViewModel, HomeUiState> {
  HomeViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeViewModelHash();

  @$internal
  @override
  HomeViewModel create() => HomeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeUiState>(value),
    );
  }
}

String _$homeViewModelHash() => r'b7f16e8eebc3713046f156eb761b2dc7473d9cf6';

abstract class _$HomeViewModel extends $Notifier<HomeUiState> {
  HomeUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomeUiState, HomeUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<HomeUiState, HomeUiState>, HomeUiState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
