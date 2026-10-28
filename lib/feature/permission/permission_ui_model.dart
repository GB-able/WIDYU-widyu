import 'package:flutter/material.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/ui/widgets/permission_recovery_dialog.dart';
import 'package:widyu/gen/assets.gen.dart';

extension PermissionTypeDisplay on PermissionType {
  String get title => switch (this) {
        PermissionType.notification => '알림',
        PermissionType.alarm => '알람 및 리마인더',
        PermissionType.id => 'ID',
        PermissionType.phone => '전화',
        PermissionType.location => '위치',
        PermissionType.fitness => '동작 및 피트니스',
        PermissionType.camera => '카메라 및 저장 공간',
      };

  String get description => switch (this) {
        PermissionType.notification => '앱 알림, 공지 및 알람',
        PermissionType.alarm => '설정한 날짜 및 시간에 알람 생성',
        PermissionType.id => '기기 식별 및 광고 트래킹',
        PermissionType.phone => '전화번호 인증',
        PermissionType.location => '가족에게 위치 공유, 예약지 방문 시 알림, 활동 정보 및 주소 찾기',
        PermissionType.fitness => '실시간 걸음 수/활동 상태 측정',
        PermissionType.camera => '의약품 복용 촬영, 이미지 저장 및 글 작성 시 사진 첨부',
      };

  SvgGenImage get icon => switch (this) {
        PermissionType.notification => Assets.icons.ic18Notification,
        PermissionType.alarm => Assets.icons.ic18Alarm,
        PermissionType.id => Assets.icons.ic18Profile,
        PermissionType.phone => Assets.icons.ic18Phone,
        PermissionType.location => Assets.icons.ic18Location,
        PermissionType.fitness => Assets.icons.ic18Fitness,
        PermissionType.camera => Assets.icons.ic18Camera,
      };

  /// 앱 이용에 반드시 필요한 권한인지 여부.
  bool get isRequired => switch (this) {
        PermissionType.notification => true,
        PermissionType.alarm => true,
        PermissionType.id => true,
        PermissionType.phone => false,
        PermissionType.location => false,
        PermissionType.fitness => false,
        PermissionType.camera => false,
      };
}

/// 권한 재요청/설정 이동 안내 dialog 를 띄우고 사용자의 선택을 돌려준다.
/// 권한 화면과 홈 화면이 공용으로 쓰는 `PermissionRecoveryPrompt` 구현이다.
Future<PermissionRecoveryAction> showPermissionRecoveryPrompt(
  BuildContext context,
  PermissionType type,
  PermissionRecoveryMode mode,
) =>
    PermissionRecoveryDialog.show(
      context,
      permissionName: type.title,
      description: type.description,
      mode: mode,
    );
