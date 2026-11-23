extension MapExtension on Map<String, dynamic> {
  /// 값이 null인 항목을 제거한 맵 (쿼리 파라미터 / 요청 바디용)
  Map<String, dynamic> get compact =>
      Map.fromEntries(entries.where((e) => e.value != null));
}
