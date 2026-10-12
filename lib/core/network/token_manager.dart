import 'package:widyu/core/storage/secure_storage.dart';
import 'package:widyu/core/storage/storage_key.dart';
import 'package:medication_alarm/medication_alarm.dart';

enum TokenType { none, access, temporary }

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();

  factory TokenManager() => _instance;

  final SecureStorage _secureStorage = SecureStorage();

  TokenManager._internal();

  Future<String?> get memberId async =>
      _secureStorage.storage.read(key: StorageKey.memberId.name);

  Future<String?> get accessToken async =>
      _secureStorage.storage.read(key: StorageKey.widyuAccessToken.name);

  Future<String?> get refreshToken async =>
      _secureStorage.storage.read(key: StorageKey.widyuRefreshToken.name);

  Future<String?> get tempToken async =>
      _secureStorage.storage.read(key: StorageKey.tempToken.name);

  Future<bool> hasToken() async {
    final accessToken = await _secureStorage.storage
        .read(key: StorageKey.widyuAccessToken.name);
    final refreshToken = await _secureStorage.storage
        .read(key: StorageKey.widyuRefreshToken.name);
    return accessToken != null && refreshToken != null;
  }

  Future<void> setTempToken(String token) async {
    await _secureStorage.storage
        .write(key: StorageKey.tempToken.name, value: token);
  }

  Future<void> setMemberId(int memberId) async {
    await _secureStorage.storage
        .write(key: StorageKey.memberId.name, value: memberId.toString());
  }

  Future<void> setToken(String accessToken, String refreshToken) async {
    await Future.wait([
      _secureStorage.storage
          .write(key: StorageKey.widyuAccessToken.name, value: accessToken),
      _secureStorage.storage
          .write(key: StorageKey.widyuRefreshToken.name, value: refreshToken),
    ]);
  }

  Future<void> removeToken() async {
    // Invalidate native sessions before an in-flight background sync can finish.
    try { await MedicationAlarm().clearSession(); } catch (_) { }
    await Future.wait([
      _secureStorage.storage.delete(key: StorageKey.widyuAccessToken.name),
      _secureStorage.storage.delete(key: StorageKey.widyuRefreshToken.name),
    ]);
  }

  Future<void> removeTempToken() async {
    await _secureStorage.storage.delete(key: StorageKey.tempToken.name);
  }

  Future<void> removeAll() async {
    await Future.wait([
      removeToken(),
      removeTempToken(),
    ]);
  }
}
