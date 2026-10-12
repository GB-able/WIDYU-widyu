import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/notification/medication_push_manager.dart';
import 'package:widyu/core/data/provider/medication_alarm_provider.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/ui/widgets/medication_reward_dialog.dart';
import 'package:widyu/feature/goal/medication/medication_ringing_screen.dart';

class MedicationSessionScope extends StatefulWidget {
  const MedicationSessionScope({super.key, required this.child});
  final Widget child;
  @override
  State<MedicationSessionScope> createState() => _MedicationSessionScopeState();
}

class _MedicationSessionScopeState extends State<MedicationSessionScope>
    with WidgetsBindingObserver {
  late final MedicationAlarmProvider service =
      context.read<MedicationAlarmProvider>();
  final subscriptions = <StreamSubscription<dynamic>>[];
  Timer? alarmTimer;
  Map<String, dynamic>? activeGroup;
  bool readingAlarm = false;
  bool alarmActionBusy = false;
  bool routing = false;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    subscriptions.add(service.changes.listen((_) async {
      try {
        await service.refreshState();
        unawaited(drainLaunch());
        unawaited(refreshActiveAlarm());
      } catch (_) {}
    }, onError: (Object _) {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => start());
  }

  Future<void> start() async {
    try {
      // Drain persisted intents before a server refresh can replace old groups.
      final member = await authenticatedMedicationMember();
      if (member == null || !mounted) return;
      await service.activate(member);
      ready = true;
      await service.refreshState();
      unawaited(drainLaunch());
      startAlarmTimer();
      unawaited(refreshActiveAlarm());
      unawaited(service.sync());
      if (Firebase.apps.isNotEmpty) {
        subscriptions.add(FirebaseMessaging.onMessage.listen(onMessage));
        subscriptions
            .add(FirebaseMessaging.onMessageOpenedApp.listen(onMessage));
        subscriptions.add(FirebaseMessaging.instance.onTokenRefresh
            .listen((_) => service.sync()));
        final initial = await FirebaseMessaging.instance.getInitialMessage();
        if (initial != null) onMessage(initial);
      }
    } catch (_) {/* Status card retains retry access. */}
  }

  void onMessage(RemoteMessage message) {
    if (!isMedicationChange(message)) return;
    debugPrint('[MedicationSync] 포그라운드 푸시 수신: ${message.data}');
    unawaited(service.sync());
  }

  void startAlarmTimer() {
    alarmTimer?.cancel();
    alarmTimer = Timer.periodic(
        const Duration(seconds: 1), (_) => unawaited(refreshActiveAlarm()));
  }

  Future<void> refreshActiveAlarm() async {
    if (Platform.isAndroid ||
        !mounted ||
        !ready ||
        readingAlarm ||
        alarmActionBusy ||
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }
    readingAlarm = true;
    try {
      final group = await service.activeGroup();
      if (!mounted ||
          alarmActionBusy ||
          WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
        return;
      }
      final valid = group['groupId'] is String &&
          group['memberId'] == service.state['memberId'];
      final next = valid ? group : null;
      if (next?['groupId'] != activeGroup?['groupId']) {
        setState(() => activeGroup = next);
      }
    } catch (_) {
      // A missed event is retried by the timer while the app is visible.
    } finally {
      readingAlarm = false;
    }
  }

  Future<void> stopActiveAlarm({required bool verify}) async {
    final group = activeGroup;
    if (group == null || alarmActionBusy) return;
    setState(() => alarmActionBusy = true);
    try {
      await service.stop(group['groupId'] as String);
      if (!mounted) return;
      setState(() {
        activeGroup = null;
        alarmActionBusy = false;
      });
      if (verify) {
        final result = await context.push<MedicationPointResult>(
            AppRoute.medicationVerify.path,
            extra: group);
        if (result != null && mounted) showReward(result);
      }
    } catch (_) {
      // Keep the alarm screen available so the user can retry.
    } finally {
      alarmActionBusy = false;
      unawaited(refreshActiveAlarm());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startAlarmTimer();
      unawaited(service.sync());
      unawaited(drainLaunch());
      unawaited(refreshActiveAlarm());
    } else {
      alarmTimer?.cancel();
      if (activeGroup != null) setState(() => activeGroup = null);
    }
  }

  Future<void> drainLaunch() async {
    if (!mounted ||
        !ready ||
        routing ||
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }
    routing = true;
    try {
      final launch = await service.pendingLaunch();
      if (!mounted || launch.isEmpty) return;
      if (launch['memberId'] != await authenticatedMedicationMember()) return;
      final eventId = launch['eventId'] as String;
      final group = Map<String, dynamic>.from(launch['group'] as Map);
      unawaited(service.stop(group['groupId'] as String));
      if (!mounted) return;
      final result = await context.push<MedicationPointResult>(
          AppRoute.medicationVerify.path,
          extra: launch['group']);
      await service.acknowledgeLaunch(eventId);
      if (result != null && mounted) showReward(result);
    } finally {
      routing = false;
    }
  }

  void showReward(MedicationPointResult result) => showDialog<void>(
        context: context,
        builder: (_) => MedicationRewardDialog(
          earnedPoint: result.earnedPoints,
          existingPoint: result.currentPoints,
        ),
      );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    alarmTimer?.cancel();
    for (final subscription in subscriptions) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(fit: StackFit.expand, children: [
          widget.child,
          if (activeGroup != null)
            MedicationRingingScreen(
              group: activeGroup!,
              busy: alarmActionBusy,
              onVerify: () => stopActiveAlarm(verify: true),
              onStop: () => stopActiveAlarm(verify: false),
            ),
        ]),
      );
}
