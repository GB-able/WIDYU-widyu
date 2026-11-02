// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactViewModel)
final contactViewModelProvider = ContactViewModelProvider._();

final class ContactViewModelProvider
    extends $NotifierProvider<ContactViewModel, ContactUiState> {
  ContactViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'contactViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$contactViewModelHash();

  @$internal
  @override
  ContactViewModel create() => ContactViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactUiState>(value),
    );
  }
}

String _$contactViewModelHash() => r'b2eb5fe3199c5eaf526d2f5029c2a2bc6bdea2d1';

abstract class _$ContactViewModel extends $Notifier<ContactUiState> {
  ContactUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ContactUiState, ContactUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ContactUiState, ContactUiState>,
        ContactUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
