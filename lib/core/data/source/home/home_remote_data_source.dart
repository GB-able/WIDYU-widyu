import 'dart:io';

import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/home/medication_verification.dart';
import 'package:widyu/core/model/home/senior_card.dart';

abstract class HomeRemoteDataSource {
  Future<ApiResponse<SeniorCard>> fetchSeniorCard();

  Future<ApiResponse<MedicationVerification>> verifyMedication(
    int scheduleId,
    File image,
  );
}
