import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/incident/incident_respond_result.dart';
import 'package:widyu/core/model/incident/prompt_displayed_result.dart';

abstract class IncidentRemoteDataSource {
  Future<ApiResponse<PromptDisplayedResult>> markPromptDisplayed(
      String incidentId);

  Future<ApiResponse<IncidentRespondResult>> respondOk(String incidentId);
}
