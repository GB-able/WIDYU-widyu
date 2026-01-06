import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/network/logger_interceptor.dart';
import 'package:widyu/core/network/token_interceptor.dart';
import 'package:widyu/core/storage/secure_storage.dart';
import 'package:widyu/core/storage/storage_key.dart';

enum HttpMethod { get, post, put, patch, delete }

enum TokenType { none, access, temporary }

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  static String baseUrl = dotenv.env['BASE_URL']!;
  final SecureStorage _secureStorage = SecureStorage();
  final Dio dio = Dio();

  ApiClient._internal() {
    dio.options = BaseOptions(
        baseUrl: baseUrl, validateStatus: (status) => status != null);
    dio.interceptors.add(TokenInterceptor());
    dio.interceptors.add(LoggerInterceptor());
  }

  Future<Response> req({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? query,
    Object? body,
    int version = 1,
    TokenType tokenType = TokenType.access,
  }) {
    path = '/v$version$path';
    final options = Options(extra: {'tokenType': tokenType});

    switch (method) {
      case HttpMethod.get:
        return dio.get(path, queryParameters: query, options: options);
      case HttpMethod.post:
        return dio.post(path,
            queryParameters: query, data: body, options: options);
      case HttpMethod.put:
        return dio.put(path,
            queryParameters: query, data: body, options: options);
      case HttpMethod.patch:
        return dio.patch(path,
            queryParameters: query, data: body, options: options);
      case HttpMethod.delete:
        return dio.delete(path,
            queryParameters: query, data: body, options: options);
    }
  }

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

  Future<void> setToken(String accessToken, String refreshToken) async {
    await Future.wait([
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
