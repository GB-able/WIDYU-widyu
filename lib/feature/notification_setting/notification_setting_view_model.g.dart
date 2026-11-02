// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_setting_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationSettingViewModel)
final notificationSettingViewModelProvider =
    NotificationSettingViewModelProvider._();

final class NotificationSettingViewModelProvider extends $NotifierProvider<
    NotificationSettingViewModel, NotificationSettingUiState> {
  NotificationSettingViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationSettingViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingViewModelHash();

  @$internal
  @override
  NotificationSettingViewModel create() => NotificationSettingViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationSettingUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationSettingUiState>(value),
    );
  }
}

String _$notificationSettingViewModelHash() =>
    r'c2cd80079970a17648b07f0ab9c7e06186abd88f';

abstract class _$NotificationSettingViewModel
    extends $Notifier<NotificationSettingUiState> {
  NotificationSettingUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<NotificationSettingUiState, NotificationSettingUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<NotificationSettingUiState, NotificationSettingUiState>,
        NotificationSettingUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
