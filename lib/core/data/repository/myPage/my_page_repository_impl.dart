import 'dart:io';

import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/code/family_code.dart';
import 'package:widyu/core/model/myPage/contact/contact.dart';
import 'package:widyu/core/model/myPage/point/point_history.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/model/myPage/profile/user_profile.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class MyPageRepositoryImpl extends MyPageRepository {
  final MyPageRemoteDataSource _remoteDataSource;

  MyPageRepositoryImpl({required MyPageRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<User>> fetchUser() async =>
      await _remoteDataSource.fetchUser().toApiResult();

  @override
  Future<ApiResult<UserProfile>> fetchUserProfile() async =>
      await _remoteDataSource.fetchUserProfile().toApiResult();

  @override
  Future<ApiResult<void>> updateName(String name) async =>
      await _remoteDataSource.updateName(name).toApiResult();

  @override
  Future<ApiResult<void>> updateProfileImage(File profileImage) async =>
      await _remoteDataSource.updateProfileImage(profileImage).toApiResult();

  @override
  Future<ApiResult<PointHistory>> fetchPointHistory() async =>
      await _remoteDataSource.fetchPointHistory().toApiResult();

  @override
  Future<ApiResult<Contact>> fetchContact() async =>
      await _remoteDataSource.fetchContact().toApiResult();

  @override
  Future<ApiResult<void>> updateRepresentativeContact(int memberId) async =>
      await _remoteDataSource
          .updateRepresentativeContact(memberId)
          .toApiResult();

  @override
  Future<ApiResult<FamilyCode>> fetchFamilyCode() async =>
      await _remoteDataSource.fetchFamilyCode().toApiResult();
}
