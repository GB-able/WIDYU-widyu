import 'dart:io';

import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user.dart';
import 'package:widyu/core/model/myPage/user_profile.dart';

abstract class MyPageRepository {
  Future<ApiResult<User>> fetchUser();

  Future<ApiResult<UserProfile>> fetchUserProfile();

  Future<ApiResult<void>> updateName(String name);

  Future<ApiResult<void>> updateProfileImage(File profileImage);
}
