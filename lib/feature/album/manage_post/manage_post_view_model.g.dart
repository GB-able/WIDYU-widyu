// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_post_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 상태는 업로드·수정 요청 중인지 여부다.

@ProviderFor(ManagePostViewModel)
final managePostViewModelProvider = ManagePostViewModelProvider._();

/// 상태는 업로드·수정 요청 중인지 여부다.
final class ManagePostViewModelProvider
    extends $NotifierProvider<ManagePostViewModel, bool> {
  /// 상태는 업로드·수정 요청 중인지 여부다.
  ManagePostViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'managePostViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$managePostViewModelHash();

  @$internal
  @override
  ManagePostViewModel create() => ManagePostViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$managePostViewModelHash() =>
    r'3021d5f9dd0d4469b82af97a95ee1c0b966d8d56';

/// 상태는 업로드·수정 요청 중인지 여부다.

abstract class _$ManagePostViewModel extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
