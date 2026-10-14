import 'package:widyu/core/data/source/device/device_local_data_source.dart';
import 'package:widyu/core/storage/app_preference.dart';
import 'package:widyu/core/storage/preference_key.dart';
import 'package:widyu/core/utils/random_uuid.dart';

/// 기기 식별자는 앱을 재설치하면 초기화되어야 하므로, 삭제 후에도 값이 남는
/// SecureStorage 가 아니라 [AppPreference](SharedPreferences)에 저장한다.
class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  final AppPreference _preference = AppPreference();

  @override
  Future<String> getDeviceId() async {
    final saved = await _preference.getString(PreferenceKey.deviceId);
    if (saved != null && saved.isNotEmpty) return saved;
    final created = 'ph-${randomUuid()}';
    await _preference.setString(PreferenceKey.deviceId, created);
    return created;
  }
}
