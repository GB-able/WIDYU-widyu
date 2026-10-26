import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';

class MedicationRingingScreen extends StatefulWidget {
  const MedicationRingingScreen({
    super.key,
    required this.group,
    required this.busy,
    required this.onVerify,
    required this.onStop,
  });

  final Map<String, dynamic> group;
  final bool busy;
  final VoidCallback onVerify;
  final VoidCallback onStop;

  @override
  State<MedicationRingingScreen> createState() =>
      _MedicationRingingScreenState();
}

class _MedicationRingingScreenState extends State<MedicationRingingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final occurrences = widget.group['occurrences'];
    final dose = occurrences is List
        ? occurrences.fold<double>(0, (sum, item) {
            if (item is! Map || item['doseCount'] is! num) return sum;
            return sum + (item['doseCount'] as num).toDouble();
          })
        : 0.0;
    final doseLabel = dose == dose.truncateToDouble()
        ? dose.toInt().toString()
        : dose.toStringAsFixed(1);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: MyColor.dim,
          body: SafeArea(
            child: Column(children: [
              const SizedBox(height: 24),
              Image.asset('assets/images/img_64_logo.png',
                  width: 64, fit: BoxFit.contain),
              const Spacer(flex: 5),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/img_93_mascot_medicine.png',
                        width: 93, fit: BoxFit.contain),
                    const SizedBox(height: 12),
                    Text('$doseLabel정',
                        style: MyTypo.title1.copyWith(color: MyColor.primary)),
                    const SizedBox(height: 4),
                    Text('복용하실 시간이에요!',
                        style: MyTypo.subTitle6.copyWith(color: MyColor.white)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 234,
                      height: 56,
                      child: FilledButton(
                        onPressed: widget.busy ? null : widget.onVerify,
                        style: FilledButton.styleFrom(
                          backgroundColor: MyColor.primary,
                          foregroundColor: MyColor.white,
                          disabledBackgroundColor: MyColor.grey300,
                          shape: const StadiumBorder(),
                        ),
                        child: Text('인증 하러 가기',
                            style:
                                MyTypo.title3.copyWith(color: MyColor.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 8),
              SizedBox(
                width: 95,
                height: 41,
                child: FilledButton(
                  onPressed: widget.busy ? null : widget.onStop,
                  style: FilledButton.styleFrom(
                    backgroundColor: MyColor.grey800,
                    foregroundColor: MyColor.white,
                    disabledBackgroundColor: MyColor.grey300,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    '중단',
                    style: MyTypo.subTitle2.copyWith(color: MyColor.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ),
    );
  }
}
