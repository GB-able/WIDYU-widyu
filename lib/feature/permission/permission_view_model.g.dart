// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 상태는 권한 요청 진행 여부(isRequesting)다.

@ProviderFor(PermissionViewModel)
final permissionViewModelProvider = PermissionViewModelProvider._();

/// 상태는 권한 요청 진행 여부(isRequesting)다.
final class PermissionViewModelProvider
    extends $NotifierProvider<PermissionViewModel, bool> {
  /// 상태는 권한 요청 진행 여부(isRequesting)다.
  PermissionViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'permissionViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$permissionViewModelHash();

  @$internal
  @override
  PermissionViewModel create() => PermissionViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$permissionViewModelHash() =>
    r'71e50d7c2f1c0e198b20f43e971ce143526f9007';

/// 상태는 권한 요청 진행 여부(isRequesting)다.

abstract class _$PermissionViewModel extends $Notifier<bool> {
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
