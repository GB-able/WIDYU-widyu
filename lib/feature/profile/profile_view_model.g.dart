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

String _$profileViewModelHash() => r'ead8e6a17c238c240a8c0a48d42ccdc2d1237c00';

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
