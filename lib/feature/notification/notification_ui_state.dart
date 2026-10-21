import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/feature/notification/notification_ui_model.dart';

part 'notification_ui_state.freezed.dart';

@freezed
abstract class NotificationUiState with _$NotificationUiState {
  const NotificationUiState._();

  const factory NotificationUiState({
    @Default(NotificationFilter.all) NotificationFilter filter,
    @Default({}) Map<NotificationFilter, int> counts,
  }) = _NotificationUiState;

  int countOf(NotificationFilter filter) => counts[filter] ?? 0;
}
