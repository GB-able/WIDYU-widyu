abstract class MedicationAlarmLocalDataSource {
  Stream<void> get changes;

  Future<Map<String, dynamic>> capabilities();

  Future<Map<String, dynamic>> activate(String memberId);

  Future<Map<String, dynamic>> state();

  Future<Map<String, dynamic>> activeGroup();

  Future<Map<String, dynamic>> applySchedule({
    required String sessionId,
    required Map<String, dynamic> schedule,
    required List<Map<String, dynamic>> groups,
  });

  Future<Map<String, dynamic>> complete({
    required String sessionId,
    required List<String> occurrenceIds,
  });

  Future<void> stop(String groupId);

  Future<void> clearSession();

  Future<Map<String, dynamic>> pendingLaunch();

  Future<void> acknowledgeLaunch(String eventId);
}
