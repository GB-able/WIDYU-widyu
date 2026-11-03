enum NotificationType {
  safetySelfCheck('SAFETY_SELF_CHECK'),
  medicationScheduleSync('MEDICATION_SCHEDULE_SYNC'),
  walkDataSync('WALK_DATA_SYNC');

  const NotificationType(this.value);

  final String value;

  bool matches(Map<String, dynamic> data) => data['notificationType'] == value;
}
