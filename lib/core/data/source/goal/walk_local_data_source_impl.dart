import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walk/walk.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';

class WalkLocalDataSourceImpl implements WalkLocalDataSource {
  static const _types = [HealthDataType.STEPS];
  static const _access = [HealthDataAccess.READ];

  late final Health _health = Health();
  final WalkRecording _walkRecording = WalkRecording();
  Future<void>? _configuration;
  StepPermissionStatus _permissionStatus = StepPermissionStatus.unknown;
  bool _backgroundReadGranted = false;

  @override
  String get stepSource => defaultTargetPlatform == TargetPlatform.android
      ? 'recordingApi'
      : 'healthAutomatic';

  @override
  StepPermissionStatus get permissionStatus => _permissionStatus;
  @override
  bool get backgroundReadGranted => _backgroundReadGranted;

  @override
  Future<bool> ensurePermission() async {
    try {
      if (!await _ensureReady()) return false;
      if (defaultTargetPlatform == TargetPlatform.android) {
        if (!(await Permission.activityRecognition.request()).isGranted) {
          _permissionStatus = StepPermissionStatus.denied;
          _backgroundReadGranted = false;
          return false;
        }
        await _walkRecording.startRecording();
        _permissionStatus = StepPermissionStatus.granted;
        _backgroundReadGranted = true;
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
        if (!completed) {
          _permissionStatus = StepPermissionStatus.unknown;
          return false;
        }
      }
      _permissionStatus = StepPermissionStatus.unknown;
      return true;
    } on PlatformException catch (error) {
      _recordPlatformError(error);
      return false;
    } catch (_) {
      _permissionStatus = StepPermissionStatus.error;
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
      _backgroundReadGranted = true;
      return true;
    } on PlatformException catch (error) {
      _recordPlatformError(error);
      return false;
    } catch (_) {
      _backgroundReadGranted = false;
      _permissionStatus = StepPermissionStatus.error;
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
      final total = await _health.getTotalStepsInInterval(
        start,
        end,
        includeManualEntry: false,
      );
      if (total == null || total < 0) return null;
      if (total > 0) return total;
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
    } on PlatformException catch (error) {
      _recordPlatformError(error);
      return null;
    } catch (_) {
      _permissionStatus = StepPermissionStatus.error;
      return null;
    }
  }

  Future<bool> _ensureReady() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      _permissionStatus = StepPermissionStatus.unavailable;
      _backgroundReadGranted = false;
      return false;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (await _walkRecording.isAvailable()) return true;
      _permissionStatus = StepPermissionStatus.unavailable;
      _backgroundReadGranted = false;
      return false;
    }
    try {
      await (_configuration ??= _health.configure());
    } catch (_) {
      _configuration = null;
      rethrow;
    }
    _permissionStatus = StepPermissionStatus.unknown;
    return true;
  }

  Future<bool> _hasAndroidReadPermission() async {
    final allowed = (await Permission.activityRecognition.status).isGranted;
    _permissionStatus =
        allowed ? StepPermissionStatus.granted : StepPermissionStatus.denied;
    if (!allowed) _backgroundReadGranted = false;
    return allowed;
  }

  void _recordPlatformError(PlatformException error) {
    _backgroundReadGranted = false;
    _permissionStatus = switch (error.code) {
      'PERMISSION_DENIED' => StepPermissionStatus.denied,
      'UNAVAILABLE' => StepPermissionStatus.unavailable,
      _ => StepPermissionStatus.error,
    };
  }
}
