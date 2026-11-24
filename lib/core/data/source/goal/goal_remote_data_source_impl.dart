import 'package:widyu/core/data/source/goal/goal_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/monthly/daily_medicine_schedule.dart';
import 'package:widyu/core/model/goal/monthly/walk_daily.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/util/extension/api_response_extension.dart';
import 'package:widyu/core/util/extension/date_extension.dart';

class GoalRemoteDataSourceImpl extends GoalRemoteDataSource {
  final ApiClient _apiClient;

  GoalRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/goals/home';

  @override
  Future<ApiResponse<GoalHomeResponse>> fetchHomeCards() async {
    try {
      final response = await _apiClient.req(
        path: '$_path/senior',
        method: HttpMethod.get,
      );
      return response.toApiResponse(GoalHomeResponse.fromJson);
    } catch (e) {
      throw Exception('목표 홈 조회에 실패했습니다: $e');
    }
  }


  @override
  Future<ApiResponse<List<DateTime>>> fetchHealthScheduleDays({
    required int year,
    required int month,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '/goals/health-schedules/calendar/seniors',
        method: HttpMethod.get,
        query: {'year': year, 'month': month},
      );
      return response
          .toApiResponses((json) => DateTime.parse(json['day'] as String));
    } catch (e) {
      throw Exception('건강 일정 캘린더 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<List<DailyMedicineSchedule>>> fetchDailyMedicines(
      DateTime date) async {
    try {
      final response = await _apiClient.req(
        path: '/goals/medicine-schedules/daily',
        method: HttpMethod.get,
        query: {'date': date.onlyDate},
      );
      return response.toApiResponse(
        (json) => (json['medicineSchedules'] as List<dynamic>? ?? [])
            .map((e) =>
                DailyMedicineSchedule.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      throw Exception('일자별 약 복용 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<List<DailyHealthSchedule>>> fetchDailyHealthSchedules(
      DateTime date) async {
    try {
      final response = await _apiClient.req(
        path: '/goals/health-schedules/daily/seniors',
        method: HttpMethod.get,
        query: {'date': date.onlyDate},
      );
      return response.toApiResponses(DailyHealthSchedule.fromJson);
    } catch (e) {
      throw Exception('일자별 건강 일정 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<List<WalkDaily>>> fetchMonthlyWalks({
    required int year,
    required int month,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '/goals/walks/monthly',
        method: HttpMethod.get,
        query: {'year': year, 'month': month},
      );
      return response.toApiResponse(
        (json) => (json['dailyData'] as List<dynamic>? ?? [])
            .map((e) => WalkDaily.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      throw Exception('월별 걷기 현황 조회에 실패했습니다: $e');
    }
  }
}
