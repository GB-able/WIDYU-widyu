import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/notification/safety_push_manager.dart';

class SafetyCheckListener extends StatefulWidget {
  const SafetyCheckListener({super.key, required this.child});

  final Widget child;

  @override
  State<SafetyCheckListener> createState() => _SafetyCheckListenerState();
}

class _SafetyCheckListenerState extends State<SafetyCheckListener> {
  static const _type = 'EMERGENCY_CONFIRM_REQUEST';

  final _subscriptions = <StreamSubscription<dynamic>>[];
  String? _lastIncidentId;

  @override
  void initState() {
    super.initState();
    _subscriptions
        .add(SafetyPushManager.onIncidentArrived.listen((_) => _openPending()));
    WidgetsBinding.instance.addPostFrameCallback((_) => _openPending());
    if (Firebase.apps.isEmpty) return;
    _subscriptions
      ..add(FirebaseMessaging.onMessage.listen(_onMessage))
      ..add(FirebaseMessaging.onMessageOpenedApp.listen(_onMessage));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final initial = await FirebaseMessaging.instance.getInitialMessage();
        if (initial != null) _onMessage(initial);
      } catch (e, stack) {
        debugPrint('[SafetyCheck] 초기 메시지 조회 실패: $e\n$stack');
      }
    });
  }

  Future<void> _openPending() async {
    final incidentId = await SafetyPushManager.consumePendingIncident();
    if (incidentId != null) _open(incidentId);
  }

  void _onMessage(RemoteMessage message) {
    if (message.data['type'] != _type) return;
    final incidentId = message.data['entityId'];
    if (incidentId is String) _open(incidentId);
  }

  void _open(String incidentId) {
    if (incidentId == _lastIncidentId || !mounted) return;
    _lastIncidentId = incidentId;
    final router = GoRouter.of(context);
    final isShowing = router.state.matchedLocation == AppRoute.safetyCheck.path;
    if (isShowing) {
      router.pushReplacement(AppRoute.safetyCheck.path, extra: incidentId);
    } else {
      router.push(AppRoute.safetyCheck.path, extra: incidentId);
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
