part of '../home_screen.dart';

class _DoseCountdown extends StatefulWidget {
  final DateTime deadline;
  final bool showHours;

  const _DoseCountdown({
    required this.deadline,
    required this.showHours,
  });

  @override
  State<_DoseCountdown> createState() => _DoseCountdownState();
}

class _DoseCountdownState extends State<_DoseCountdown> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _calculateRemaining();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateRemaining(),
    );
  }

  @override
  void didUpdateWidget(covariant _DoseCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadline != widget.deadline) _updateRemaining();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  Duration _calculateRemaining() {
    final diff = widget.deadline.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : Duration(seconds: diff.inSeconds);
  }

  void _updateRemaining() {
    final next = _calculateRemaining();
    if (next == _remaining) return;
    setState(() => _remaining = next);
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours.toString().padLeft(2, '0');
    final minutes = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      widget.showHours ? '$hours:$minutes:$seconds' : '$minutes:$seconds',
      style: MyTypo.title3.copyWith(color: MyColor.white),
    );
  }
}
