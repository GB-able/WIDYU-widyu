const walkUtcOffset = Duration(
  minutes: int.fromEnvironment(
    'STEP_DAY_UTC_OFFSET_MINUTES',
    defaultValue: 540,
  ),
);

extension WalkDateTimeExtension on DateTime {
  String get walkDate =>
      toUtc().add(walkUtcOffset).toIso8601String().substring(0, 10);

  List<String> get walkDateWindow => [
        for (var i = 6; i >= 0; i--) walkDate.walkDateShift(-i),
      ];
}

extension WalkStringExtension on String {
  DateTime get walkStartOf =>
      DateTime.parse('${this}T00:00:00Z').subtract(walkUtcOffset);

  String walkDateShift(int days) => DateTime.parse(
        '${this}T00:00:00Z',
      ).add(Duration(days: days)).toIso8601String().substring(0, 10);

  bool isWalkDateAllowed(DateTime now) => now.walkDateWindow.contains(this);
}
