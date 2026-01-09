import 'package:widyu/core/data/models/api_response.dart';
import 'package:dio/dio.dart';

extension ApiResponseExtension on Response {
  ApiResponse<T> toApiResponse<T>(
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ApiResponse<T>.fromJson(statusCode, data, fromJson);
  }
}
