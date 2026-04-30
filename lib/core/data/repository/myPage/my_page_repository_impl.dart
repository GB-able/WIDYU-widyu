import 'dart:io';

import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user.dart';
import 'package:widyu/core/model/myPage/user_profile.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class MyPageRepositoryImpl extends MyPageRepository {
  final MyPageRemoteDataSource _remoteDataSource;

  MyPageRepositoryImpl({required MyPageRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<User>> fetchUser() async {
    return await _remoteDataSource.fetchUser().toApiResult();
  }

  @override
  Future<ApiResult<UserProfile>> fetchUserProfile() async {
    return await _remoteDataSource.fetchUserProfile().toApiResult();
  }

  @override
  Future<ApiResult<void>> updateName(String name) async {
    return await _remoteDataSource.updateName(name).toApiResult();
  }

  @override
  Future<ApiResult<void>> updateProfileImage(File profileImage) {
    return _remoteDataSource.updateProfileImage(profileImage).toApiResult();
  }
}
