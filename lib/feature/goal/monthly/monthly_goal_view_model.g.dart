// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_goal_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MonthlyGoalViewModel)
final monthlyGoalViewModelProvider = MonthlyGoalViewModelProvider._();

final class MonthlyGoalViewModelProvider
    extends $NotifierProvider<MonthlyGoalViewModel, MonthlyGoalUiState> {
  MonthlyGoalViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'monthlyGoalViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$monthlyGoalViewModelHash();

  @$internal
  @override
  MonthlyGoalViewModel create() => MonthlyGoalViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonthlyGoalUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonthlyGoalUiState>(value),
    );
  }
}

String _$monthlyGoalViewModelHash() =>
    r'363bffe68427c5046cb4da34cfd6e998a22f3eca';

abstract class _$MonthlyGoalViewModel extends $Notifier<MonthlyGoalUiState> {
  MonthlyGoalUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MonthlyGoalUiState, MonthlyGoalUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<MonthlyGoalUiState, MonthlyGoalUiState>,
        MonthlyGoalUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
