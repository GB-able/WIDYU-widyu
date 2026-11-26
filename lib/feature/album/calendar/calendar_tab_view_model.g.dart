// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_tab_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CalendarTabViewModel)
final calendarTabViewModelProvider = CalendarTabViewModelProvider._();

final class CalendarTabViewModelProvider
    extends $NotifierProvider<CalendarTabViewModel, CalendarTabUiState> {
  CalendarTabViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'calendarTabViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$calendarTabViewModelHash();

  @$internal
  @override
  CalendarTabViewModel create() => CalendarTabViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalendarTabUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalendarTabUiState>(value),
    );
  }
}

String _$calendarTabViewModelHash() =>
    r'7245e1d9410d35f858fd9059b34136693755e50b';

abstract class _$CalendarTabViewModel extends $Notifier<CalendarTabUiState> {
  CalendarTabUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CalendarTabUiState, CalendarTabUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<CalendarTabUiState, CalendarTabUiState>,
        CalendarTabUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
