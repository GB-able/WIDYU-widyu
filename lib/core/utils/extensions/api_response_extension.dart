import 'package:widyu/core/model/api/api_response.dart';
import 'package:dio/dio.dart';

extension ApiResponseExtension on Response {
  ApiResponse<T> toApiResponse<T>(
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ApiResponse<T>.fromJson(statusCode, data, fromJson);
  }

  ApiResponse<List<T>> toApiResponses<T>(
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final raw = data as Map<String, dynamic>;
    final items = (raw['data'] as List<dynamic>? ?? [])
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
    return ApiResponse<List<T>>(
      statusCode: statusCode,
      code: raw['code'] as String,
      message: raw['message'] as String,
      data: items,
    );
  }

  ApiResponse<List<T>> toApiResponsePrimitives<T>() {
    final raw = data as Map<String, dynamic>;
    return ApiResponse<List<T>>(
      statusCode: statusCode,
      code: raw['code'] as String,
      message: raw['message'] as String,
      data: (raw['data'] as List<dynamic>? ?? []).cast<T>(),
    );
  }
}
