import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/route/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/notification/local_notification_manager.dart';
import 'package:widyu/feature/album/post/post_view_model.dart';

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
    if (path is! String) return;
    final router = GoRouter.of(context);
    if (_refreshOpenPost(router, path)) return;
    router.openDeepLink(path);
  }

  /// 보고 있는 게시물의 알림이면 같은 화면을 또 쌓지 않고 다시 조회한다.
  /// 게시물 ViewModel은 id별로 공유돼, 새로 쌓은 화면은 다시 조회하지 않기 때문이다.
  bool _refreshOpenPost(GoRouter router, String path) {
    final target = Uri.tryParse(path);
    // push한 화면의 경로는 currentConfiguration.uri가 아니라 state.uri에 있다.
    final current = router.state.uri;
    final postId = target?.queryParameters['postId'];
    if (target?.path != AppRoute.post.path ||
        current.path != AppRoute.post.path ||
        postId == null ||
        postId != current.queryParameters['postId']) {
      return false;
    }
    final id = int.tryParse(postId);
    if (id == null) return false;
    final commentId = int.tryParse(target?.queryParameters['commentId'] ?? '');
    unawaited(
      ref.read(postViewModelProvider(id).notifier).reopen(commentId: commentId),
    );
    return true;
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
