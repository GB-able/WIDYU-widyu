import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
  );

  SecureStorage._internal();

  FlutterSecureStorage get storage => _storage;
}
