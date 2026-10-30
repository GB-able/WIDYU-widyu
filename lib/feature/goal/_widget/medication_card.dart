import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_network_image.dart';
import 'package:widyu/core/ui/widgets/dash_border.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/utils/extensions/duration_extension.dart';
import 'package:widyu/core/utils/extensions/string_extension.dart';
import 'package:widyu/core/utils/medication_verification_launcher.dart';
import 'package:widyu/feature/goal/_widget/icon_tile.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';
import 'package:widyu/gen/assets.gen.dart';

const _boxHeight = 100.0;
const _boxRadius = 10.0;

enum _VerifyState {
  beforeOpen,
  open,
  openDone,
  expiredDone,
  expiredFailed;

  bool get isDone => this == openDone || this == expiredDone;
  bool get isExpired => this == expiredDone || this == expiredFailed;
  bool get isFailed => this == expiredFailed;
}

class MedicationCard extends StatelessWidget {
  const MedicationCard({
    super.key,
    required this.medicine,
    required this.proofPhoto,
    required this.verifyRemaining,
    required this.onVerified,
  });

  final Medication medicine;
  final File? proofPhoto;
  final Duration verifyRemaining;
  final ValueChanged<MedicationPointResult> onVerified;

  _VerifyState _resolveState(DateTime now) {
    if (medicine.isDoneAt(now)) {
      return medicine.isVerifyExpiredAt(now)
          ? _VerifyState.expiredDone
          : _VerifyState.openDone;
    }
    if (medicine.isVerifyOpenAt(now)) return _VerifyState.open;
    if (medicine.isVerifyExpiredAt(now)) return _VerifyState.expiredFailed;
    return _VerifyState.beforeOpen;
  }

  @override
  Widget build(BuildContext context) {
    final now = clock.now();
    final state = _resolveState(now);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 12,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              spacing: 16,
              children: [
                IconTile(type: GoalType.medicine, isFailed: state.isFailed),
                Text(
                  '약 복용',
                  style: MyTypo.title3.copyWith(color: MyColor.black),
                ),
                Expanded(
                  child: Text(
                    '${medicine.takenCount}/${medicine.totalCount}회',
                    style: MyTypo.title3.copyWith(
                      color: MyColor.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _VerifyCard(
              state: state,
              alarmTime: medicine.alarmTimeAt(now),
              doseCount: medicine.doseCountAt(now),
              proofImage: medicine.proofImageAt(now),
              proofPhoto: proofPhoto,
              verifyRemaining: verifyRemaining,
              onOpenVerification: () async {
                final tapped = clock.now();
                final result = await openMedicationForSchedule(
                    context, medicine.scheduleIdAt(tapped), tapped,
                    doseCount: medicine.doseCountAt(tapped));
                if (result != null) onVerified(result);
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: CardEditBtn(onTap: () {}),
          // ),
        ],
      ),
    );
  }
}

class _VerifyCard extends StatelessWidget {
  const _VerifyCard({
    required this.state,
    required this.alarmTime,
    required this.doseCount,
    required this.proofImage,
    required this.proofPhoto,
    required this.verifyRemaining,
    required this.onOpenVerification,
  });

  final _VerifyState state;
  final String alarmTime;
  final int doseCount;
  final String? proofImage;
  final File? proofPhoto;
  final Duration verifyRemaining;
  final VoidCallback onOpenVerification;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        switch (state) {
          _VerifyState.beforeOpen => _VerifyPhotoBox(
              doseCount: doseCount,
              verifyRemaining: verifyRemaining,
              onTap: null,
            ),
          _VerifyState.open => _VerifyPhotoBox(
              doseCount: doseCount,
              verifyRemaining: verifyRemaining,
              onTap: onOpenVerification,
            ),
          _VerifyState.openDone || _VerifyState.expiredDone => _VerifyDoneBox(
              proofImage: proofImage,
              proofPhoto: proofPhoto,
              doseCount: doseCount,
            ),
          _VerifyState.expiredFailed => const _VerifyEmptyBox(),
        },
        _AlarmTimeRow(alarmTime: alarmTime, state: state),
      ],
    );
  }
}

class _VerifyPhotoBox extends StatelessWidget {
  const _VerifyPhotoBox({
    required this.doseCount,
    required this.verifyRemaining,
    required this.onTap,
  });

  final int doseCount;
  final Duration verifyRemaining;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        foregroundPainter: const DashBorder(
          color: MyColor.orange200,
          radius: _boxRadius,
        ),
        child: Container(
          height: _boxHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: MyColor.orange50,
            borderRadius: BorderRadius.circular(_boxRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: MyColor.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: MyColor.primary)),
                alignment: Alignment.center,
                child: WiduIcon(
                  icon: Assets.icons.ic24CameraAdd,
                  width: 24,
                  height: 24,
                  color: MyColor.orange600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$doseCount정 복용예정',
                style: MyTypo.body2.copyWith(color: MyColor.orange500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    onTap == null ? '다음 인증까지' : '인증가능 시간',
                    style: MyTypo.subTitle7.copyWith(
                      color: MyColor.grey500,
                    ),
                  ),
                  Text(
                    verifyRemaining.str,
                    style: MyTypo.helper.copyWith(color: MyColor.grey600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerifyDoneBox extends StatelessWidget {
  const _VerifyDoneBox({
    required this.proofImage,
    required this.proofPhoto,
    required this.doseCount,
  });

  final String? proofImage;
  final File? proofPhoto;
  final int doseCount;

  @override
  Widget build(BuildContext context) {
    final photo = proofPhoto;

    return ClipRRect(
      borderRadius: BorderRadius.circular(_boxRadius),
      child: Stack(
        children: [
          if (photo != null)
            Image.file(
              photo,
              width: double.infinity,
              height: _boxHeight,
              fit: BoxFit.cover,
            )
          else
            CustomNetworkImage(
              url: proofImage,
              width: double.infinity,
              height: _boxHeight,
            ),
          Container(
            width: double.infinity,
            height: _boxHeight,
            alignment: Alignment.center,
            color: MyColor.black.withValues(alpha: 0.5),
            child: Text(
              '$doseCount정 복용완료',
              style: MyTypo.title3.copyWith(color: MyColor.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyEmptyBox extends StatelessWidget {
  const _VerifyEmptyBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _boxHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColor.grey100,
        borderRadius: BorderRadius.circular(_boxRadius),
      ),
      child: Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.img40MedicineDisabled.image(
            width: 40,
            height: 40,
          ),
          Text(
            '미복용',
            style: MyTypo.body2.copyWith(color: MyColor.grey500),
          )
        ],
      ),
    );
  }
}

class _AlarmTimeRow extends StatelessWidget {
  const _AlarmTimeRow({
    required this.alarmTime,
    required this.state,
  });

  final String alarmTime;
  final _VerifyState state;

  @override
  Widget build(BuildContext context) {
    final color =
        state.isDone || state.isExpired ? MyColor.grey700 : MyColor.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        WiduIcon(icon: Assets.icons.ic20Time, width: 20, color: color),
        Text(
          alarmTime.twelveHourTime,
          style: MyTypo.subTitle1.copyWith(
            color: color,
            decoration: state.isFailed ? TextDecoration.lineThrough : null,
          ),
        )
      ],
    );
  }
}
