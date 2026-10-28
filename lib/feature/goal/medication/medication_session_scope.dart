import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/notification/medication_push_manager.dart';
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
  late final MedicationRepository repository =
      context.read<MedicationRepository>();
  Object? alarmMember;
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
    subscriptions.add(repository.alarmChanges.listen((_) async {
      try {
        await refreshAlarmMember();
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
      await repository.activateAlarm(member);
      ready = true;
      await requestAlarmPermissionIfNeeded();
      await refreshAlarmMember();
      unawaited(drainLaunch());
      startAlarmTimer();
      unawaited(refreshActiveAlarm());
      unawaited(repository.syncAlarmSchedule());
      if (Firebase.apps.isNotEmpty) {
        subscriptions.add(FirebaseMessaging.onMessage.listen(onMessage));
        subscriptions
            .add(FirebaseMessaging.onMessageOpenedApp.listen(onMessage));
        subscriptions.add(FirebaseMessaging.instance.onTokenRefresh
            .listen((_) => repository.syncAlarmSchedule()));
        final initial = await FirebaseMessaging.instance.getInitialMessage();
        if (initial != null) onMessage(initial);
      }
    } catch (_) {/* Status card retains retry access. */}
  }

  Future<void> requestAlarmPermissionIfNeeded() async {
    if (!Platform.isIOS) return;
    try {
      final caps = await repository.alarmCapabilities();
      if (caps['mode'] != 'alarmKit' || caps['authorized'] == true) return;
      await repository.requestAlarmPermission();
    } catch (_) {}
  }

  Future<void> refreshAlarmMember() async {
    alarmMember = (await repository.alarmState())['memberId'];
  }

  void onMessage(RemoteMessage message) {
    if (!isMedicationChange(message)) return;
    WiduLog.data.i('약 복용 일정 변경 푸시 수신');
    WiduLog.data.t(() => '약 복용 푸시 data: ${message.data}');
    unawaited(repository.syncAlarmSchedule());
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
      final group = await repository.activeAlarmGroup();
      if (!mounted ||
          alarmActionBusy ||
          WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
        return;
      }
      final valid = group['groupId'] is String &&
          group['memberId'] == alarmMember;
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
      await repository.stopAlarm(group['groupId'] as String);
      if (!mounted) return;
      setState(() {
        activeGroup = null;
        alarmActionBusy = false;
      });
      if (verify) {
        final result = await context.push<MedicationPointResult>(
            AppRoute.medicationCamera.path,
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
      unawaited(repository.syncAlarmSchedule());
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
      final launch = await repository.pendingAlarmLaunch();
      if (!mounted || launch.isEmpty) return;
      if (launch['memberId'] != await authenticatedMedicationMember()) return;
      final eventId = launch['eventId'] as String;
      final group = Map<String, dynamic>.from(launch['group'] as Map);
      unawaited(repository.stopAlarm(group['groupId'] as String));
      if (!mounted) return;
      final result = await context.push<MedicationPointResult>(
          AppRoute.medicationCamera.path,
          extra: launch['group']);
      await repository.acknowledgeAlarmLaunch(eventId);
      if (result != null && mounted) showReward(result);
    } finally {
      routing = false;
    }
  }

  void showReward(MedicationPointResult result) => showDialog<void>(
        context: context,
        builder: (_) => MedicationRewardDialog(
          earnedPoint: result.earnedPoints,
          currentPoint: result.currentPoints,
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
