import 'package:widyu/core/model/api/api_response.dart';

abstract class PointRemoteDataSource {
  Future<ApiResponse<int>> fetchPoints();
}
