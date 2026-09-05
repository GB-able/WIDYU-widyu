import 'package:widyu/core/model/api/api_result.dart';

abstract class WalkRepository {
  Future<bool> ensurePermission();

  Stream<int> observeStepDelta();

  Future<ApiResult<bool>> syncSteps(int steps);
}
