import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';

class WalkLocalDataSourceImpl implements WalkLocalDataSource {
  static const _stepDetectionChannel = EventChannel('step_detection');

  @override
  Future<bool> ensurePermission() async {
    if (Platform.isIOS) return true; // [NOTICE] iOS 권한 불필요

    if (await Permission.activityRecognition.isGranted) return true;
    return (await Permission.activityRecognition.request()).isGranted;
  }

  // [NOTICE] Android 는 걸음 하나마다 이벤트가 오지만, iOS 는 걸음 단위 이벤트가 없어서 증가분으로 계산
  @override
  Stream<int> observeStepDelta() => Platform.isAndroid
      ? _stepDetectionChannel.receiveBroadcastStream().map((_) => 1)
      : _stepCountDeltas();

  Stream<int> _stepCountDeltas() async* {
    int? previous;

    await for (final event in Pedometer.stepCountStream) {
      final total = event.steps;
      final last = previous;
      previous = total;

      if (last == null || total <= last) continue;
      yield total - last;
    }
  }
}
