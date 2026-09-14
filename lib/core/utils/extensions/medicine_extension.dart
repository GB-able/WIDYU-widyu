const medicationVerifyWindow = Duration(minutes: 30);

extension MedicineExtension on DateTime {
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
