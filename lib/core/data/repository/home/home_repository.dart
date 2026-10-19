import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/home/senior_card.dart';

abstract class HomeRepository {
  Future<ApiResult<SeniorCard>> fetchSeniorCard();
}
