import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
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
      debugPrint('[FCM] Firebase가 초기화되지 않아 토큰 등록을 건너뜁니다.');
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

      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (Platform.isIOS && await _waitForApnsToken() == null) {
        debugPrint('[FCM] APNs 토큰이 발급되지 않아 등록을 미룹니다.');
        return null;
      }
      return await FirebaseMessaging.instance.getToken();
    } catch (error) {
      debugPrint('[FCM] 등록 토큰 발급 실패: $error');
      return null;
    }
  }

  Future<void> registerToken(String token) async {
    try {
      if (_disposed || token.isEmpty || !await TokenManager().hasToken()) {
        return;
      }

      debugPrint('[FCM] 현재 토큰을 서버로 전송합니다.');
      final result = await _repository.registerFcmToken(token);
      switch (result) {
        case Success():
          debugPrint('[FCM] 토큰 등록 성공');
        case Failure(:final message):
          debugPrint('[FCM] 토큰 등록 실패: $message');
      }
    } catch (error) {
      debugPrint('[FCM] 토큰 등록 중 예외 발생: $error');
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
          debugPrint('[FCM] 토큰 비활성화 성공');
        case Failure(:final message):
          debugPrint('[FCM] 토큰 비활성화 실패: $message');
      }
    } catch (error) {
      debugPrint('[FCM] 토큰 비활성화 중 예외 발생: $error');
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
