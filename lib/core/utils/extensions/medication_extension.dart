const medicationVerifyWindow = Duration(minutes: 30);

extension MedicationExtension on DateTime {
  DateTime get windowOpensAt {
    final open = subtract(medicationVerifyWindow);
    if (open.day != day) return DateTime(year, month, day);
    return open;
  }

  DateTime get windowClosesAt {
    final close = add(medicationVerifyWindow);
    if (close.day != day) return DateTime(year, month, day, 23, 59);
    return close;
  }

  bool isWithinVerifyWindow(DateTime now) {
    return !now.isBefore(windowOpensAt) && !now.isAfter(windowClosesAt);
  }
}

extension DoseCountExtension on double {
  String get doseLabel =>
      toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}
