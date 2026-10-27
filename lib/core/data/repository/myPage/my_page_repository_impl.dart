import 'dart:io';

import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/code/family_code.dart';
import 'package:widyu/core/model/myPage/contact/contact.dart';
import 'package:widyu/core/model/myPage/point/point_history.dart';
import 'package:widyu/core/model/myPage/profile/user_profile.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class MyPageRepositoryImpl extends MyPageRepository {
  final MyPageRemoteDataSource _remoteDataSource;

  MyPageRepositoryImpl({required MyPageRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<User>> fetchUser() async =>
      _remoteDataSource.fetchUser().toApiResult();

  @override
  Future<ApiResult<UserProfile>> fetchUserProfile() async =>
      _remoteDataSource.fetchUserProfile().toApiResult();

  @override
  Future<ApiResult<void>> updateName(String name) async =>
      _remoteDataSource.updateName(name).toApiResult();

  @override
  Future<ApiResult<void>> updateProfileImage(File profileImage) async =>
      _remoteDataSource.updateProfileImage(profileImage).toApiResult();

  @override
  Future<ApiResult<PointHistory>> fetchPointHistory() async =>
      _remoteDataSource.fetchPointHistory().toApiResult();

  @override
  Future<ApiResult<Contact>> fetchContact() async =>
      _remoteDataSource.fetchContact().toApiResult();

  @override
  Future<ApiResult<void>> updateRepresentativeContact(int memberId) async =>
      _remoteDataSource.updateRepresentativeContact(memberId).toApiResult();

  @override
  Future<ApiResult<FamilyCode>> fetchFamilyCode() async =>
      _remoteDataSource.fetchFamilyCode().toApiResult();
}
