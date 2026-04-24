import 'package:widyu/core/data/source/myPage/my_page_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/myPage/user.dart';
import 'package:widyu/core/model/myPage/user_profile.dart';
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
}
