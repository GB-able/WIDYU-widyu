// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Point _$PointFromJson(Map<String, dynamic> json) => _Point(
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PointToJson(_Point instance) => <String, dynamic>{
      'type': instance.type,
      'amount': instance.amount,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };
