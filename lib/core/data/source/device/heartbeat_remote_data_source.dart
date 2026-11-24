abstract class HeartbeatRemoteDataSource {
  /// `POST /device/heartbeats`. 서버가 STORED·DUPLICATE 로 받으면 true.
  Future<bool> send(Map<String, dynamic> heartbeat);
}
