import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/network/token_manager.dart';

class FcmTokenService {
  FcmTokenService({required NotificationRepository repository})
      : _repository = repository;

  final NotificationRepository _repository;
  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _disposed = false;

  void start() {
    if (Firebase.apps.isEmpty) {
      WiduLog.data.w('Firebase 미초기화로 FCM 토큰 등록 생략');
      return;
    }
    unawaited(_fetchToken().then((token) {
      if (token != null) return registerToken(token);
    }));
    _tokenRefreshSubscription ??=
        FirebaseMessaging.instance.onTokenRefresh.listen(registerToken);
  }

  Future<String?> _fetchToken() async {
    try {
      if (_disposed || !await TokenManager().hasToken()) return null;

      await FirebaseMessaging.instance.requestPermission();

      if (Platform.isIOS && await _waitForApnsToken() == null) {
        WiduLog.data.i('APNs 토큰 미발급으로 FCM 토큰 등록 연기');
        return null;
      }
      return await FirebaseMessaging.instance.getToken();
    } catch (error, stack) {
      WiduLog.data.w('FCM 토큰 발급 실패', error: error, stackTrace: stack);
      return null;
    }
  }

  Future<void> registerToken(String token) async {
    try {
      if (_disposed || token.isEmpty || !await TokenManager().hasToken()) {
        return;
      }

      final result = await _repository.registerFcmToken(token);
      switch (result) {
        case Success():
          WiduLog.data.i('FCM 토큰 등록 성공');
        case Failure():
          WiduLog.data.w('FCM 토큰 등록 실패');
      }
    } catch (error, stack) {
      WiduLog.data.w('FCM 토큰 등록 중 예외', error: error, stackTrace: stack);
    }
  }

  Future<void> deactivateToken() async {
    try {
      if (Firebase.apps.isEmpty) return;
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;

      final result = await _repository.deactivateFcmToken(token);
      switch (result) {
        case Success():
          WiduLog.data.i('FCM 토큰 비활성화 성공');
        case Failure():
          WiduLog.data.w('FCM 토큰 비활성화 실패');
      }
    } catch (error, stack) {
      WiduLog.data.w('FCM 토큰 비활성화 중 예외', error: error, stackTrace: stack);
    }
  }

  Future<String?> _waitForApnsToken() async {
    for (var attempt = 0; attempt < 10; attempt++) {
      final token = await FirebaseMessaging.instance.getAPNSToken();
      if (token != null) return token;
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    return null;
  }

  Future<void> dispose() async {
    _disposed = true;
    await _tokenRefreshSubscription?.cancel();
  }
}
