import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/data/models/token_pair.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/storage/secure_storage.dart';
import 'package:widyu/core/storage/storage_key.dart';

class TokenInterceptor extends Interceptor {
  final SecureStorage _secureStorage = SecureStorage();
  late final Dio _dio;
  Completer<String>? _reissueCompleter;

  TokenInterceptor() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      headers: {'Content-Type': 'application/json'},
    ));
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokenType = options.extra['tokenType'] as TokenType;
    String? token;

    switch (tokenType) {
      case TokenType.none:
        break;
      case TokenType.access:
        token =
            await _secureStorage.storage.read(key: StorageKey.accessToken.name);
        break;
      case TokenType.temporary:
        token =
            await _secureStorage.storage.read(key: StorageKey.tempToken.name);
        break;
    }

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final tokenType = err.requestOptions.extra['tokenType'] as TokenType;
    if (err.response?.statusCode == 401 && tokenType == TokenType.access) {
      try {
        String newAccessToken;

        if (_reissueCompleter != null) {
          try {
            newAccessToken = await _reissueCompleter!.future;
          } catch (e) {
            await _secureStorage.storage.deleteAll();
            super.onError(err, handler);
            return;
          }
        } else {
          _reissueCompleter = Completer<String>();
          try {
            newAccessToken = await _reissue();
            _reissueCompleter!.complete(newAccessToken);
          } catch (e) {
            _reissueCompleter!.completeError(e);
            rethrow;
          } finally {
            _reissueCompleter = null;
          }
        }

        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _dio.fetch(err.requestOptions);
        handler.resolve(retryResponse);
        return;
      } catch (e) {
        await _secureStorage.storage.delete(key: StorageKey.accessToken.name);
        await _secureStorage.storage.delete(key: StorageKey.refreshToken.name);
        await _secureStorage.storage.delete(key: StorageKey.tempToken.name);
        super.onError(err, handler);
        return;
      }
    }

    super.onError(err, handler);
  }

  Future<String> _reissue() async {
    final refreshToken =
        await _secureStorage.storage.read(key: StorageKey.refreshToken.name);
    if (refreshToken == null) {
      throw Exception('No refresh token');
    }

    final response = await _dio.post(
      '/v1/auth/reissue',
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode != 200) {
      throw Exception('Token refresh failed: ${response.statusCode}');
    }

    final tokens = TokenPair.fromJson(response.data);

    await _secureStorage.storage
        .write(key: StorageKey.accessToken.name, value: tokens.accessToken);
    await _secureStorage.storage
        .write(key: StorageKey.refreshToken.name, value: tokens.refreshToken);

    return tokens.accessToken;
  }
}
