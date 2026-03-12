import 'package:widyu/core/model/api/api_response.dart';
import 'package:dio/dio.dart';

extension ApiResponseExtension on Response {
  ApiResponse<T> toApiResponse<T>(
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ApiResponse<T>.fromJson(statusCode, data, fromJson);
  }
}
