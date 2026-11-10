import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/notification/local_notification_manager.dart';
import 'package:widyu/core/notification/medication_push_manager.dart';
import 'package:widyu/core/ui/widgets/medication_reward_dialog.dart';
import 'package:widyu/core/ui/widgets/permission_recovery_dialog.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/feature/goal/medication/medication_ringing_screen.dart';

class MedicationSessionScope extends ConsumerStatefulWidget {
  const MedicationSessionScope({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<MedicationSessionScope> createState() =>
      _MedicationSessionScopeState();
}

class _MedicationSessionScopeState
    extends ConsumerState<MedicationSessionScope>
    with WidgetsBindingObserver {
  late final MedicationRepository repository =
      ref.read(medicationRepositoryProvider);
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
      await refreshAlarmMember();
      unawaited(drainLaunch());
      startAlarmTimer();
      unawaited(refreshActiveAlarm());
      unawaited(guideAlarmPermissions(repository.syncAlarmSchedule()));
      if (Firebase.apps.isNotEmpty) {
        subscriptions.add(FirebaseMessaging.onMessage.listen(onMessage));
        subscriptions
            .add(FirebaseMessaging.onMessageOpenedApp.listen(onMessage));
        subscriptions.add(FirebaseMessaging.instance.onTokenRefresh
            .listen((_) => repository.syncAlarmSchedule()));
        final initial = await LocalNotificationManager.initialRemoteMessage();
        if (initial != null) onMessage(initial);
      }
    } catch (_) {/* Status card retains retry access. */}
  }

  Future<bool> isAlarmBusy() async {
    final launch = await repository.pendingAlarmLaunch();
    final ringing = await repository.activeAlarmGroup();
    return !mounted || launch.isNotEmpty || ringing['groupId'] is String;
  }

  Future<void> guideAlarmPermissions(Future<void> synced) async {
    try {
      if (await isAlarmBusy()) return;
      final controller = ref.read(alarmPermissionRecoveryControllerProvider);
      final caps = await repository.alarmCapabilities();
      final types = [
        if (caps['mode'] != 'alarmKit') PermissionType.notification,
        PermissionType.alarm,
      ];
      var prompted = false;
      for (final type in types) {
        final result = await controller.ensurePermission(
          type,
          showPrompt: (type, mode) {
            prompted = true;
            return showAlarmPermissionPrompt(type, mode);
          },
        );
        if (result != PermissionRequestResult.granted &&
            result != PermissionRequestResult.unsupported) {
          return;
        }
      }
      if (prompted) unawaited(repository.syncAlarmSchedule());
      await synced;
      await guideFullScreenAlarm();
    } catch (_) {}
  }

  Future<PermissionRecoveryAction> showAlarmPermissionPrompt(
    PermissionType type,
    PermissionRecoveryMode mode,
  ) async {
    if (!mounted) return PermissionRecoveryAction.cancel;
    final isNotification = type == PermissionType.notification;
    return PermissionRecoveryDialog.show(
      context,
      permissionName: isNotification
          ? '알림'
          : Platform.isIOS
              ? '알람'
              : '알람 및 리마인더',
      description: isNotification
          ? Platform.isIOS
              ? '약 복용 시간에 알람이 울리려면 알림을 허용해야 해요.'
              : '약 복용 시간에 알람이 울리려면 알림을 허용해야 해요. 알림 설정에서 약 복용 알람 항목도 켜 주세요.'
          : '약 복용 시간에 알람이 울리려면 이 권한을 허용해야 해요.',
      mode: mode,
    );
  }

  Future<void> guideFullScreenAlarm() async {
    if (!Platform.isAndroid || await isAlarmBusy()) return;
    final caps = await repository.alarmCapabilities();
    if (caps['fullScreen'] != false) return;
    final schedule = (await repository.alarmState())['schedule'];
    if (schedule is! Map || (schedule['schedules'] as List?)?.isNotEmpty != true) {
      return;
    }
    if (!mounted) return;
    final action = await PermissionRecoveryDialog.show(
      context,
      permissionName: '전체 화면 알림',
      description: '잠긴 화면에서도 약 복용 알람 화면을 띄우려면 전체 화면 알림을 허용해야 해요.',
      mode: PermissionRecoveryMode.settings,
    );
    if (action == PermissionRecoveryAction.openSettings) {
      await repository.requestAlarmPermission();
    }
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
    if (!mounted ||
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
      final valid =
          group['groupId'] is String && group['memberId'] == alarmMember;
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
