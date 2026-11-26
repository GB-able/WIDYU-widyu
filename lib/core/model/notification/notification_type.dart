enum NotificationType {
  safetySelfCheck('SAFETY_SELF_CHECK'),
  medicationScheduleSync('MEDICATION_SCHEDULE_SYNC'),
  medicationScheduleCreated('MEDICATION_SCHEDULE_CREATED'),
  medicationScheduleChanged('MEDICATION_SCHEDULE_CHANGED'),
  medicationScheduleDeleted('MEDICATION_SCHEDULE_DELETED'),
  healthScheduleCreated('HEALTH_SCHEDULE_CREATED'),
  healthScheduleUpdated('HEALTH_SCHEDULE_UPDATED'),
  healthScheduleDeleted('HEALTH_SCHEDULE_DELETED'),
  walkGoalChanged('WALK_GOAL_CHANGED'),
  albumUploadComplete('ALBUM_UPLOAD_COMPLETE'),
  albumCreated('ALBUM_CREATED'),
  walkDataSync('WALK_DATA_SYNC');

  const NotificationType(this.value);

  final String value;

  /// 보호자가 건강 일정을 등록·변경·삭제했을 때 오는 푸시.
  static const healthScheduleChanges = {
    healthScheduleCreated,
    healthScheduleUpdated,
    healthScheduleDeleted,
  };

  /// 내 게시물 업로드가 끝났거나 다른 가족이 게시물을 올렸을 때 오는 푸시.
  static const newAlbumPosts = {albumUploadComplete, albumCreated};

  bool matches(Map<String, dynamic> data) => data['notificationType'] == value;

  /// [types] 중 하나와 일치하는지.
  static bool anyMatches(
          Iterable<NotificationType> types, Map<String, dynamic> data) =>
      types.any((type) => type.matches(data));
}
