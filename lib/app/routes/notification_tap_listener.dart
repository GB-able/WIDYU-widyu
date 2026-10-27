import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/core/notification/local_notification_manager.dart';

class NotificationTapListener extends StatefulWidget {
  const NotificationTapListener({super.key, required this.child});

  final Widget child;

  @override
  State<NotificationTapListener> createState() =>
      _NotificationTapListenerState();
}

class _NotificationTapListenerState extends State<NotificationTapListener> {
  StreamSubscription<String?>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = LocalNotificationManager.onNotificationTapped.listen(_open);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _open(LocalNotificationManager.consumeInitialPayload()),
    );
  }

  void _open(String? path) {
    if (!mounted || path == null || path.isEmpty) return;
    final uri = Uri.tryParse(path);
    final router = GoRouter.of(context);
    if (uri == null || router.configuration.findMatch(uri).isEmpty) return;
    router.push(path);
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
