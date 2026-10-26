import 'package:widyu/core/data/source/incident/incident_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/incident/incident_respond_result.dart';
import 'package:widyu/core/model/incident/prompt_displayed_result.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class IncidentRemoteDataSourceImpl implements IncidentRemoteDataSource {
  final ApiClient _apiClient;

  IncidentRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/incidents';
  static const String _via = 'PHONE';

  @override
  Future<ApiResponse<PromptDisplayedResult>> markPromptDisplayed(
      String incidentId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$incidentId/prompt-displayed',
        method: HttpMethod.post,
        body: {'via': _via},
      );
      return response.toApiResponse(PromptDisplayedResult.fromJson);
    } catch (e) {
      throw Exception('본인확인 화면 수신 처리에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<IncidentRespondResult>> respondOk(
      String incidentId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$incidentId/response',
        method: HttpMethod.post,
        body: {
          'response': 'OK',
          'via': _via,
          'deviceRespondedAtMs': DateTime.now().millisecondsSinceEpoch,
        },
      );
      return response.toApiResponse(IncidentRespondResult.fromJson);
    } catch (e) {
      throw Exception('본인확인 응답에 실패했습니다: $e');
    }
  }
}
