import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/api/api_result.dart';

extension ApiResponseHandler<T> on Future<ApiResponse<T>> {
  Future<ApiResult<T>> toApiResult() async {
    try {
      final response = await this;
      if (response.isSuccess) return Success(response.data as T);
      // message는 서버 자유 문구라 남기지 않는다(docs/logging-strategy.md §5).
      WiduLog.data.w(
          'API 실패 status=${response.statusCode} code=${response.code}');
      return Failure(response.message,
          statusCode: response.statusCode, code: response.code);
    } catch (e, stack) {
      WiduLog.data.w('API 예외', error: e, stackTrace: stack);
      return Failure(e.toString());
    }
  }
}
