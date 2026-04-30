import 'dart:io';

import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/model/myPage/profile/user_profile.dart';

abstract class MyPageRemoteDataSource {
  Future<ApiResponse<User>> fetchUser();

  Future<ApiResponse<UserProfile>> fetchUserProfile();

  Future<ApiResponse<void>> updateName(String name);

  Future<ApiResponse<void>> updateProfileImage(File profileImage);
}
