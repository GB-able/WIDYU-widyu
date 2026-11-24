import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/notification/notification_type.dart';
import 'package:widyu/core/notification/medication_push_manager.dart';
import 'package:widyu/walk_background_service.dart';

Future<bool> initializeBackgroundPush() async {
  try {
    if (Firebase.apps.isEmpty) return false;
    FirebaseMessaging.onBackgroundMessage(pushBackgroundMessage);
    return true;
  } catch (e, stack) {
    WiduLog.data.w('백그라운드 푸시 초기화 실패', error: e, stackTrace: stack);
    return false;
  }
}

@pragma('vm:entry-point')
Future<void> pushBackgroundMessage(RemoteMessage message) async {
  if (NotificationType.walkDataSync.matches(message.data)) {
    await syncWalkFromPush();
  } else if (MedicationPushManager.isMedicationChange(message)) {
    await MedicationPushManager.handleBackgroundMessage(message);
  }
}
