// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileViewModel)
final profileViewModelProvider = ProfileViewModelProvider._();

final class ProfileViewModelProvider
    extends $NotifierProvider<ProfileViewModel, ProfileUiState> {
  ProfileViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'profileViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$profileViewModelHash();

  @$internal
  @override
  ProfileViewModel create() => ProfileViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileUiState>(value),
    );
  }
}

String _$profileViewModelHash() => r'867800782e64623a5ad1385e0ac86a6274d5e07a';

abstract class _$ProfileViewModel extends $Notifier<ProfileUiState> {
  ProfileUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProfileUiState, ProfileUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ProfileUiState, ProfileUiState>,
        ProfileUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
