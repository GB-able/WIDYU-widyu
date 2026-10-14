import 'dart:io';

import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/home/medication_verification.dart';
import 'package:widyu/core/model/home/senior_card.dart';

abstract class HomeRepository {
  Future<ApiResult<SeniorCard>> fetchSeniorCard();

  Future<ApiResult<MedicationVerification>> verifyMedication(
    int scheduleId,
    File image,
  );
}
