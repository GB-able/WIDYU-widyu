part of '../safety_check_screen.dart';

class _RemainingSeconds extends StatefulWidget {
  const _RemainingSeconds({required this.deadline});

  final DateTime deadline;

  @override
  State<_RemainingSeconds> createState() => _RemainingSecondsState();
}

class _RemainingSecondsState extends State<_RemainingSeconds> {
  late final _timer =
      Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));

  @override
  void initState() {
    super.initState();
    _timer;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.deadline.difference(DateTime.now());
    final seconds =
        remaining.isNegative ? 0 : (remaining.inMilliseconds / 1000).ceil();
    return Text(
      '남은 시간 $seconds초',
      style: MyTypo.title3.copyWith(color: MyColor.white),
    );
  }
}
