import 'package:firebase_messaging/firebase_messaging.dart';

/// 화면 데이터를 다시 조회할 신호.
///
/// StreamProvider는 같은 값(`null`)을 연속으로 걸러내므로 스트림을 그대로 담아 제공한다.
class RefreshSignals {
  const RefreshSignals({required this.messages, required this.resumes});

  /// 앱이 켜져 있을 때 받은 FCM.
  final Stream<RemoteMessage> messages;

  /// 앱이 다시 화면에 나올 때마다. 백그라운드에서 놓친 변경을 다시 조회한다.
  final Stream<void> resumes;
}
