import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

    final response = await _dio.post(
      '/v1/auth/reissue',
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode != 200) {
      throw Exception('Token refresh failed: ${response.statusCode}');
    }

    final tokens = TokenPair.fromJson(response.data);
    await _tokenManager.setToken(tokens.accessToken, tokens.refreshToken);

    return tokens.accessToken;
  }
}
