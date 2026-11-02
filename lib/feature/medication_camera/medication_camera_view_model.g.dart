// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_camera_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [group]은 라우트로 받은 복용 회차 묶음이다. Map은 객체 동일성으로 비교되므로
/// 화면이 처음 받은 Map을 고정해 넘겨야 화면마다 ViewModel 하나가 유지된다.

@ProviderFor(MedicationCameraViewModel)
final medicationCameraViewModelProvider = MedicationCameraViewModelFamily._();

/// [group]은 라우트로 받은 복용 회차 묶음이다. Map은 객체 동일성으로 비교되므로
/// 화면이 처음 받은 Map을 고정해 넘겨야 화면마다 ViewModel 하나가 유지된다.
final class MedicationCameraViewModelProvider extends $NotifierProvider<
    MedicationCameraViewModel, MedicationCameraUiState> {
  /// [group]은 라우트로 받은 복용 회차 묶음이다. Map은 객체 동일성으로 비교되므로
  /// 화면이 처음 받은 Map을 고정해 넘겨야 화면마다 ViewModel 하나가 유지된다.
  MedicationCameraViewModelProvider._(
      {required MedicationCameraViewModelFamily super.from,
      required Map<String, dynamic> super.argument})
      : super(
          retry: null,
          name: r'medicationCameraViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$medicationCameraViewModelHash();

  @override
  String toString() {
    return r'medicationCameraViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MedicationCameraViewModel create() => MedicationCameraViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicationCameraUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MedicationCameraUiState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationCameraViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicationCameraViewModelHash() =>
    r'1e9fe527408652085bb9f6ece9cd82ffe70c0ada';

/// [group]은 라우트로 받은 복용 회차 묶음이다. Map은 객체 동일성으로 비교되므로
/// 화면이 처음 받은 Map을 고정해 넘겨야 화면마다 ViewModel 하나가 유지된다.

final class MedicationCameraViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
            MedicationCameraViewModel,
            MedicationCameraUiState,
            MedicationCameraUiState,
            MedicationCameraUiState,
            Map<String, dynamic>> {
  MedicationCameraViewModelFamily._()
      : super(
          retry: null,
          name: r'medicationCameraViewModelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// [group]은 라우트로 받은 복용 회차 묶음이다. Map은 객체 동일성으로 비교되므로
  /// 화면이 처음 받은 Map을 고정해 넘겨야 화면마다 ViewModel 하나가 유지된다.

  MedicationCameraViewModelProvider call(
    Map<String, dynamic> group,
  ) =>
      MedicationCameraViewModelProvider._(argument: group, from: this);

  @override
  String toString() => r'medicationCameraViewModelProvider';
}

/// [group]은 라우트로 받은 복용 회차 묶음이다. Map은 객체 동일성으로 비교되므로
/// 화면이 처음 받은 Map을 고정해 넘겨야 화면마다 ViewModel 하나가 유지된다.

abstract class _$MedicationCameraViewModel
    extends $Notifier<MedicationCameraUiState> {
  late final _$args = ref.$arg as Map<String, dynamic>;
  Map<String, dynamic> get group => _$args;

  MedicationCameraUiState build(
    Map<String, dynamic> group,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<MedicationCameraUiState, MedicationCameraUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<MedicationCameraUiState, MedicationCameraUiState>,
        MedicationCameraUiState,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
