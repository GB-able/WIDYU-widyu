import 'package:widyu/core/data/models/api_response.dart';
import 'package:widyu/core/data/models/api_result.dart';

extension ApiResponseHandler<T> on Future<ApiResponse<T>> {
  Future<ApiResult<T>> toApiResult() async {
    try {
      final response = await this;
      if (response.isSuccess) return Success(response.data as T);
      return Failure(response.message,
          statusCode: response.statusCode, code: response.code);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
