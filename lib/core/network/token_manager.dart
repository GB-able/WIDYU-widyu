import 'package:widyu/core/storage/secure_storage.dart';
import 'package:widyu/core/storage/storage_key.dart';

enum TokenType { none, access, temporary }

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();

  factory TokenManager() => _instance;

  final SecureStorage _secureStorage = SecureStorage();

  TokenManager._internal();

  Future<String?> get memberId async =>
      _secureStorage.storage.read(key: StorageKey.memberId.name);

  Future<String?> get accessToken async =>
      _secureStorage.storage.read(key: StorageKey.accessToken.name);

  Future<String?> get refreshToken async =>
      _secureStorage.storage.read(key: StorageKey.refreshToken.name);

  Future<String?> get tempToken async =>
      _secureStorage.storage.read(key: StorageKey.tempToken.name);

  Future<bool> hasToken() async {
    final accessToken =
        await _secureStorage.storage.read(key: StorageKey.accessToken.name);
    final refreshToken =
        await _secureStorage.storage.read(key: StorageKey.refreshToken.name);
    return accessToken != null && refreshToken != null;
  }

  Future<void> setTempToken(String token) async {
    await _secureStorage.storage
        .write(key: StorageKey.tempToken.name, value: token);
  }

  Future<void> setToken(
    int memberId,
    String accessToken,
    String refreshToken,
  ) async {
    await Future.wait([
      _secureStorage.storage
          .write(key: StorageKey.memberId.name, value: memberId.toString()),
      _secureStorage.storage
          .write(key: StorageKey.accessToken.name, value: accessToken),
      _secureStorage.storage
          .write(key: StorageKey.refreshToken.name, value: refreshToken),
    ]);
  }

  Future<void> removeToken() async {
    await Future.wait([
      _secureStorage.storage.delete(key: StorageKey.accessToken.name),
      _secureStorage.storage.delete(key: StorageKey.refreshToken.name),
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
