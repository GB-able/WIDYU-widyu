import 'package:widyu/core/data/repository/incident/incident_repository.dart';
import 'package:widyu/core/data/source/incident/incident_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/incident/incident_respond_result.dart';
import 'package:widyu/core/model/incident/prompt_displayed_result.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDataSource _remoteDataSource;

  IncidentRepositoryImpl({required IncidentRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<PromptDisplayedResult>> markPromptDisplayed(
          String incidentId) async =>
      _remoteDataSource.markPromptDisplayed(incidentId).toApiResult();

  @override
  Future<ApiResult<IncidentRespondResult>> respondOk(String incidentId) async =>
      _remoteDataSource.respondOk(incidentId).toApiResult();
}
