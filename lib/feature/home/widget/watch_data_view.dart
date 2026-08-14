part of '../home_screen.dart';

class _WatchDataView extends StatelessWidget {
  final bool isLoading;
  final bool isWearing;
  final int heartRate;
  final HeartRateStatus status;
  final DateTime measuredAt;
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

  String _statusIcon(HeartRateStatus status) {
    return switch (status) {
      HeartRateStatus.normal => 'ic_50_heart_rate_normal.svg',
      HeartRateStatus.emergency => 'ic_50_heart_rate_warning.svg',
      HeartRateStatus.unknown => 'ic_50_heart_rate_disconnect.svg',
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
                    WidyuIcon(
                      icon: isWearing
                          ? 'ic_50_wearing.svg'
                          : 'ic_50_heart_rate_disconnect.svg',
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
                      child: Image.asset('assets/images/img_mascot.png'),
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
                              WidyuIcon(icon: _statusIcon(status)),
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
                                          DateFormat('HH:mm')
                                              .format(measuredAt),
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
                                        heartRate.toString(),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: MyColor.white.withValues(alpha: 0.5),
              border: Border.all(
                color: MyColor.white.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
