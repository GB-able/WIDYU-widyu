import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/home/senior_card.dart';

abstract class HomeRemoteDataSource {
  Future<ApiResponse<SeniorCard>> fetchSeniorCard();
}
