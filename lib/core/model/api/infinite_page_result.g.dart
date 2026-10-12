// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infinite_page_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InfinitePageResult<T> _$InfinitePageResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _InfinitePageResult<T>(
      items: (json['items'] as List<dynamic>?)?.map(fromJsonT).toList() ??
          const [],
      nextCursor: json['nextCursor'] as String?,
      hasNext: json['hasNext'] as bool? ?? false,
    );

Map<String, dynamic> _$InfinitePageResultToJson<T>(
  _InfinitePageResult<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'items': instance.items.map(toJsonT).toList(),
      'nextCursor': instance.nextCursor,
      'hasNext': instance.hasNext,
    };
