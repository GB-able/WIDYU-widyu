import 'package:freezed_annotation/freezed_annotation.dart';

enum NotificationGroup {
  @JsonValue('GOAL')
  goal,
  @JsonValue('ALBUM')
  album,
  @JsonValue('HOME')
  home,
  @JsonValue('ETC')
  etc,
}
