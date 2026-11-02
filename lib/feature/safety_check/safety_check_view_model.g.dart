// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_check_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SafetyCheckViewModel)
final safetyCheckViewModelProvider = SafetyCheckViewModelFamily._();

final class SafetyCheckViewModelProvider
    extends $NotifierProvider<SafetyCheckViewModel, SafetyCheckUiState> {
  SafetyCheckViewModelProvider._(
      {required SafetyCheckViewModelFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'safetyCheckViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$safetyCheckViewModelHash();

  @override
  String toString() {
    return r'safetyCheckViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SafetyCheckViewModel create() => SafetyCheckViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SafetyCheckUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SafetyCheckUiState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SafetyCheckViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$safetyCheckViewModelHash() =>
    r'effdae068cd96260f655b8317670afc7e93acea2';

final class SafetyCheckViewModelFamily extends $Family
    with
        $ClassFamilyOverride<SafetyCheckViewModel, SafetyCheckUiState,
            SafetyCheckUiState, SafetyCheckUiState, String> {
  SafetyCheckViewModelFamily._()
      : super(
          retry: null,
          name: r'safetyCheckViewModelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SafetyCheckViewModelProvider call(
    String incidentId,
  ) =>
      SafetyCheckViewModelProvider._(argument: incidentId, from: this);

  @override
  String toString() => r'safetyCheckViewModelProvider';
}

abstract class _$SafetyCheckViewModel extends $Notifier<SafetyCheckUiState> {
  late final _$args = ref.$arg as String;
  String get incidentId => _$args;

  SafetyCheckUiState build(
    String incidentId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SafetyCheckUiState, SafetyCheckUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SafetyCheckUiState, SafetyCheckUiState>,
        SafetyCheckUiState,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
