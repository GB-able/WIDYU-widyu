import 'package:freezed_annotation/freezed_annotation.dart';

part 'hospital.freezed.dart';
part 'hospital.g.dart';

@freezed
abstract class Hospital with _$Hospital {
  const factory Hospital({
    required int hospitalScheduleId,
    required int dday,
    required DateTime datetime,
    required String name,
    required String address,
    required double? latitude,
    required double? longitude,
    bool? isReward, // [TODO] 변경 예정
  }) = _Hospital;

  factory Hospital.fromJson(Map<String, dynamic> json) =>
      _$HospitalFromJson(json);
}
