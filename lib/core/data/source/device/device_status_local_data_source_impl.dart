import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:widyu/core/data/source/device/device_status_local_data_source.dart';
import 'package:widyu/core/log/log.dart';

class DeviceStatusLocalDataSourceImpl implements DeviceStatusLocalDataSource {
  static const _channel = MethodChannel('com.widucorp.widu/device_status');

  @override
  Future<Map<String, dynamic>> phoneStatus() async {
    try {
      final status =
          await _channel.invokeMapMethod<String, dynamic>('phoneStatus');
      return {...?status}..removeWhere((_, value) => value == null);
    } on PlatformException catch (error) {
      WiduLog.data.w('폰 상태 조회 실패 code=${error.code}');
    } on MissingPluginException {
      WiduLog.data.w('폰 상태 채널 없음');
    }
    return {};
  }

  @override
  Future<String> appVersion() async =>
      (await PackageInfo.fromPlatform()).version;

  @override
  Future<String> locationPermission() async =>
      switch (await Geolocator.checkPermission()) {
        LocationPermission.always => 'always',
        LocationPermission.whileInUse => 'while_in_use',
        LocationPermission.denied => 'denied',
        LocationPermission.deniedForever => 'denied_forever',
        LocationPermission.unableToDetermine => 'unknown',
      };

  @override
  Future<bool> watchConnected() async {
    try {
      return await _channel.invokeMethod<bool>('watchConnected') ?? false;
    } on PlatformException catch (error) {
      WiduLog.data.w('워치 연결 조회 실패 code=${error.code}');
    } on MissingPluginException {
      WiduLog.data.w('폰 상태 채널 없음');
    }
    return false;
  }
}
