import 'package:widyu/core/data/models/api_response.dart';
import 'package:widyu/core/data/models/token_pair.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class AuthRemoteDatasource {
  final ApiClient apiClient = ApiClient();
  final String path = '/auth';

  Future<ApiResponse<TokenPair>> login(
      String inviteCode, String phoneNumber) async {
    try {
      final response = await apiClient.req(
        '$path/seniors/sign-in',
        method: HttpMethod.post,
        body: {
          'inviteCode': inviteCode,
          'phoneNumber': phoneNumber,
        },
      );
      return response.toApiResponse(TokenPair.fromJson);
    } catch (e) {
      throw Exception(e);
    }
  }
}
