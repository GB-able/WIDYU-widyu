// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginViewModel)
final loginViewModelProvider = LoginViewModelProvider._();

final class LoginViewModelProvider
    extends $NotifierProvider<LoginViewModel, LoginUiState> {
  LoginViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'loginViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$loginViewModelHash();

  @$internal
  @override
  LoginViewModel create() => LoginViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginUiState>(value),
    );
  }
}

String _$loginViewModelHash() => r'101c90f4d0a3e2475942f0a81fdf4d298b3eec23';

abstract class _$LoginViewModel extends $Notifier<LoginUiState> {
  LoginUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LoginUiState, LoginUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<LoginUiState, LoginUiState>,
        LoginUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
