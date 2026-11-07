// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_page_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyPageViewModel)
final myPageViewModelProvider = MyPageViewModelProvider._();

final class MyPageViewModelProvider
    extends $NotifierProvider<MyPageViewModel, MyPageUiState> {
  MyPageViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myPageViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myPageViewModelHash();

  @$internal
  @override
  MyPageViewModel create() => MyPageViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyPageUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyPageUiState>(value),
    );
  }
}

String _$myPageViewModelHash() => r'907b91f75a52d18a6a3abe313a43f5edc73ab875';

abstract class _$MyPageViewModel extends $Notifier<MyPageUiState> {
  MyPageUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MyPageUiState, MyPageUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<MyPageUiState, MyPageUiState>,
        MyPageUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
