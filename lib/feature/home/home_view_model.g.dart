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

String _$homeViewModelHash() => r'85b5dc2025d903057be7067361d83f176da1fbf3';

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
