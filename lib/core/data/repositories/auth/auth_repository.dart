import 'package:widyu/core/data/models/api_result.dart';

abstract class AuthRepository {
  Future<ApiResult<void>> login(String inviteCode, String phoneNumber);
  Future<ApiResult<void>> logout();
}
