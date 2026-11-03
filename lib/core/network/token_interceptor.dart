import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/token/token_pair.dart';
import 'package:widyu/core/network/token_manager.dart';

class TokenInterceptor extends Interceptor {
  final TokenManager _tokenManager = TokenManager();

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
    if (err.response?.statusCode == 401 && tokenType == TokenType.access) {
      try {
        String newAccessToken;

        if (_reissueCompleter != null) {
          try {
            newAccessToken = await _reissueCompleter!.future;
          } catch (e) {
            await _tokenManager.removeToken();
            super.onError(err, handler);
            return;
          }
        } else {
          _reissueCompleter = Completer<String>();
          try {
            newAccessToken = await _reissue();
            WiduLog.network.i('토큰 재발급 성공');
            _reissueCompleter!.complete(newAccessToken);
          } catch (e) {
            _reissueCompleter!.completeError(e);
            rethrow;
          } finally {
            _reissueCompleter = null;
          }
        }

        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _dio.fetch<dynamic>(err.requestOptions);
        handler.resolve(retryResponse);
        return;
      } catch (e, stack) {
        // 재발급이나 재요청이 실패하면 토큰을 모두 지우므로 사실상 로그아웃된다.
        WiduLog.network.w('토큰 재발급·재요청 실패로 토큰 삭제', error: e, stackTrace: stack);
        await _tokenManager.removeAll();
        super.onError(err, handler);
        return;
      }
    }

    super.onError(err, handler);
  }

  Future<String> _reissue() async {
    final refreshToken = await _tokenManager.refreshToken;
    if (refreshToken == null) {
      throw Exception('No refresh token');
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
