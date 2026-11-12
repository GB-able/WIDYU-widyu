import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walk/walk.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';
import 'package:widyu/core/storage/walk_database.dart';

class WalkLocalDataSourceImpl implements WalkLocalDataSource {
  static const _types = [HealthDataType.STEPS];
  static const _access = [HealthDataAccess.READ];
  static const _pedometerChannel =
      MethodChannel('com.widucorp.widu/step_counter');

  late final Health _health = Health();
  final WalkRecording _walkRecording = WalkRecording();
  final WalkDatabase _db = WalkDatabase.instance;
  Future<void>? _configuration;

  @override
  String get stepSource => defaultTargetPlatform == TargetPlatform.android
      ? 'recordingApi'
      : 'healthAutomatic';

  @override
  Future<bool> ensurePermission() async {
    try {
      if (!await _ensureReady()) return false;
      if (defaultTargetPlatform == TargetPlatform.android) {
        if (!(await Permission.activityRecognition.request()).isGranted) {
          return false;
        }
        await _walkRecording.startRecording();
        return true;
      }
      final allowed = await _health.hasPermissions(
        _types,
        permissions: _access,
      );
      if (allowed != true) {
        final completed = await _health.requestAuthorization(
          _types,
          permissions: _access,
        );
        if (!completed) return false;
      }
      final now = DateTime.now();
      await _readPedometerSteps(now.subtract(const Duration(minutes: 1)), now);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> canReadInBackground() async {
    try {
      if (!await _ensureReady()) return false;
      if (defaultTargetPlatform == TargetPlatform.iOS) return true;
      if (!await _hasAndroidReadPermission()) return false;
      await _walkRecording.startRecording();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<int?> readSteps(DateTime start, DateTime end) async {
    if (!start.isBefore(end)) return null;
    try {
      if (!await _ensureReady()) return null;
      if (defaultTargetPlatform == TargetPlatform.android) {
        if (!await _hasAndroidReadPermission()) return null;
        return await _walkRecording.readSteps(start, end);
      }
      final pedometer = await _readPedometerSteps(start, end);
      final total = await _health.getTotalStepsInInterval(
        start,
        end,
        includeManualEntry: false,
      );
      if (total == null || total < 0) return pedometer;
      if (total > 0) return math.max(total, pedometer ?? 0);
      if (pedometer != null) return pedometer;
      final points = await _health.getHealthDataFromTypes(
        types: _types,
        startTime: start,
        endTime: end,
        recordingMethodsToFilter: const [RecordingMethod.manual],
      );
      if (points.isEmpty) return null;
      final knownZero = points.every(
        (point) =>
            point.type == HealthDataType.STEPS &&
            point.value is NumericHealthValue &&
            (point.value as NumericHealthValue).numericValue == 0,
      );
      return knownZero ? 0 : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<int> get liveStepCounts {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return const Stream.empty();
    }
    return Pedometer.stepCountStream.map((event) => event.steps);
  }

  @override
  Future<Map<String, dynamic>> readState(String memberId) => _db.read(memberId);

  @override
  Future<void> saveState(String memberId, Map<String, dynamic> state) =>
      _db.save(memberId, state);

  @override
  Future<bool> hasDayInAnyState(String date) => _db.hasDay(date);

  @override
  Future<String?> acquireLock(String name) => _db.acquire(name);

  @override
  Future<bool> ownsLock(String name, String owner) => _db.owns(name, owner);

  @override
  Future<void> releaseLock(String name, String owner) =>
      _db.release(name, owner);

  Future<int?> _readPedometerSteps(DateTime start, DateTime end) async {
    try {
      final steps = await _pedometerChannel.invokeMethod<int>('querySteps', {
        'startMillis': start.millisecondsSinceEpoch,
        'endMillis': end.millisecondsSinceEpoch,
      });
      return steps == null || steps < 0 ? null : steps;
    } catch (_) {
      return null;
    }
  }

  Future<bool> _ensureReady() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return false;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _walkRecording.isAvailable();
    }
    try {
      await (_configuration ??= _health.configure());
    } catch (_) {
      _configuration = null;
      rethrow;
    }
    return true;
  }

  Future<bool> _hasAndroidReadPermission() async =>
      (await Permission.activityRecognition.status).isGranted;
}
