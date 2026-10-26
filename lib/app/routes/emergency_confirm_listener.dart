import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';

class EmergencyConfirmListener extends StatefulWidget {
  const EmergencyConfirmListener({super.key, required this.child});

  final Widget child;

  @override
  State<EmergencyConfirmListener> createState() =>
      _EmergencyConfirmListenerState();
}

class _EmergencyConfirmListenerState extends State<EmergencyConfirmListener> {
  static const _type = 'EMERGENCY_CONFIRM_REQUEST';

  final _subscriptions = <StreamSubscription<RemoteMessage>>[];
  String? _lastIncidentId;

  @override
  void initState() {
    super.initState();
    if (Firebase.apps.isEmpty) return;
    _subscriptions
      ..add(FirebaseMessaging.onMessage.listen(_onMessage))
      ..add(FirebaseMessaging.onMessageOpenedApp.listen(_onMessage));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final initial = await FirebaseMessaging.instance.getInitialMessage();
        if (initial != null) _onMessage(initial);
      } catch (e, stack) {
        debugPrint('[EmergencyConfirm] 초기 메시지 조회 실패: $e\n$stack');
      }
    });
  }

  void _onMessage(RemoteMessage message) {
    if (message.data['type'] != _type) return;
    final incidentId = message.data['entityId'];
    if (incidentId is! String || incidentId == _lastIncidentId || !mounted) {
      return;
    }
    _lastIncidentId = incidentId;
    final router = GoRouter.of(context);
    final isShowing =
        router.state.matchedLocation == AppRoute.emergencyConfirm.path;
    if (isShowing) {
      router.pushReplacement(AppRoute.emergencyConfirm.path, extra: incidentId);
    } else {
      router.push(AppRoute.emergencyConfirm.path, extra: incidentId);
    }
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
