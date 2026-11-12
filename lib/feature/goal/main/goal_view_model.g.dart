// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GoalViewModel)
final goalViewModelProvider = GoalViewModelProvider._();

final class GoalViewModelProvider
    extends $NotifierProvider<GoalViewModel, GoalUiState> {
  GoalViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'goalViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$goalViewModelHash();

  @$internal
  @override
  GoalViewModel create() => GoalViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalUiState>(value),
    );
  }
}

String _$goalViewModelHash() => r'0e148b106247ef23029b3f100f322f853b0f5861';

abstract class _$GoalViewModel extends $Notifier<GoalUiState> {
  GoalUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GoalUiState, GoalUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<GoalUiState, GoalUiState>, GoalUiState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
