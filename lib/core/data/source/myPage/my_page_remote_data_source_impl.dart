import 'dart:io';

import 'package:dio/dio.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/myPage/contact/contact.dart';
import 'package:widyu/core/model/myPage/point/point_history.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/model/myPage/profile/user_profile.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class MyPageRemoteDataSourceImpl extends MyPageRemoteDataSource {
  final ApiClient _apiClient;

  MyPageRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/mypage/senior';

  @override
  Future<ApiResponse<User>> fetchUser() async {
    try {
      final response =
          await _apiClient.req(path: _path, method: HttpMethod.get);
      return response.toApiResponse(User.fromJson);
    } catch (e) {
      throw Exception("내 정보 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<UserProfile>> fetchUserProfile() async {
    try {
      final response =
          await _apiClient.req(path: '$_path/profile', method: HttpMethod.get);
      return response.toApiResponse(UserProfile.fromJson);
    } catch (e) {
      throw Exception("프로필 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> updateName(String name) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/profile/name',
        method: HttpMethod.patch,
        body: {
          'name': name,
        },
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("이름 변경에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> updateProfileImage(File profileImage) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          profileImage.path,
          filename: profileImage.path.split('/').last,
        ),
      });
      final response = await _apiClient.req(
        path: '$_path/profile/image',
        method: HttpMethod.patch,
        body: formData,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("프로필 이미지 변경에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<PointHistory>> fetchPointHistory() async {
    try {
      final response = await _apiClient.req(
        path: '$_path/points/history',
        method: HttpMethod.get,
      );
      return response.toApiResponse(PointHistory.fromJson);
    } catch (e) {
      throw Exception("포인트 내역 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<Contact>> fetchContact() async {
    try {
      final response = await _apiClient.req(
        path: '$_path/emergency-contact',
        method: HttpMethod.get,
      );
      return response.toApiResponse(Contact.fromJson);
    } catch (e) {
      throw Exception("연락처 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> updateRepresentativeContact(int memberId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/emergency-contact/$memberId',
        method: HttpMethod.patch,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("대표 연락처 변경에 실패했습니다: $e");
    }
  }
}
