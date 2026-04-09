class ApiResponse<T> {
  final int? statusCode;
  final String code;
  final String message;
  final T? data;

  ApiResponse({
    required this.statusCode,
    required this.code,
    required this.message,
    this.data,
  });

  bool get isSuccess => statusCode == 200 || statusCode == 201;

  factory ApiResponse.fromJson(
    int? statusCode,
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      statusCode: statusCode,
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
