// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicationVerification _$MedicationVerificationFromJson(
        Map<String, dynamic> json) =>
    _MedicationVerification(
      earnedPoints: (json['earnedPoints'] as num).toInt(),
      currentPoints: (json['currentPoints'] as num).toInt(),
    );

Map<String, dynamic> _$MedicationVerificationToJson(
        _MedicationVerification instance) =>
    <String, dynamic>{
      'earnedPoints': instance.earnedPoints,
      'currentPoints': instance.currentPoints,
    };
