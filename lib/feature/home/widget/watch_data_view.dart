part of '../home_screen.dart';

class _WatchDataView extends StatelessWidget {
  final bool isLoading;
  final bool isWearing;
  final int? heartRate;
  final HeartRateStatus status;
  final DateTime? measuredAt;
  final VoidCallback onHeartRateClick;

  const _WatchDataView({
    required this.isLoading,
    required this.isWearing,
    required this.heartRate,
    required this.status,
    required this.measuredAt,
    required this.onHeartRateClick,
  });

  String _statusMessage(HeartRateStatus status) {
    return switch (status) {
      HeartRateStatus.normal => '안정',
      HeartRateStatus.emergency => '주의',
      HeartRateStatus.unknown => '-',
    };
  }

  SvgGenImage _statusIcon(HeartRateStatus status) {
    return switch (status) {
      HeartRateStatus.normal => Assets.icons.ic50HeartRateNormal,
      HeartRateStatus.emergency => Assets.icons.ic50HeartRateWarning,
      HeartRateStatus.unknown => Assets.icons.ic50HeartRateDisconnect,
    };
  }

  Color _statusColor(HeartRateStatus status) {
    return switch (status) {
      HeartRateStatus.normal => MyColor.purple600,
      HeartRateStatus.emergency => MyColor.red600,
      HeartRateStatus.unknown => MyColor.grey600,
    };
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: _TranslucentContainer(
              onTap: () =>
                  AppSettings.openAppSettings(type: AppSettingsType.bluetooth),
              content: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    WiduIcon(
                      icon: isWearing
                          ? Assets.icons.ic50Wearing
                          : Assets.icons.ic50HeartRateDisconnect,
                    ),
                    Text(
                      isWearing ? '착용 중' : '미착용',
                      style: MyTypo.title4.copyWith(
                        color: isWearing ? MyColor.green600 : MyColor.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -108,
                  right: -16,
                  child: IgnorePointer(
                    child: RepaintBoundary(
                      // 카드 뒤로 들어가는 다리·발은 블러가 없으면 카드 너머로 또렷하게 비친다.
                      // 그래서 카드 윗변까지만 그린다.
                      child: Assets.images.img111Mascot.image(
                        width: 111,
                        height: 108,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                _TranslucentContainer(
                  onTap: onHeartRateClick,
                  content: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Visibility(
                          visible: !isLoading,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Row(
                            spacing: 8,
                            children: [
                              WiduIcon(icon: _statusIcon(status)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 2,
                                children: [
                                  Row(
                                    spacing: 8,
                                    children: [
                                      Text(
                                        _statusMessage(status),
                                        style: MyTypo.title4.copyWith(
                                            color: _statusColor(status)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        child: Text(
                                          measuredAt == null
                                              ? '-'
                                              : DateFormat('HH:mm')
                                                  .format(measuredAt!),
                                          style: MyTypo.helper3
                                              .copyWith(color: MyColor.grey700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    spacing: 4,
                                    children: [
                                      Text(
                                        heartRate?.toString() ?? '-',
                                        style: MyTypo.title2,
                                      ),
                                      Text(
                                        'BPM',
                                        style: MyTypo.helper3
                                            .copyWith(color: MyColor.grey800),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isLoading) const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TranslucentContainer extends StatelessWidget {
  final Widget content;
  final VoidCallback onTap;

  const _TranslucentContainer({
    required this.content,
    required this.onTap,
  });

  /// 바탕 흰색의 불투명도.
  /// 뒤를 흐리는 `BackdropFilter`는 매 프레임 화면 전체를 복사하고 여러 번 흐려야 해서 raster 비용이 크다.
  /// 블러를 빼면 뒤 배경(나무·벤치)이 또렷하게 비치므로 0.5에서 올렸다. 디자인 확인 전 임시값이다.
  static const _fillAlpha = 0.7;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: MyColor.white.withValues(alpha: _fillAlpha),
            border: Border.all(
              color: MyColor.white.withValues(alpha: 0.6),
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
