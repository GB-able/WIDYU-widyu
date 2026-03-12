import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/heartRate/heart_rate_request.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/socket_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class HeartRateRemoteDataSourceImpl implements HeartRateRemoteDataSource {
  final SocketClient _socketClient;
  final ApiClient _apiClient;

  HeartRateRemoteDataSourceImpl(
      {required SocketClient socketClient, required ApiClient apiClient})
      : _socketClient = socketClient,
        _apiClient = apiClient;

  static const _path = "/heart-rate/status";

  @override
  void sendHeartRates(HeartRateRequest heartRateRequest) {
    _socketClient.sendHeartRates(heartRateRequest);
  }

  @override
  Future<ApiResponse<HeartRateResponse>> fetchHeartRateStatus() async {
    try {
      final response = await _apiClient.req(
        path: _path,
        method: HttpMethod.get,
        body: {'memberId': ''},
      );
      return response.toApiResponse(HeartRateResponse.fromJson);
    } catch (e) {
      throw Exception("Failed to Fetch Heart Rate Status: $e");
    }
  }
}
