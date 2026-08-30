import 'package:widyu/core/model/api/api_result.dart';

abstract class PointRepository {
  Future<ApiResult<int>> fetchPoints();
}
