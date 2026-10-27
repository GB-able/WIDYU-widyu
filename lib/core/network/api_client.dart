import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/network/logger_interceptor.dart';
import 'package:widyu/core/network/token_interceptor.dart';
import 'package:widyu/core/network/token_manager.dart';

enum HttpMethod { get, post, put, patch, delete }

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  static String baseUrl = dotenv.env['BASE_URL']!;
  static const String apiPrefix = '/api';
  final Dio dio = Dio();

  ApiClient._internal() {
    dio.options = BaseOptions(
        baseUrl: '$baseUrl$apiPrefix',
        validateStatus: (status) => status != null);
    dio.interceptors.add(TokenInterceptor());
    // 통신 본문·인증 헤더는 디버그 빌드에서만 남긴다(법적 요건 L1).
    if (kDebugMode) dio.interceptors.add(LoggerInterceptor());
  }

  Future<Response<dynamic>> req({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? query,
    Object? body,
    int version = 1,
    TokenType tokenType = TokenType.access,
  }) {
    path = '/v$version$path';
    final isMultiPart = body is FormData;
    final options = Options(
      extra: {'tokenType': tokenType},
      contentType: isMultiPart ? 'multipart/form-data' : 'application/json',
    );

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
}
