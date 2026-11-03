// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationViewModel)
final notificationViewModelProvider = NotificationViewModelProvider._();

final class NotificationViewModelProvider
    extends $NotifierProvider<NotificationViewModel, NotificationUiState> {
  NotificationViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationViewModelHash();

  @$internal
  @override
  NotificationViewModel create() => NotificationViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationUiState>(value),
    );
  }
}

String _$notificationViewModelHash() =>
    r'3b1fe58d3b2a222a9bbea31d613947a4b3fdee7c';

abstract class _$NotificationViewModel extends $Notifier<NotificationUiState> {
  NotificationUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NotificationUiState, NotificationUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<NotificationUiState, NotificationUiState>,
        NotificationUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
