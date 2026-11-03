import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/incident/incident_respond_result.dart';
import 'package:widyu/core/model/incident/prompt_displayed_result.dart';

abstract class IncidentRepository {
  Future<ApiResult<PromptDisplayedResult>> markPromptDisplayed(
      String incidentId);

  Future<ApiResult<IncidentRespondResult>> respondOk(String incidentId);
}
