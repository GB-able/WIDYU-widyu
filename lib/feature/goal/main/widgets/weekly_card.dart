part of '../goal_screen.dart';

const _weekdayLabels = ['일', '월', '화', '수', '목', '금', '토'];

class _WeekdayRate {
  const _WeekdayRate({
    required this.label,
    required this.status,
    required this.isToday,
  });

  final String label;
  final GoalRateStatus status;
  final bool isToday;
}

extension _WeeklyGoalRates on List<GoalRateStatus> {
  List<_WeekdayRate> toWeekdayRates(DateTime today) {
    final todayIndex = today.weekday % 7;
    return List.generate(7, (index) {
      return _WeekdayRate(
        label: _weekdayLabels[index],
        status: index < length ? this[index] : GoalRateStatus.notStarted,
        isToday: index == todayIndex,
      );
    });
  }
}

class _WeeklyCard extends StatelessWidget {
  final List<GoalRateStatus> summary;

  const _WeeklyCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdayRates = summary.toWeekdayRates(now);

    return Container(
      decoration: BoxDecoration(
        color: MyColor.white.withValues(alpha: 0.7),
        border: Border.all(color: MyColor.white),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 8.5),
                      decoration: BoxDecoration(
                        color: MyColor.orange600,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          "${DateFormat("MM월 dd일 ").format(now)} ${now.weekdayLabel}요일",
                          style:
                              MyTypo.subTitle7.copyWith(color: MyColor.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '오늘도 목표를 위해 화이팅!',
                      style: MyTypo.title3.copyWith(color: MyColor.black),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/img_80_mascot.png',
                width: 80,
                height: 75,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                weekdayRates.map((day) => _WeekdayStamp(day: day)).toList(),
          ),
        ],
      ),
    );
  }
}

class _WeekdayStamp extends StatelessWidget {
  final _WeekdayRate day;

  const _WeekdayStamp({required this.day});

  static const _size = 28.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          day.label,
          style: MyTypo.subTitle3.copyWith(
            color: day.isToday ? MyColor.primary : MyColor.orange300,
          ),
        ),
        const SizedBox(height: 6),
        switch (day.status) {
          GoalRateStatus.completed => const IconWidget(
              icon: "circle_checked",
              width: _size,
            ),
          GoalRateStatus.inProgress => const _WaveCircle(
              size: _size,
              background: MyColor.orange50,
              waveColor: MyColor.primary,
            ),
          GoalRateStatus.notStarted || GoalRateStatus.failed => Container(
              width: _size,
              height: _size,
              decoration: const BoxDecoration(
                color: MyColor.orange50,
                shape: BoxShape.circle,
              ),
            ),
        },
      ],
    );
  }
}

class _WaveCircle extends StatefulWidget {
  const _WaveCircle({
    required this.size,
    required this.background,
    required this.waveColor,
  });

  final double size;
  final Color background;
  final Color waveColor;

  @override
  State<_WaveCircle> createState() => _WaveCircleState();
}

class _WaveCircleState extends State<_WaveCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipOval(
        child: ColoredBox(
          color: widget.background,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => CustomPaint(
              size: Size.square(widget.size),
              painter: _WavePainter(
                phase: _controller.value,
                color: widget.waveColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({required this.phase, required this.color});

  final double phase;
  final Color color;

  static const _waves = [
    (period: 1.0, speed: 1, amplitude: 2.0),
  ];

  static const _tilt = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final baseline = size.height / 2;
    final tilt = math.sin(phase * 2 * math.pi) * _tilt;

    double surfaceAt(double x) {
      final ratio = x / size.width;
      var y = baseline + (ratio - 0.5) * tilt;
      for (final wave in _waves) {
        final t = ratio * wave.period + phase * wave.speed;
        y += math.sin(t * 2 * math.pi) * wave.amplitude;
      }
      return y;
    }

    final path = Path()..moveTo(0, surfaceAt(0));
    for (var x = 1.0; x <= size.width; x += 1) {
      path.lineTo(x, surfaceAt(x));
    }

    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.color != color;
}
