import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// FCM 메시지를 수신했을 때 로컬 푸시를 띄우기 위한 범용 래퍼.
/// 알림 표시/취소, 권한 요청, 알림 탭 처리(콜드 스타트 포함)를 담당한다.
class LocalNotificationManager {
  LocalNotificationManager._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'widyu_default_channel';
  static const _channelName = '위듀 알림';
  static const _importance = Importance.max;
  static const _priority = Priority.high;
  static const _defaultNotificationId = 9999;

  /// 알림 탭 payload 를 전달하는 broadcast 스트림.
  static final _notificationTapped = StreamController<String?>.broadcast();

  static Stream<String?> get onNotificationTapped => _notificationTapped.stream;

  /// 앱이 종료된 상태에서 알림 탭으로 실행됐는지 여부와 그때의 payload.
  /// payload 가 null 이어도 "알림으로 실행됨" 자체는 남겨야 하므로 플래그를 따로 둔다.
  static bool _hasInitialLaunch = false;
  static String? _initialPayload;

  static Future<void> initialize() async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // 권한은 requestPermission() 에서 명시적으로 요청한다.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            importance: _importance,
          ),
        );

    // 앱이 종료된 상태에서 알림 탭으로 실행된 경우에는 콜백이 오지 않으므로 여기서 확인한다.
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _hasInitialLaunch = true;
      _initialPayload = launchDetails?.notificationResponse?.payload;
      debugPrint('[LocalNotificationManager] 알림으로 앱 실행: $_initialPayload');
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('[LocalNotificationManager] 알림 탭: ${response.payload}');
    _notificationTapped.add(response.payload);
  }

  /// 콜드 스타트로 실행된 경우의 payload 를 1회 반환하고 내부 상태를 비운다.
  static String? consumeInitialPayload() {
    if (!_hasInitialLaunch) return null;
    final payload = _initialPayload;
    _hasInitialLaunch = false;
    _initialPayload = null;
    return payload;
  }

  /// 알림 권한 보유 여부. Android 13+ 는 이 권한이 없으면 포그라운드 서비스 알림까지
  /// 상태바에서 가려지므로, 온보딩에서 위치 권한과 함께 상태를 확인한다.
  static Future<bool> hasPermission() async {
    if (Platform.isAndroid) {
      final enabled = await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      return enabled ?? false;
    }

    return true;
  }

  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return granted ?? false;
    }

    if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }

    return false;
  }

  /// 로컬 푸시를 즉시 표시한다. FCM 메시지 수신 시의 진입점.
  static Future<void> show({
    required String title,
    required String body,
    int id = _defaultNotificationId,
    String? payload,
  }) async {
    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: _importance,
            priority: _priority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: payload,
      );
    } catch (e) {
      debugPrint('[LocalNotificationManager] 알림 표시 실패: $e');
    }
  }

  static Future<void> cancel(int id) async {
    await _plugin.cancel(id: id);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
