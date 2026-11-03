import 'package:dio/dio.dart';
import 'package:widyu/core/log/log.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final headers = {
      ...options.headers,
      if (options.headers.containsKey('Authorization')) 'Authorization': '***',
    };
    WiduLog.network.d(
        'Request: ${options.method} ${options.path} / Headers: $headers / Query Parameters: ${options.queryParameters} / Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    WiduLog.network.d(
        'Response: ${response.statusCode} ${response.statusMessage} / Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    WiduLog.network.d('Error: ${err.type.name}',
        error: err, stackTrace: err.stackTrace);
    super.onError(err, handler);
  }
}
