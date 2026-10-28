import 'package:shared_preferences/shared_preferences.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/storage/preference_key.dart';

/// 보안이 필요 없는 로컬 설정 값을 다루는 래퍼.
///
/// iOS 키체인은 앱을 삭제해도 값이 남기 때문에, 재설치 시 초기화되어야 하는 값은
/// SecureStorage 가 아니라 이곳(SharedPreferences)에 저장한다.
///
/// 읽기/쓰기 실패가 앱 플로우를 막지 않도록 예외는 내부에서 삼키고,
/// 읽기는 기본값을, 쓰기는 무시한다.
class AppPreference {
  static final AppPreference _instance = AppPreference._internal();
  factory AppPreference() => _instance;

  AppPreference._internal();

  SharedPreferences? _prefs;

  Future<SharedPreferences?> _getPrefs() async {
    if (_prefs != null) return _prefs;
    try {
      _prefs = await SharedPreferences.getInstance();
      return _prefs;
    } catch (e, stack) {
      WiduLog.data.w('AppPreference 초기화 실패', error: e, stackTrace: stack);
      return null;
    }
  }

  Future<bool> getBool(PreferenceKey key, {bool defaultValue = false}) async {
    try {
      final prefs = await _getPrefs();
      return prefs?.getBool(key.name) ?? defaultValue;
    } catch (e, stack) {
      WiduLog.data.w('AppPreference ${key.name} 읽기 실패',
          error: e, stackTrace: stack);
      return defaultValue;
    }
  }

  Future<void> setBool(PreferenceKey key, bool value) async {
    try {
      final prefs = await _getPrefs();
      await prefs?.setBool(key.name, value);
    } catch (e, stack) {
      WiduLog.data.w('AppPreference ${key.name} 저장 실패',
          error: e, stackTrace: stack);
    }
  }

  Future<String?> getString(PreferenceKey key) async {
    try {
      final prefs = await _getPrefs();
      return prefs?.getString(key.name);
    } catch (e, stack) {
      WiduLog.data.w('AppPreference ${key.name} 읽기 실패',
          error: e, stackTrace: stack);
      return null;
    }
  }

  Future<void> setString(PreferenceKey key, String value) async {
    try {
      final prefs = await _getPrefs();
      await prefs?.setString(key.name, value);
    } catch (e, stack) {
      WiduLog.data.w('AppPreference ${key.name} 저장 실패',
          error: e, stackTrace: stack);
    }
  }
}
