const medicationVerifyWindow = Duration(minutes: 30);

/// 약 복용 인증은 알람 전후 30분 안에 받는다. 자정을 넘어도 자르지 않는다:
/// 23:45 알람은 다음 날 00:15까지, 00:10 알람은 전날 23:40부터 인증할 수 있다
/// (서버 MedicationProofTransactionService.resolveDoseDate).
extension MedicationExtension on DateTime {
  DateTime get windowOpensAt => subtract(medicationVerifyWindow);

  DateTime get windowClosesAt => add(medicationVerifyWindow);

  bool isWithinVerifyWindow(DateTime now) {
    return !now.isBefore(windowOpensAt) && !now.isAfter(windowClosesAt);
  }
}

extension DoseCountExtension on double {
  String get doseLabel =>
      toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}
