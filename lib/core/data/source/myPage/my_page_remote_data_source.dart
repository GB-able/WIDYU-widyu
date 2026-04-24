import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/myPage/user.dart';
import 'package:widyu/core/model/myPage/user_profile.dart';

abstract class MyPageRemoteDataSource {
  Future<ApiResponse<User>> fetchUser();

  Future<ApiResponse<UserProfile>> fetchUserProfile();
}
