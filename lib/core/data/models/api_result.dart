sealed class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final int? statusCode;
  final String? code;
  final String message;
  const Failure(this.message, {this.statusCode, this.code});
}
