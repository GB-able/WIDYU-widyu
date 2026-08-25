part of '../home_screen.dart';

class _MedicationCard extends StatelessWidget {
  final MedicationStatus medicationStatus;
  final VoidCallback onCameraTap;
  final bool isCentered;

  const _MedicationCard({
    required this.medicationStatus,
    required this.onCameraTap,
    required this.isCentered,
  });

  static const _medicationBlobSpecs = <_BlobSpec>[
    _BlobSpec(
      centerX: 0.58,
      centerY: 0.25,
      amplitudeX: 0.04,
      amplitudeY: 0.04,
      freqX: 1,
      freqY: 1,
      phaseX: 0.00,
      phaseY: 0.25,
      radius: 0.58,
      opacity: 1.0,
      aspect: 1.0,
      angle: 0,
      wobble: 0.02,
      color: MyColor.primary600,
      edgeColor: MyColor.primary350,
    ),
    _BlobSpec(
      centerX: 0.0,
      centerY: 1.0,
      amplitudeX: 0.1,
      amplitudeY: 0.1,
      freqX: 1,
      freqY: 2,
      phaseX: 0.55,
      phaseY: 0.70,
      radius: 0.52,
      opacity: 0.95,
      aspect: 1.0,
      angle: 0,
      wobble: 0.02,
      color: MyColor.primary700,
      edgeColor: MyColor.primary50,
    ),
  ];

  (int, int)? get _progress => switch (medicationStatus) {
        MedicationAvailable(:final takenCount, :final totalCount) => (
            takenCount,
            totalCount
          ),
        MedicationUpcoming(:final takenCount, :final totalCount) => (
            takenCount,
            totalCount
          ),
        MedicationCompleted(:final totalCount) => (totalCount, totalCount),
        MedicationMissed() || MedicationNone() || MedicationUnknown() => null,
      };

  DateTime? get _closesAt => switch (medicationStatus) {
        MedicationAvailable(:final closesAt) => closesAt,
        _ => null,
      };

  String? get _badgeLabel => switch (medicationStatus) {
        MedicationAvailable() => null,
        MedicationUpcoming() => '예정',
        MedicationCompleted() => '완료',
        MedicationMissed() ||
        MedicationNone() ||
        MedicationUnknown() =>
          '인증 불가능',
      };

  bool get _isDimmed => _badgeLabel != null;

  bool get _showCameraButton => switch (medicationStatus) {
        MedicationAvailable() => true,
        MedicationUpcoming() ||
        MedicationCompleted() ||
        MedicationMissed() ||
        MedicationNone() ||
        MedicationUnknown() =>
          false,
      };

  static const _meshBackground = MeshGradientBackground(
    baseColor: MyColor.white,
    blobs: _medicationBlobSpecs,
    blurSigma: 28,
    topScrimAlpha: 0,
  );

  Widget get _pillImage => Padding(
        padding: const EdgeInsets.all(20),
        child: _SpringBounce(
          isActive: isCentered,
          child: FractionalTranslation(
            translation: const Offset(0.05, 0.05),
            child: Transform.scale(
              scale: 1.1,
              child: const WidyuAssetImage(
                name: 'img_medicine.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );

  Widget get _background => Stack(
        fit: StackFit.expand,
        children: [
          _meshBackground,
          _pillImage,
          if (_isDimmed)
            ColoredBox(color: MyColor.black.withValues(alpha: 0.5)),
        ],
      );

  Widget _statusBadge(String label) => Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: MyColor.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10000),
          ),
          child: Text(
            label,
            style: MyTypo.title1.copyWith(color: MyColor.white),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    final closesAt = _closesAt;
    final badgeLabel = _badgeLabel;

    return _CarouselCardShell(
      title: '약 복용',
      background: _background,
      content: Stack(
        fit: StackFit.expand,
        children: [
          if (badgeLabel != null) _statusBadge(badgeLabel),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                if (closesAt != null) _DoseCountdown(closesAt: closesAt),
                if (_showCameraButton)
                  Material(
                    type: MaterialType.transparency,
                    child: TextBtn(
                      onTap: onCameraTap,
                      text: '카메라',
                      enable: true,
                    ),
                  ),
              ],
            ),
          ),
          if (progress != null)
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '${progress.$1}/${progress.$2}회',
                style: MyTypo.title1.copyWith(color: MyColor.white),
              ),
            ),
        ],
      ),
    );
  }
}
