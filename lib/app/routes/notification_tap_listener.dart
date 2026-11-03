import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/notification/local_notification_manager.dart';

class NotificationTapListener extends ConsumerStatefulWidget {
  const NotificationTapListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NotificationTapListener> createState() =>
      _NotificationTapListenerState();
}

class _NotificationTapListenerState
    extends ConsumerState<NotificationTapListener> {
  final _subscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _subscriptions
        .add(LocalNotificationManager.onNotificationTapped.listen(_openLocal));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _openLocal(LocalNotificationManager.consumeInitialPayload()),
    );
    if (Firebase.apps.isEmpty) return;
    _subscriptions
        .add(FirebaseMessaging.onMessageOpenedApp.listen(_openRemote));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => _openRemote(
        await LocalNotificationManager.initialRemoteMessage(),
      ),
    );
  }

  void _openLocal(String? payload) {
    if (payload == null || payload.isEmpty) return;
    Object? decoded;
    try {
      decoded = jsonDecode(payload);
    } catch (_) {}
    _open(decoded is Map<String, dynamic> ? decoded : {'deepLink': payload});
  }

  void _openRemote(RemoteMessage? message) {
    if (message != null) _open(message.data);
  }

  void _open(Map<String, dynamic> data) {
    if (!mounted) return;
    final notificationId = int.tryParse('${data['notificationId'] ?? ''}');
    if (notificationId != null) {
      unawaited(
        ref
            .read(notificationRepositoryProvider)
            .readNotification(notificationId),
      );
    }
    final path = data['deepLink'];
    if (path is String) GoRouter.of(context).openDeepLink(path);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
