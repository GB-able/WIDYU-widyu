import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/token/token_pair.dart';
import 'package:widyu/core/network/token_manager.dart';

class TokenInterceptor extends Interceptor {
  final TokenManager _tokenManager = TokenManager();

  late final Dio _dio;
  Future<String>? _reissuing;

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
        token = await _tokenManager.accessToken;
        break;
      case TokenType.temporary:
        token = await _tokenManager.tempToken;
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
    if (err.response?.statusCode != 401 || tokenType != TokenType.access) {
      return super.onError(err, handler);
    }

    final String newAccessToken;
    try {
      newAccessToken = await (_reissuing ??=
          _reissueOrLogout().whenComplete(() => _reissuing = null));
    } catch (_) {
      return super.onError(err, handler);
    }

    try {
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      handler.resolve(await _dio.fetch<dynamic>(err.requestOptions));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String> _reissueOrLogout() async {
    try {
      final token = await _reissue();
      WiduLog.network.i('토큰 재발급 성공');
      return token;
    } catch (e, stack) {
      final rejected = e is _NoRefreshToken ||
          (e is DioException && e.response?.statusCode == 401);
      if (rejected) {
        WiduLog.network.w('리프레시 토큰 거절로 토큰 삭제', error: e, stackTrace: stack);
        await _tokenManager.removeAll();
      } else {
        WiduLog.network.w('토큰 재발급 실패, 토큰 유지', error: e, stackTrace: stack);
      }
      rethrow;
    }
  }

  Future<String> _reissue() async {
    final refreshToken = await _tokenManager.refreshToken;
    if (refreshToken == null) {
      throw _NoRefreshToken();
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/auth/reissue',
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode != 200) {
      throw Exception('Token refresh failed: ${response.statusCode}');
    }

    final tokens = TokenPair.fromJson(response.data!);
    await _tokenManager.setToken(tokens.accessToken, tokens.refreshToken);

    return tokens.accessToken;
  }
}

class _NoRefreshToken implements Exception {}
