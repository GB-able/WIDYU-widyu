import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/notification/notification_category.dart';
import 'package:widyu/core/utils/infinite_scroll.dart';
import 'package:widyu/feature/notification/notification_ui_model.dart';

part 'notification_ui_state.freezed.dart';

@freezed
abstract class NotificationUiState with _$NotificationUiState {
  const NotificationUiState._();

  const factory NotificationUiState({
    @Default('ALL') String category,
    @Default([]) List<NotificationCategory> categories,
    @Default(InfiniteScrollState<NotificationItemUiModel>())
    InfiniteScrollState<NotificationItemUiModel> list,
  }) = _NotificationUiState;

  String nameOf(String label) =>
      categories.where((c) => c.label == label).firstOrNull?.name ?? '';
}
