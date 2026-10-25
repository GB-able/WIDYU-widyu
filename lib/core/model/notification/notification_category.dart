import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_category.freezed.dart';
part 'notification_category.g.dart';

@freezed
abstract class NotificationCategory with _$NotificationCategory {
  const factory NotificationCategory({
    required String label,
    required String name,
    required int count,
  }) = _NotificationCategory;

  factory NotificationCategory.fromJson(Map<String, dynamic> json) =>
      _$NotificationCategoryFromJson(json);
}
