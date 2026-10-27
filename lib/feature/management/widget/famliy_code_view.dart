part of '../management_screen.dart';

class _FamilyCodeView extends StatelessWidget {
  final String familyCode;

  const _FamilyCodeView({required this.familyCode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '가족코드 6자리',
          style: MyTypo.title3.copyWith(color: MyColor.grey900),
        ),
        const SizedBox(height: 16),
        Row(
          children: familyCode
              .split('')
              .map(
                (digit) => Expanded(
                  child: Center(
                    child: Text(
                      digit,
                      style: MyTypo.largeTitle.copyWith(color: MyColor.black),
                    ),
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
